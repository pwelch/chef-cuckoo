#
# Cookbook Name:: cuckoo
# Spec:: default
#

require 'spec_helper'

describe 'cuckoo::_python' do
  context 'When all attributes are default, on an unspecified platform' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'includes poise-python cookbook' do
      expect(chef_run).to include_recipe('poise-python')
    end

    %w{ python-dev libffi-dev libssl-dev }.each do |pkg|
      it "installs #{pkg} package" do
        expect(chef_run).to install_package(pkg)
      end
    end
  end
end
