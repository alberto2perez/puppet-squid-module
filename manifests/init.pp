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
   $log_dir = '/var/log/squid3'
){

  $buildoptions = "--sysconfdir=/etc/squid3 --mandir=/usr/share/man --enable-inline --enable-async-io=8 --enable-storeio=ufs,aufs,diskd,rock --enable-removal-policies=lru,heap --enable-delay-pools --enable-cache-digests --enable-underscores --enable-icap-client --enable-follow-x-forwarded-for --enable-eui --enable-esi --enable-ssl --enable-ssl-crtd --enable-linux-netfilter --enable-zph-qos --disable-translation --with-openssl --with-swapdir=${cache_dir} --with-logdir=${log_dir} --with-pidfile=/var/run/squid3.pid --with-filedescriptors=65536 --with-large-files --with-default-user=proxy";
  $user = 'proxy';
  $group = 'proxy';

  
}
