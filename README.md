Vagrant Redis Cluster
=====================

This is a simple Vagrant-based setup using VirtualBox for a n-node Redis cluster.

Each box is provisioned using Puppet and Puppet Librarian to install Redis.

After cloning the repository, you will need to edit the Vagrantfile and change this to the number of slave nodes you wish to set up:

	REDIS_SLAVE_INSTANCES = 2

If you wish to only set up a master node, set this to 0.

At the command line, run

	vagrant up

If you wish to ssh to a node, you will need to use the name of the machine:

	vagrant ssh master_node
	
The name of the machines are listed in the .vagrant/machines directory:

	$ ls .vagrant/machines
	master_node
	slave_node_0
	slave_node_1
	...
	etc.
	
You should verify the slaves have synced with the master node by ssh'ing into the slave nodes and tailing the logs under `/var/log/redis.log`.

Redis Server Configuration
--------------------------

The Redis server is configured using a combination of Puppet facts and a template. An example working configuration template is under 

	puppet/templates/redis/redis.conf.erb

Variables are defined in the `Vagrantfile` and passed along as Puppet options into the Puppet manifest file:

	puppet/manifests/redis/redis.pp

The Vagrantfile can be modified to define how many nodes to create, what internal IPs to use, etc.

References:
-----------

* [A Couchbase Cluster in Minutes with Vagrant and Puppet] (http://blog.couchbase.com/couchbase-cluster-minutes-vagrant-and-puppet)
* [Redis Vagrant Cluster with Chef](https://github.com/samhendley/redis-vagrant-cluster)
* [Librarian Puppet Vagrant](https://github.com/purple52/librarian-puppet-vagrant)
