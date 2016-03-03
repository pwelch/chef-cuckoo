#
# Cookbook Name:: cuckoo
# Recipe:: _virtualbox
#

case node[:platform_family]
when 'debian'
  include_recipe 'apt::default'

  apt_repository 'oracle-virtualbox' do
    uri          'http://download.virtualbox.org/virtualbox/debian'
    key          'http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc'
    distribution node[:lsb][:codename]
    components   [:contrib]
  end

  package "virtualbox-#{node[:virtualbox][:version]}"
  package 'dkms'
else
  Chef::Log.warn("#{node[:platform_family]} not supported in #{recipe_name}!")
end

group 'vboxusers' do
  members node[:cuckoo][:host][:user]
  append  true
  action  :modify
end
