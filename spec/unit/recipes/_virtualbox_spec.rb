#
# Cookbook Name:: cuckoo
# Spec:: default
#

require 'spec_helper'

describe 'cuckoo::_virtualbox' do
  context 'When all attributes are default, on ubuntu platform' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '14.04')
      runner.converge(described_recipe)
    end

    before(:all) do
      stub_command('/usr/bin/vboxmanage list extpacks | grep 5.0.16').and_return(false)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'includes apt::default recipe' do
      expect(chef_run).to include_recipe('apt::default')
    end

    it 'adds the oracle-virtualbox apt_reposotory' do
      expect(chef_run).to add_apt_repository('oracle-virtualbox')
    end

    it 'installs the virtualbox package' do
      expect(chef_run).to install_package("virtualbox-#{chef_run.node.virtualbox.version}")
    end

    it 'installs the dkms package' do
      expect(chef_run).to install_package('dkms')
    end

    it 'adds the cuckoo user to virtualbox group' do
      expect(chef_run).to modify_group('vboxusers').with(
        members: [chef_run.node.cuckoo.host.user],
        append:  true
      )
    end
  end
end
