class apache(
	$apacheRunUser 	= 'www-data',
	$apacheRunGroup = 'www-data'
)
{      
    package 
    { 
        "apache2":
            ensure  => present,
            require => [Exec['apt-get update'], Class['apt']]
    }
    
    service 
    { 
        "apache2":
            ensure      => running,
            enable      => true,
            require     => Package['apache2']
    }
	
	file
	{
		"/etc/apache2/sites-enabled/000-default.conf":
			ensure		=>  absent,
            require     => Package['apache2'],
			notify  => Service['apache2'],
	}

	file
	{
		"/etc/apache2/sites-enabled/000-default":
			ensure		=>  absent,
            require     => Package['apache2'],
			notify  => Service['apache2'],
	}
	
	exec
	{
		"change-apache-run-user":
			command => "sed -i '/export APACHE_RUN_USER=/c\\export APACHE_RUN_USER=$apacheRunUser' /etc/apache2/envvars",
			notify  => Service['apache2'],
			require => Package['apache2'],
			unless  => "cat /etc/apache2/envvars | grep 'export APACHE_RUN_USER=$apacheRunUser'"
	}	
	
	exec
	{
		"change-apache-run-group":
			command => "sed -i '/export APACHE_RUN_GROUP=/c\\export APACHE_RUN_GROUP=$apacheRunGroup' /etc/apache2/envvars",
			notify  => Service['apache2'],
			require => Package['apache2'],
			unless  => "cat /etc/apache2/envvars | grep 'export APACHE_RUN_GROUP=$apacheRunGroup'"
	}

	exec
	{
		"change-apache-lock-group":
			command => "sed -i '/export APACHE_LOCK_DIR=/c\\export APACHE_LOCK_DIR=/var/lock/$apacheRunGroup' /etc/apache2/envvars",
			notify  => Service['apache2'],
			require => Package['apache2'],
			unless  => "cat /etc/apache2/envvars | grep 'export APACHE_LOCK_DIR=/var/lock/$apacheRunGroup'"
	}
}
