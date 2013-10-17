class nass::bddservers {
  # Installation Mysql
  $socket = '/var/run/mysqld/mysqld.sock'
  class { 'mysql::server':
    root_password    => 'foo',
    override_options => {
      mysqld      => { socket => $socket },
      mysqld_safe => { socket => $socket },
      client      => { socket => $socket },
    },
  }
}
