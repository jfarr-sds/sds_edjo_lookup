#
# Cookbook Name:: edjo_lookup
# Recipe:: default
#
# Copyright 2015, sentient decision science
#
# All rights reserved - Do Not Redistribute
#

# create a user for the API
user 'flask' do
  supports :manage_home => true
  comment 'Flask User'
  uid 1234
  gid 'www-data'
  home '/home/flask'
  shell '/bin/bash'
  password 'pass'
end

# create a Python 3.4 virtualenv
python_virtualenv "/home/flask/venv" do
  interpreter "python2.7"
  owner "flask"
  group "users"
  action :create
end

# Install psql driver for python
python_pip "psycopg2" do
  action :install
  virtualenv "/home/flask/venv"
end

# Install flask framework
python_pip "flask" do
  action :install
  virtualenv "/home/flask/venv"
end

# Install uwsgi
python_pip "uwsgi" do
  action :install
  virtualenv "/home/flask/venv"
end

link "/home/flask/lookup_api.py"do
  to "/home/vagrant/chef-repo/sds_edjo_lookup_app/lookup_api.py" 
end

link "/home/flask/wsgi.py"do
  to "/home/vagrant/chef-repo/sds_edjo_lookup_app/wsgi.py" 
end

template '/etc/init/lookup_api.conf' do
  source 'lookup_api.conf.erb'
  cookbook 'edjo_lookup'
  mode '0644'
  owner 'root'
  group 'root'
end

template '/home/flask/lookup_api.ini' do
  source 'lookup_api.ini.erb'
  cookbook 'edjo_lookup'
  mode '0644'
  owner 'root'
  group 'root'
end


# create a postgresql database
postgresql_database 'edjo_lookup' do
  connection(
    :host      => '127.0.0.1',
    :port      => 5432,
    :username  => 'postgres',
    :password  => node['postgresql']['password']['postgres']
  )
  action :create
end

# create a postgresql user but grant no privileges
postgresql_database_user 'flask_user' do
  connection(
    :host      => '127.0.0.1',
    :port      => 5432,
    :username  => 'postgres',
    :password  => node['postgresql']['password']['postgres']
  )
  password node['postgresql']['password']['flask_user']
  action :create
end

# grant select and insert privs for flask
postgresql_database_user 'flask_user' do
  connection(
    :host      => '127.0.0.1',
    :port      => 5432,
    :username  => 'postgres',
    :password  => node['postgresql']['password']['postgres']
  )
  database_name 'edjo_lookup'
  privileges [:all]
  action :grant
end
