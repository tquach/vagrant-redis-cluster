# -*- mode: ruby -*-
# vi: set ft=ruby :


REDIS_INSTANCES = 2

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  REDIS_INSTANCES.times do |id|
    config.vm.define "redis-#{id}" do |node|
      node.vm.box = "precise64"
      node.vm.network "private_network", ip: "10.10.5.10#{id}"

      #node.vm.provision :puppet 
    end
  end

  config.vm.define "app" do |app|
    app.vm.box = "precise64"
    app.vm.network :private_network, ip: "10.10.1.10"
  end
end
