define nass::users (
  $group = $name
  ) {

  $home = "/home/${name}"

  user { $name:
    comment => "${name}",
    home    => "${home}",
    shell   => "/bin/bash",
    uid     => 1001,
  }

  group { $group:
  #  gid     => 999,
    require => User[$name],
    members => ['www-data']
  }

  file { ["/home/${name}"]:
    ensure  => directory, # so make this a directory
    recurse => true, # enable recursive directory management
    owner   => $name,
    group   => $group,
    mode    => 640,
    source  => "puppet:///files/etc/skel/",
    require => [ User[$name], Group[$group] ]
  }

  file { ["/home/${name}/.ssh"]:
    ensure  => directory, # so make this a directory
    recurse => true, # enable recursive directory management
    owner   => $name,
    group   => $group,
    mode    => 640,
    require => [ User[$name], Group[$group] ]
  }

  #liquidprompt::user{ $name : }

}
