#
# Cookbook Name:: cuckoo
# Spec:: default
#
# rubocop:disable Metrics/LineLength

require 'spec_helper'

describe 'cuckoo::_web' do
  context 'When all attributes are default, on an ubuntu platform' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '14.04')
      runner.converge(described_recipe)
    end

    before(:each) do
      stub_command('test -L /etc/nginx/sites-enabled/default').and_return(true)
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

    context 'the Cuckoo Web UI' do
      it 'installs the uwsgi python package' do
        expect(chef_run).to install_python_package('uwsgi')
      end

      it 'creates the supervisor.d cuckoo_web config' do
        expect(chef_run).to create_template('/etc/supervisor.d/cuckoo_web.conf').with(
          source: 'supervisor_cuckoo_web.conf.erb',
          owner:  'root',
          group:  'root',
          mode:   '0644'
        )
      end

      it 'creates the uwsgi.ini config' do
        expect(chef_run).to create_template("#{chef_run.node.cuckoo.host.user_home}/uwsgi.ini").with(
          source: 'cuckoo_webui_uwsgi.ini.erb',
          owner:  'cuckoo',
          group:  'cuckoo',
          mode:   '0644'
        )
      end
    end

    context 'the Cuckoo Web API' do
      it 'installs the Flask Python package' do
        expect(chef_run).to install_python_package('Flask')
      end

      it 'creates the supervisor.d cuckoo_api config' do
        expect(chef_run).to create_template('/etc/supervisor.d/cuckoo_api.conf').with(
          source: 'supervisor_cuckoo_web.conf.erb',
          owner:  'root',
          group:  'root',
          mode:   '0644'
        )
      end

      it 'creates the uwsgi_api.ini config' do
        expect(chef_run).to create_template("#{chef_run.node.cuckoo.host.user_home}/uwsgi_api.ini").with(
          source: 'cuckoo_webui_uwsgi.ini.erb',
          owner:  'cuckoo',
          group:  'cuckoo',
          mode:   '0644'
        )
      end
    end

    context 'the Cuckoo cookbook manages Nginx' do
      it 'installs nginx package' do
        expect(chef_run).to install_package('nginx')
      end

      it 'enables the nginx service' do
        expect(chef_run).to enable_service('nginx')
      end

      it 'enables the nginx service' do
        expect(chef_run).to start_service('nginx')
      end

      it 'creates the uwsgi.ini config' do
        expect(chef_run).to create_template('/etc/nginx/sites-available/cuckoo.conf').with(
          source: 'nginx_cuckoo.conf.erb',
          owner:  'root',
          group:  'root',
          mode:   '0644'
        )
      end

      it 'links the cuckoo nginx config to enable the site' do
        link = chef_run.link('/etc/nginx/sites-enabled/cuckoo.conf')
        expect(link).to link_to('/etc/nginx/sites-available/cuckoo.conf')
      end

      it 'disables the default nginx site' do
        expect(chef_run).to delete_link('/etc/nginx/sites-enabled/default')
      end
    end
  end
end
