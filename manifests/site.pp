# Explictly set to avoid warning message
Package {
  allow_virtual => false,
}

node /^ubuntu/ {
  file { 'bash_profile':
    path    => '/home/vagrant/.bash_profile',
    ensure  => file,
    source  => '/vagrant/manifests/bash_profile'
  }

  exec { 'update-apt-packages':
    command => '/usr/bin/apt-get update -y',
    creates => '/vagrant/.locks/update-apt-packages',
  }

  include git

  class { 'boundary':
    token => $boundary_api_token,
  }

  package { 'vim':
    provider => 'apt',
    require => Exec['update-apt-packages'],
  }

  package { 'tmux':
    provider => 'apt',
    require => Exec['update-apt-packages']
  }

  class { '::riak':
    version => 'latest', # default, use a package version if desired
    # settings in the settings hash are written directly to settings.conf.
    settings => {
      'nodename' => 'riak@127.0.0.1'
    },
  }

}

# Separate the Cento 7.0 install until the boundary meter puppet package is fixed
node /^centos-7-0/ {
  file { 'bash_profile':
    path    => '/home/vagrant/.bash_profile',
    ensure  => file,
    source  => '/vagrant/manifests/bash_profile'
  }

  exec { 'update-rpm-packages':
    command => '/usr/bin/yum update -y',
    creates => '/vagrant/.locks/update-rpm-packages',
  }

  package {'epel-release':
    ensure => 'installed',
    require => Exec['update-rpm-packages']
  }

  class { '::riak':
    version => 'latest', # default, use a package version if desired
    # settings in the settings hash are written directly to settings.conf.
    settings => {
      'nodename' => 'riak@127.0.0.1'
    },
  }

}

node /^centos/ {

  file { 'bash_profile':
    path    => '/home/vagrant/.bash_profile',
    ensure  => file,
    source  => '/vagrant/manifests/bash_profile'
  }

  exec { 'update-rpm-packages':
    command => '/usr/bin/yum update -y',
    creates => '/vagrant/.locks/update-rpm-packages',
  }

  package {'epel-release':
    ensure => 'installed',
    require => Exec['update-rpm-packages']
  }

  class { 'boundary':
    token => $boundary_api_token
  }

  class { '::riak':
    version => 'latest', # default, use a package version if desired
    # settings in the settings hash are written directly to settings.conf.
    settings => {
      'nodename' => 'riak@127.0.0.1'
    },
  }

}
