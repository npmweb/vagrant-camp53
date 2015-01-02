# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "npmweb/camp53"
  config.vm.hostname = "dvmcweb53-local"
  config.vm.box_version = ">= 0.1.0"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.10.11"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # RT - borrowed from homestead
    # Configure A Few VirtualBox Settings
    config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.customize ["modifyvm", :id, "--cpus", "1"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.name = "php53-dev"
    end


  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.hostname = "dvmcweb53-local"
  config.vm.network "forwarded_port", guest: 80, host: 8081
  config.vm.network "forwarded_port", guest: 3306, host: 33061
  config.vm.network "forwarded_port", guest: 5432, host: 54321
  config.vm.network "forwarded_port", guest: 11300, host: 11334

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "~/apps", "/srv/apps",
            :mount_options => ['fmode=777,dmode=777']
  config.vm.synced_folder "~/www", "/srv/www",
            :mount_options => ["fmode=777,dmode=777"]

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.


  config.vm.provision :shell, path: "scripts/bootstrap.sh"

  # do apache sites

  npmstaff = {
    "domain" => 'local.npmstaff.org',
    "docroot" => '/srv/www/local.npmstaff.org/web',
    "alias" => '/account',
    "alias_to" => '/srv/www/local.npmstaff.org/account',
    "phperr" => 'E_ALL'
  }
  killinit = {
    "domain" => 'local.killinitseries.org',
    "docroot" => '/srv/apps/series-sites',
    "phperr" => 'E_ALL'
  }
  middleware = {
    "domain" => 'local.api.northpointministries.net',
    "docroot" => '/srv/apps/api.northpointministries.net/api.northpointministries.net/src',
    "alias" => '/media',
    "alias_to" => '/srv/apps/media-api'
  }

  sites = [ npmstaff, killinit, middleware ]
  sites.each do |site|
    # Remove Previously Configured Apache Sites
    config.vm.provision "shell" do |s|
      s.inline = "rm -fv /etc/httpd/vhosts.d/$1.conf 2> /dev/null"
    end
    config.vm.provision "shell" do |s|
      s.inline = "bash /vagrant/scripts/vhosts.sh $1 $2 \"$3\" \"$4\" \"$5\""
      s.args = [site["domain"], site["docroot"], site["alias"] ||= "", site["alias_to"] ||= "", site["phperr"] ||= ""]
    end
  end

  mma = {
    "database" => 'ci_mma',
    "username" => 'ci_mma',
    "password" => 'ci_mma',
  }
  middleware = {
    "database" => 'ci_api',
    "username" => 'ci_api',
    "password" => 'mP3Lnd66PtGb9QXX',
  }
  ondeck = {
    "database" => 'ci_ondeck',
    "username" => 'ondeck_user',
    "password" => 'test',
  }
  cfs = {
    "database" => 'ci_cfs',
    "username" => 'ci_cfs',
    "password" => 'ci_cfs',
  }
  dbs = [ mma, middleware, ondeck, cfs ]
  dbs.each do |db|
    config.vm.provision "shell" do |s|
      s.inline = "bash /vagrant/scripts/mysql.sh $1 $2 $3"
      s.args = [db["database"], db["username"], db["password"]]
    end
  end

  # Enable provisioning with CFEngine. CFEngine Community packages are
  # automatically installed. For example, configure the host as a
  # policy server and optionally a policy file to run:
  #
  # config.vm.provision "cfengine" do |cf|
  #   cf.am_policy_hub = true
  #   # cf.run_file = "motd.cf"
  # end
  #
  # You can also configure and bootstrap a client to an existing
  # policy server:
  #
  # config.vm.provision "cfengine" do |cf|
  #   cf.policy_server_address = "10.0.2.15"
  # end

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file default.pp in the manifests_path directory.
  #
  # config.vm.provision "puppet" do |puppet|
  #   puppet.manifests_path = "manifests"
  #   puppet.manifest_file  = "site.pp"
  # end

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  #
  # config.vm.provision "chef_solo" do |chef|
  #   chef.cookbooks_path = "../my-recipes/cookbooks"
  #   chef.roles_path = "../my-recipes/roles"
  #   chef.data_bags_path = "../my-recipes/data_bags"
  #   chef.add_recipe "mysql"
  #   chef.add_role "web"
  #
  #   # You may also specify custom JSON attributes:
  #   chef.json = { :mysql_password => "foo" }
  # end

  # Enable provisioning with chef server, specifying the chef server URL,
  # and the path to the validation key (relative to this Vagrantfile).
  #
  # The Opscode Platform uses HTTPS. Substitute your organization for
  # ORGNAME in the URL and validation key.
  #
  # If you have your own Chef Server, use the appropriate URL, which may be
  # HTTP instead of HTTPS depending on your configuration. Also change the
  # validation key to validation.pem.
  #
  # config.vm.provision "chef_client" do |chef|
  #   chef.chef_server_url = "https://api.opscode.com/organizations/ORGNAME"
  #   chef.validation_key_path = "ORGNAME-validator.pem"
  # end
  #
  # If you're using the Opscode platform, your validator client is
  # ORGNAME-validator, replacing ORGNAME with your organization name.
  #
  # If you have your own Chef Server, the default validation client name is
  # chef-validator, unless you changed the configuration.
  #
  #   chef.validation_client_name = "ORGNAME-validator"
end
