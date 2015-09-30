class squid(
   $download = 'http://www.squid-cache.org/Versions/v3/3.5/squid-3.5.9.tar.gz',
   $cache_mem = '256 MB',
   $maximum_object_size_in_memory = '512 KB',
   $memory_replacement_policy = 'lru',
   $cache_replacement_policy = 'lru',
   $cache_dir = '/var/spool/squid3',
   $cache_dir_type = 'ufs',
   $cache_dir_size = 100,
   $maximum_object_size = '4096 KB',
   $ssldb_dir = '/etc/squid3/ssldb',
   $log_dir = '/var/log/squid3',
){

  $build_options = "--sysconfdir=/etc/squid3 --mandir=/usr/share/man --enable-inline --enable-async-io=8 --enable-storeio=ufs,aufs,diskd,rock --enable-removal-policies=lru,heap --enable-delay-pools --enable-cache-digests --enable-underscores --enable-icap-client --enable-follow-x-forwarded-for --enable-eui --enable-esi --enable-ssl --enable-ssl-crtd --enable-linux-netfilter --enable-zph-qos --disable-translation --with-openssl --with-swapdir=${cache_dir} --with-logdir=${log_dir} --with-pidfile=/var/run/squid3.pid --with-filedescriptors=65536 --with-large-files --with-default-user=proxy"
  $user = 'proxy'
  $group = 'proxy'

 if defined( Package["squid3"] ) {
    debug("$package already installed")
  } else {
     $requirements = [
                 "devscripts",
                 "libssl-dev",
                 "build-essential"
                 ]

    package { 
      $requirements: 
        ensure =>'present',
    }->
    exec { 'download-squid-source':
      cwd     => "/tmp",
      command => "/usr/bin/wget -q $download -O squid.tar.gz",
      timeout => 120, # 2 minutes
      # before => Exec['uncompress']
    }->
    
    exec { "uncompress":
      cwd     => "/tmp",
      command => "tar xzf /tmp/squid.tar.gz",
      # before => Exec['configure']
    }->

    exec { "configure":
      cwd     => "/tmp/squid*",
      command => "./configure ${build_options}",
    }->

    exec { 'make-and-install':
      cwd     => "/tmp/squid*",
      command => "make && make install",
    }->

    file { 
      '/etc/squid3/squid.conf':
        ensure  => 'file',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template("squid/squid.conf.erb"),
        # require => 'squid3',
        # after => Exec['make-and-install']
    }->

    file { 
      "${cache_dir}":
        ensure  => 'directory',
        owner   => $user,
        group   => $group,
        mode    => '0755',
        # require => 'squid3',
        # after => File['/etc/squid3/squid.conf']
    }->
    file { 
      "${ssldb_dir}":
        ensure  => 'directory',
        owner   => $user,
        group   => $group,
        mode    => '0755',
        # require => 'squid3',
        # after => File["${cache_dir}"]
    }->
    exec { 
      'Init cache dir':
        command => "squid3 stop && squid3 -z",
        creates => "${cache_dir}/00",
        notify  => 'squid3',
        # require => [ File[$cache_dir], File[$config_file] ],
        # after => Exec["${ssldb_dir}"]
    }->
    service { 
      'squid3':
        ensure    => 'running',
        enable    => true,
        require   => Package["squid3"],
        restart   => '/etc/init.d/squid3 reload',
        subscribe => Exec['Init cache dir'],
    }
  }
}