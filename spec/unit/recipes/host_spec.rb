# rubocop:disable Metrics/LineLength
#
# Cookbook Name:: cuckoo
# Spec:: default
#

require 'spec_helper'

describe 'cuckoo::host' do
  context 'When all attributes are default, on an unspecified platform' do
    before(:all) do
      stub_command("getcap /usr/sbin/tcpdump | grep '/usr/sbin/tcpdump = cap_net_admin,cap_net_raw+eip'").and_return(true)
      stub_command("getcap /usr/sbin/tcpdump | grep '/usr/sbin/tcpdump = cap_net_admin,cap_net_raw+eip'").and_return(true)
      stub_command('test -L /etc/nginx/sites-enabled/default').and_return(true)
      stub_command('/usr/bin/vboxmanage list extpacks | grep 5.0.16').and_return(true)
    end

    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '14.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs git package' do
      expect(chef_run).to install_package 'git'
    end

    it 'incldues the cuckoo::_python recipe' do
      expect(chef_run).to include_recipe 'cuckoo::_python'
    end

    it 'installs libcap2-bin package' do
      expect(chef_run).to install_package 'libcap2-bin'
    end

    it 'installs tcpdump package' do
      expect(chef_run).to install_package 'tcpdump'
    end

    it 'adds cuckoo user' do
      expect(chef_run).to create_user 'cuckoo'
    end
  end
end
