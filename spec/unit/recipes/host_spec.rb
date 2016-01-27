#
# Cookbook Name:: cuckoo
# Spec:: default
#

require 'spec_helper'

describe 'cuckoo::host' do
  context 'When all attributes are default, on an unspecified platform' do
    before(:all) do
      stub_command("getcap /usr/sbin/tcpdump | grep '/usr/sbin/tcpdump = cap_net_admin,cap_net_raw+eip'").and_return(true)
    end

    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
