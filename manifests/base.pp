node default{

  stage { 'first': before => Stage['main'] }
  stage { 'last': require => Stage['main'] }
  
  group { "puppet":
    ensure => "present",
  }
  
  exec {"apt-get update":
    path => ["/bin","/usr/bin","/usr/sbin"],
    before => Package["openjdk-6-jdk"]
  }

  package {"openjdk-6-jdk":
    ensure => present,
    require => Exec["apt-get update"],
  }
  
  package {"python-virtualenv":
    ensure => present,
    require => Exec["apt-get update"],
  }
  
  package {"ant":
    ensure => present,
    require => Exec["apt-get update"],
  }
  
  package {"graphviz":
    ensure => present,
    require => Exec["apt-get update"],
  }

  package {"gnuplot":
    ensure => present,
    require => Exec["apt-get update"],
  }
  
  package {"python-gnuplot":
    ensure => present,
    require => Exec["apt-get update"],
  }
  
  package {"python-pyparsing":
    ensure => present,
    require => Exec["apt-get update"],
  }

  package {"python-pydot":
    ensure => present,
    require => Exec["apt-get update"],
  }

  package {"python-numpy":
    ensure => present,
    require => Exec["apt-get update"],
  }

  package {"python-wxgtk2.6":
    ensure => present,
    require => Exec["apt-get update"],
  }

  package {"python-wxtools":
    ensure => present,
    require => [Package["python-wxgtk2.6"], Exec["apt-get update"]],
  }

  package {"wx2.6-i18n":
    ensure => present,
    require => [Package["python-wxtools"], Exec["apt-get update"]],
  }

  package {"glade":
    ensure => present,
    require => [Exec["apt-get update"]],
  }

  package {"docbook":
    ensure => present,
    require => [Exec["apt-get update"]],
  }

  package {"dblatex":
    ensure => present,
    require => [Exec["apt-get update"]],
  }

  Database {
  	require => [Class['mysql::server'], Exec["apt-get update"]],
 }  
  
  class { 'mysql': 
    require => Exec["apt-get update"],
  }
  class { 'mysql::java':     
  	require => Exec["apt-get update"],
  }
  class { 'mysql::server':
  	config_hash => { 'root_password' => 'password' },
    require => Exec["apt-get update"],
  }

  exec { "setup_conf_symlink":
    command => "ln -s /root/.my.cnf /.my.cnf",
    path => ["/bin","/usr/bin","/usr/sbin"],
    creates => "/.my.cnf",
  	before => Mysql::Db['cairis'],
  }

  mysql::db { 'cairis':
  	user     => 'user',
  	password => 'pass',
  	host     => 'localhost',
  	grant    => ['all'],
  	require => Class["mysql::server"],
  }
  
  $cairis_home_path = "/usr/share/cairis"
  
  file {"$cairis_home_path":
  	source  => "/vagrant/sourcecode/",
    ensure  => directory,
    recurse => true,
  	mode    => 0774,
   	require 	=> Mysql::Db['cairis'],
  }
  
	$home_dir = "/home/cairis/"
	$cairis_user = "cairis"

  # ensure home dir is setup and installed
  exec { "create_cairis_home_dir":
    command => "echo 'creating ${home_dir}' && mkdir -p ${home_dir}",
    path => ["/bin", "/usr/bin", "/usr/sbin"],
    creates => $home_dir
  }
	user {"cairis":
		ensure => present,
		home => "${cairis_user_home_dir}",
		before => File["$home_dir"],
		name => "$cairis_user",
		system => true,
		shell => "/bin/bash",
	}
 
  file {$home_dir:
    path    => $home_dir,
    ensure  => directory,
    owner   => $cairis_user,
    group   => $cairis_user,
    mode    => 0644,
    require => [Exec["create_cairis_home_dir"]],
  }
  
  # Configure environment variables
  #file {"${home_dir}/.pam_environment":
  #  ensure => file,
  #  content => template("/tmp/vagrant-puppet/templates/.pam_environment.erb"),
  #  owner   => $cairis_user,
  #  mode    => 0755,
	#	require => File["$home_dir"],
  #}
}
