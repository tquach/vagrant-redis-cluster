Vagrant Redis Cluster
=====================

This is a simple Vagrant-based setup using VirtualBox for a n-node Redis cluster.

Each box is provisioned using Puppet and Puppet Librarian to install Redis.

Configuration
-------------

The Redis server is configured using a combination of Puppet facts and a template. An example working configuration template is under 

	puppet/templates/redis/redis.conf.erb

The variable values are passed in from the manifest:

	puppet/manifests/redis/redis.pp

The Vagrantfile can be modified to define how many nodes to create, what internal IPs to use, etc.