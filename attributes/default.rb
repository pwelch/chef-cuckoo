#
# Cookbook Name:: cuckoo
# Attribute:: default
#

# Host
default[:cuckoo][:host][:user]              = 'cuckoo'
default[:cuckoo][:host][:user_home]         = '/home/cuckoo'
default[:cuckoo][:host][:source][:repo]     = 'https://github.com/cuckoosandbox/cuckoo.git'
default[:cuckoo][:host][:source][:revision] = '2.0-rc1'
default[:cuckoo][:host][:source][:dest]     = node[:cuckoo][:host][:user_home] + '/cuckoo'

# Web
default[:cuckoo][:web][:dir]           = node[:cuckoo][:host][:source][:dest] + '/web'
default[:cuckoo][:web][:max_requests]  = '1000'
default[:cuckoo][:web][:uwsgi_socket]  = '127.0.0.1:8000'
default[:cuckoo][:web][:install_nginx] = true
default[:cuckoo][:web][:http_listen]   = '80'
default[:cuckoo][:web][:server_name]   = node[:ipaddress]
default[:cuckoo][:web][:static_dir]    = node[:cuckoo][:web][:dir] + '/static'
default[:cuckoo][:web][:max_upload]    = '75M'

# Virtualization
default[:cuckoo][:host][:vm][:install] = true
default[:cuckoo][:host][:vm][:type]    = :virtualbox
case node[:platform_family]
when 'debian', 'rhel', 'fedora'
  default[:virtualbox][:version] = '5.0'
end
