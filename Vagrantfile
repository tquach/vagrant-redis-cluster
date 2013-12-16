# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

BASE_BOX = "precise64"
BASE_BOX_URL = "http://files.vagrantup.com/precise64.box"

# How many redis servers. Max 255.
REDIS_SLAVE_INSTANCES = 1
MASTER_IP_ADDRESS = "10.10.25.100"

# Uncomment this if the master node requires authentication
# MASTER_AUTH = "password"
MASTER_AUTH = ""

SLAVE_IP_PREFIX = "10.10.25.2"
DEFAULT_PORT = 6379

def setup_node(config, ip_addr, options = {})
  config.vm.network :private_network, ip: ip_addr
  config.vm.provision "shell", path: "shell/main.sh"

  # Puppet modules are managed by librarian-puppet
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file  = "redis.pp"
    puppet.options = [
      "--templatedir", "/tmp/vagrant-puppet/templates",
    ]
    puppet.facter = options.merge('ip' => ip_addr)
  end

  config.vm.provider "virtualbox" do |provider|
    provider.customize ["modifyvm", :id, "--memory", 512]
    provider.customize ["modifyvm", :id, "--cpus", 1]
    provider.customize ["modifyvm", :id, "--cpuexecutioncap", 50]
  end

end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = BASE_BOX
  config.vm.box_url = BASE_BOX_URL
  config.vm.synced_folder 'puppet/templates/', '/tmp/vagrant-puppet/templates'

  # Master configuration
  config.vm.define "master_node" do |master|
    options = {"redis_password" => MASTER_AUTH}
    setup_node(config, MASTER_IP_ADDRESS, options)
  end

  REDIS_SLAVE_INSTANCES.times do |idx|
    ip_addr = "#{SLAVE_IP_PREFIX}#{idx}"
    config.vm.define "slave_node_#{idx}" do |slave|
      # Add a redis_password option below if desired.
      # e.g. "redis_password" => "my_password"
      options = {
        "master_ip" => MASTER_IP_ADDRESS,
        "master_auth" => MASTER_AUTH,
        "slave_priority" => 100 + idx,
        "master_port" => DEFAULT_PORT
      }
      setup_node(slave, ip_addr, options)
    end
  end
end
