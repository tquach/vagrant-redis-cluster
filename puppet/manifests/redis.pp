
class redis(
    $port = 6379,
    $slave_priority = 100
  ) {
  include apt
  apt::ppa { "ppa:chris-lea/redis-server": }

  exec { 'apt-get update':
    command => '/usr/bin/apt-get -q -y update',
  }
  
  file { 'db-folder':
    ensure => "directory",
    path => "/var/lib/redis_data",
  }

  package { ["redis-server"]:
    ensure => installed,
    require => Exec["apt-get update"],
  }

  file { 'redis.conf':
    ensure => file,
    path => "/etc/redis/redis.conf",
    content => template('redis/redis.conf.erb'),
    require => [Package["redis-server"], File['db-folder']],
  }

  service { 'redis-server':
    ensure => running,
    subscribe => File['redis.conf'],
  }
}

include redis