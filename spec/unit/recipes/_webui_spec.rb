#
# Cookbook Name:: cuckoo
# Spec:: default
#

require 'spec_helper'

describe 'cuckoo::_webui' do
  context 'When all attributes are default, on an ubuntu platform' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '14.04')
      runner.converge(described_recipe)
    end
    
    before(:each) do
      stub_command("test -L /etc/nginx/sites-enabled/default").and_return(false)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs mongodb package' do
      expect(chef_run).to install_package('mongodb')
    end

    it 'includes the supervisor::default recipe' do
      expect(chef_run).to include_recipe('supervisor::default')
    end

    it 'installs the uwsgi python package' do
      expect(chef_run).to install_python_package('uwsgi')
    end
  end
end
