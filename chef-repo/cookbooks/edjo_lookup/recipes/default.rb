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
  gid 'users'
  home '/home/flask'
  shell '/bin/bash'
  password 'pass'
end

# Install flask framework
python_pip "flask" do
  action :install
end

# create a Python 3.4 virtualenv
python_virtualenv "/home/flask/venv" do
  interpreter "python3.4"
  owner "flask"
  group "users"
  action :create
end

python_pip "flask" do
  virtualenv "/home/flask/venv"
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
