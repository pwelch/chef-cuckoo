#
# Cookbook Name:: cuckoo
# Recipe:: host
#

cuckoo_user      = node[:cuckoo][:host][:user]
cuckoo_user_home = node[:cuckoo][:host][:user_home]

# Install support packages
package 'git'

# Install python requirements
include_recipe 'cuckoo::_python'

# Install setcap command for tcpdump permissions
package 'libcap2-bin'

# Install and set tcpdump permissions
package 'tcpdump'

execute 'set_tcpdump_permissions' do
  command 'setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump'
  not_if  "getcap /usr/sbin/tcpdump | grep '/usr/sbin/tcpdump = cap_net_admin,cap_net_raw+eip'"
end

# Add cuckoo user
user cuckoo_user do
  comment     'Cuckoo User'
  home        cuckoo_user_home
  manage_home true
end

# Clone latest cuckoo source code
git node[:cuckoo][:host][:source][:dest] do
  repository      node[:cuckoo][:host][:source][:repo]
  revision        node[:cuckoo][:host][:source][:revision]
  checkout_branch node[:cuckoo][:host][:source][:revision]
  user            cuckoo_user
  group           cuckoo_user
  action          :checkout
end

# Install pip requirements
pip_requirements "#{node[:cuckoo][:host][:source][:dest]}/requirements.txt"

# Setup Cuckoo WebUI and API
include_recipe 'cuckoo::_web'

template "#{node[:cuckoo][:host][:source][:dest]}/conf/reporting.conf" do
  source 'reporting.conf.erb'
  owner cuckoo_user
  group cuckoo_user
  mode  '0644'
  variables({
    mongodb_enabled: true,
    mongodb_host:    '127.0.0.1',
    mongodb_port:    '27017',
    mongodb_db:      'cuckoo'
  })
end

if node[:cuckoo][:host][:vm][:install]
  case node[:cuckoo][:host][:vm][:type]
  when :virtualbox
    include_recipe 'cuckoo::_virtualbox'
  else
    Chef::Log.warn("Unknown VM Type: #{node[:cuckoo][:host][:vm][:type]}. Nothing installed!")
  end
end
