# rubocop:disable Metrics/LineLength
# Cookbook Name:: cuckoo
# Spec:: default
#

require 'spec_helper'

describe 'cuckoo::default' do
  context 'When all attributes are default, on an unspecified platform' do
    before(:all) do
      stub_command("getcap /usr/sbin/tcpdump | grep '/usr/sbin/tcpdump = cap_net_admin,cap_net_raw+eip'").and_return(true)
      stub_command("getcap /usr/sbin/tcpdump | grep '/usr/sbin/tcpdump = cap_net_admin,cap_net_raw+eip'").and_return(true)
      stub_command('test -L /etc/nginx/sites-enabled/default').and_return(true)
    end

    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'includes cuckoo::host recipe' do
      expect(chef_run).to include_recipe('cuckoo::host')
    end
  end
end
