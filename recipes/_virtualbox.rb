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

# Install VBoxVRDP extension pack
if node[:cuckoo][:virtualbox][:extpack][:install]
  src_url       = node[:cuckoo][:virtualbox][:extpack][:url_path]
  src_cachepath = node[:cuckoo][:virtualbox][:extpack][:file_path]
  src_filepath  = node[:cuckoo][:virtualbox][:extpack][:file_path]
  extpack_ver   = node[:cuckoo][:virtualbox][:extpack][:version]

  remote_file src_url do
    source   src_url
    path     src_cachepath
    checksum node[:cuckoo][:virtualbox][:extpack][:sha256sum]
  end

  execute 'vbox_extpack_install' do
    command "/usr/bin/vboxmanage extpack install #{src_filepath}"
    not_if  "/usr/bin/vboxmanage list extpacks | grep #{extpack_ver}"
  end
end
