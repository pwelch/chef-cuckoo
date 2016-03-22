#
# Cookbook Name:: cuckoo_test
# Recipe:: default
#

## VirtualBox Requirements in test VM
# Need this in vagrant VM for Virtualbox
package "linux-headers-#{node.kernel.release}" do
  action :install
end

# Need to run this to add in Virtualbox kernel modules
execute 'VBox_kernel_modules' do
  command '/sbin/rcvboxdrv setup && touch /tmp/vboxbootstrapped'
  creates '/tmp/vboxbootstrapped'
  action  :run
end
