include_recipe "nginx"

nginx_site 'default' do
  enable false
end

# create vhosts dir
directory "/var/vhosts" do
  owner node['nginx']['user']
  group node['nginx']['group']
  mode '0755'
  action :create
end

# add vhost config for QA
template '/etc/nginx/sites-available/lookup_api' do
  source 'lookup_api.erb'
  cookbook 'edjo_lookup'
  mode '0644'
  owner 'root'
  group 'root'
end

# Enable vhost
link "/etc/nginx/sites-enabled/lookup_api" do
  to "/etc/nginx/sites-available/lookup_api" 
end

