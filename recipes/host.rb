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

# Install MongoDB for Django Web UI
package 'mongodb'

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
  repository node[:cuckoo][:host][:source][:repo]
  revision   node[:cuckoo][:host][:source][:revision]
  user       cuckoo_user
  action     :checkout
end

# Install pip requirements
pip_requirements "#{node[:cuckoo][:host][:source][:dest]}/requirements.txt"

# TODO: Install volatility: https://downloads.cuckoosandbox.org/docs/installation/host/requirements.html#installing-volatility
# TODO: Add recipes for install kvm or vbox
# TODO: Add cuckoo user to kvm or vbox group
# TODO: Install Yara. Possibly Pydeep? https://downloads.cuckoosandbox.org/docs/installation/host/requirements.html
