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

# Virtualization
default[:cuckoo][:host][:vm][:install] = false
default[:cuckoo][:host][:vm][:type]    = :virtualbox
