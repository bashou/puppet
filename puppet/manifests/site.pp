Exec {
    path => '/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/sbin/',
    # Ruby bug, so no timeout:
    # http://groups.google.com/group/puppet-users/browse_thread/thread/7efd79bcd807de4c/dc9f8e42082cd0aa
    timeout => 0,
}

if ! $lib_dir {
  case $architecture {
    'x86_64':    { $lib_dir = '/usr/lib64' }
    default:     { $lib_dir = '/usr/lib'   }
  }
}

node 'kobe.nassi.me' {

  $role = "web"
  $site = "uploadfr"

  class {'nass::basicservers':}
  class {'nass::websites':}

}
