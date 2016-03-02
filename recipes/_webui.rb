#
# Cookbook Name:: cuckoo
# Recipe:: _webui
#

# Install MongoDB for Django Web UI
package 'mongodb'

# Install supervisord for managing web process
include_recipe 'supervisor::default'

execute 'supervisorctl_update' do
  command 'supervisorctl update'
  action :nothing
end

# supvisor config for cuckoo uwsgi
template '/etc/supervisor.d/cuckoo_web.conf' do
  source 'supervisor_cuckoo_web.conf.erb'
  owner 'root'
  group 'root'
  mode  '0644'
  variables({
    command:    'uwsgi --ini /home/cuckoo/uwsgi.ini',
    directory:  node[:cuckoo][:host][:source][:dest] + '/web',
    user:       node[:cuckoo][:host][:user],
    stderr_log: '/var/log/cuckoo_web.err.log',
    stdout_log: '/var/log/cuckoo_web.out.log'
  })
  notifies :run, 'execute[supervisorctl_update]', :immediately
end

# Use uwsgi
python_package 'uwsgi' do
  version '2.0.12'
end

# config for cuckoo uwsgi
template "#{node[:cuckoo][:host][:user_home]}/uwsgi.ini" do
  source 'cuckoo_webui_uwsgi.ini.erb'
  owner  node[:cuckoo][:host][:user]
  group  node[:cuckoo][:host][:user]
  mode   '0644'
  variables({
    dir:          node[:cuckoo][:web][:dir],
    max_requests: node[:cuckoo][:web][:max_requests],
    http_socket:  node[:cuckoo][:web][:uwsgi_socket]
  })
  notifies :run, 'execute[supervisorctl_update]', :immediately
end

# Use default nginx package to proxy to uwsgi
if node[:cuckoo][:web][:install_nginx]
  package 'nginx'

  service 'nginx' do
    supports status: true, restart: true, reload: true
    action   [:enable, :start]
  end

  # cuckoo nginx config to proxy uwsgi
  template "/etc/nginx/sites-available/cuckoo.conf" do
    source 'nginx_cuckoo.conf.erb'
    owner  'root'
    group  'root'
    mode   '0644'
    variables({
      upstream:    node[:cuckoo][:web][:uwsgi_socket],
      http_listen: node[:cuckoo][:web][:http_listen],
      server_name: node[:cuckoo][:web][:server_name],
      dir:         node[:cuckoo][:web][:dir],
      static_dir:  node[:cuckoo][:web][:static_dir],
      uwsgi_path:  "#{node[:cuckoo][:host][:user_home]}/uwsgi.ini",
      max_upload:  node[:cuckoo][:web][:max_upload]
    })
    notifies :restart, 'service[nginx]', :immediately
  end

  # Enable cuckoo nginx site
  link '/etc/nginx/sites-enabled/cuckoo.conf' do
    to '/etc/nginx/sites-available/cuckoo.conf'
    notifies :restart, 'service[nginx]', :delayed
  end

  # Disable default nginx site
  link '/etc/nginx/sites-enabled/default' do
    action :delete
    only_if 'test -L /etc/nginx/sites-enabled/default'
    notifies :restart, 'service[nginx]', :delayed
  end
end
