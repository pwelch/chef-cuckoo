#
# Cookbook Name:: cuckoo
# Recipe:: _webui
#

# Install MongoDB for Django Web UI
package 'mongodb'

# Install supervisord for managing web process
# TODO: First converge fails for some reason...
include_recipe 'supervisor::default'

template '/etc/supervisor.d/cuckoo_web.conf' do
  source 'supervisor_cuckoo_web.conf.erb'
  owner 'root'
  group 'root'
  mode  '0644'
  variables({
    command:    'python manage.py runserver 0.0.0.0:8000',
    directory:  node[:cuckoo][:host][:source][:dest] + '/web',
    user:       node[:cuckoo][:host][:user],
    stderr_log: '/var/log/cuckoo_web.err.log',
    stdout_log: '/var/log/cuckoo_web.out.log'
  })
end
