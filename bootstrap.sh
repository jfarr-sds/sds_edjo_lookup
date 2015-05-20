# Install Chef
cd /home/vagrant
curl -L https://www.opscode.com/chef/install.sh | bash

# Get resources for creating a project directory structure
if [ ! -d "/home/vagrant" ]; then
	mkdir /home/vagrant
fi

if [ ! -d "/home/vagrant/chef-repo" ]; then
	cd /home/vagrant/ # configured in the Vagrantfile
	wget https://github.com/chef/chef-repo/tarball/master
	tar -zxf master
	mv chef-chef-repo-* chef-repo
	rm master
fi

# Configure knife to be aware of our cookbooks directory

if [ ! -d "/home/vagrant/chef-repo/.chef" ]; then
	cd /home/vagrant/chef-repo
	mkdir .chef
	echo "cookbook_path [ '/home/vagrant/chef-repo/cookbooks' ]" > .chef/knife.rb
fi

# Use knife to create a new cookbook
knife cookbook create edjo_lookup

sudo chef-solo -c /home/vagrant/chef-repo/solo.rb -j /home/vagrant/chef-repo/flask_api.json
