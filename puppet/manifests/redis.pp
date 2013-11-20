
class redis {
  include apt
  apt::ppa { "ppa:chris-lea/redis-server": }

  exec { 'apt-get update':
    command => '/usr/bin/apt-get update',
  }
  
  file { 'db-folder':
    ensure => "directory",
    path => "/var/lib/redis-${node_id}",
  }

  package { ["redis-server"]:
    ensure => present,
    require => Exec["apt-get update"],
    before => File['/etc/redis/redis_${node_id}.conf'],
  }

  file { '/etc/redis/redis_${node_id}.conf':
    ensure => present,
    path => "/etc/redis/redis_${node_id}",
    content => template('redis/redis.conf.erb'),
    require => File['db-folder'],
  }

  service { 'redis-server-${node_id}':
    ensure => running,
    subscribe => File['/etc/redis/redis_${node_id}.conf'],
    require => Package["redis-server"]
  }
}

include redis