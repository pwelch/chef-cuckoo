#
# Cookbook Name:: cuckoo
# Recipe:: host
#

# Install support packages
package 'git'

# Install python
include_recipe 'poise-python'
python_runtime '2'

# Install additional python packages
%w{ python-dev libffi-dev libssl-dev }.each do |pkg|
  package pkg
end

# Install MongoDB for Django Web UI
package 'mongodb'

# TODO: Install Yara. Possibly Pydeep? https://downloads.cuckoosandbox.org/docs/installation/host/requirements.html

# Install setcap command
package 'libcap2-bin'

# Install and set tcpdump permissions
package 'tcpdump'

execute 'set_tcpdump_permissions' do
  command 'setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump'
  not_if  "getcap /usr/sbin/tcpdump | grep '/usr/sbin/tcpdump = cap_net_admin,cap_net_raw+eip'"
end

# Add cuckoo user
user 'cuckoo' do
  comment 'Cuckoo User'
  home    '/home/cuckoo'
end

# Clone latest cuckoo source code
git '/home/cuckoo/cuckoo' do
  repository 'https://github.com/cuckoosandbox/cuckoo.git'
  revision   '1.2'
  user       'cuckoo'
  action     :sync
end

# Install pip requirements
pip_requirements '/home/cuckoo/cuckoo/requirements.txt'

# TODO: Install volatility: https://downloads.cuckoosandbox.org/docs/installation/host/requirements.html#installing-volatility
# TODO: Add recipes for install kvm or vbox
# TODO: Add cuckoo user to kvm or vbox group
