
class redis(
    $port = 6379,
    $master_ip = "",
    $master_port = $port,
    $slave_priority = 100
  ) {
  include apt
  apt::ppa { "ppa:chris-lea/redis-server": }

  exec { 'apt-get update':
    command => '/usr/bin/apt-get -q -y update',
    require => Apt::Ppa["ppa:chris-lea/redis-server"],
  }

  package { ["redis-server"]:
    ensure => installed,
    before => File['db-folder'],
    require => Exec["apt-get update"],
  }

  # package { ['redis-commander']:
  #   ensure   => latest,
  #   provider => 'npm',
  #   require => Package['redis-server'],
  # }

  file { 'db-folder':
    ensure => "directory",
    path => "/var/lib/redis",
    owner => "redis",
    group => "redis",
  }

  file { 'redis.conf':
    ensure => file,
    path => "/etc/redis/redis.conf",
    content => template('redis/redis.conf.erb'),
    # content => template('redis/redis.conf.sample'),
    require => [Package["redis-server"], File['db-folder']],
  }

  service { 'redis-server':
    ensure => running,
    subscribe => File['redis.conf'],
    require => Package['redis-server'],
  }

  # service { 'redis-commander':
  #   ensure => running,
  #   require => Package['redis-commander'],
  # }
}

include redis