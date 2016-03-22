#
# Cookbook Name:: cuckoo
# Attribute:: default
#
# rubocop:disable Metrics/LineLength

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
default[:cuckoo][:api][:dir]           = node[:cuckoo][:host][:source][:dest]
default[:cuckoo][:api][:max_requests]  = '1000'
default[:cuckoo][:api][:uwsgi_socket]  = '127.0.0.1:8080'

# Virtualization
default[:cuckoo][:host][:vm][:install]               = true
default[:cuckoo][:host][:vm][:type]                  = :virtualbox
default[:cuckoo][:virtualbox][:extpack][:install]    = true
default[:cuckoo][:virtualbox][:extpack][:version]    = '5.0.16'
default[:cuckoo][:virtualbox][:extpack][:file]       = 'Oracle_VM_VirtualBox_Extension_Pack-5.0.16.vbox-extpack'
default[:cuckoo][:virtualbox][:extpack][:url]        = 'http://download.virtualbox.org/virtualbox/5.0.16/'
default[:cuckoo][:virtualbox][:extpack][:url_path]   = node[:cuckoo][:virtualbox][:extpack][:url] + node[:cuckoo][:virtualbox][:extpack][:file]
default[:cuckoo][:virtualbox][:extpack][:sha256sum]  = 'c234e158c49f4f92c38e41918c117d756a81236ff1030a896e44faf88284ecc7'
default[:cuckoo][:virtualbox][:extpack][:cache_path] = Chef::Config[:file_cache_path] || '/tmp'
default[:cuckoo][:virtualbox][:extpack][:file_path]  = "#{node[:cuckoo][:virtualbox][:extpack][:cache_path]}/#{node[:cuckoo][:virtualbox][:extpack][:file]}"

case node[:platform_family]
when 'debian', 'rhel', 'fedora'
  default[:virtualbox][:version] = '5.0'
end
