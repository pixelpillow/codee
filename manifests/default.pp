group { 'puppet':
	ensure => present,
}

exec { 'apt-get update':
	command => '/usr/bin/apt-get update',
}

package { 'nginx':
	ensure => present,
	require => Exec['apt-get update'],
}

package { 'php5-fpm':
	ensure => present,
	require => Exec['apt-get update'],
}

package { 'mcrypt':
	ensure => present,
	require => Package['php5-fpm'],
}

package { 'php5-cli':
	ensure => present,
	require => Package['php5-fpm'],
}

service { 'nginx':
	ensure => running,
	require => Package['nginx'],
}

service { 'php5-fpm':
	ensure => running,
	require => Package['php5-fpm'],
}

file { 'vagrant-nginx':
	path => '/etc/nginx/sites-available/vagrant',
	ensure => file,
	require => Package['nginx'],
	source => '/tmp/vagrant-puppet/manifests/modules/nginx/files/vagrant',
}

file { 'default-nginx-disable':
	path => '/etc/nginx/sites-enabled/default',
	ensure => absent,
	require => Package['nginx'],
}

file { 'vagrant-nginx-enable':
	path => '/etc/nginx/sites-enabled/vagrant',
	target => '/etc/nginx/sites-available/vagrant',
	ensure => link,
	notify => Service['nginx'],
	require => [
		File['vagrant-nginx'],
		File['default-nginx-disable'],
	],
}