class nass::basicservers {

  # Installation Locales
  class { locales:
    locales => [
          'fr_FR ISO-8859-1',
          'fr_FR.UTF-8 UTF-8',
          'fr_FR.UTF-8@euro UTF-8',
          'fr_FR@euro ISO-8859-15'
      ];
  }

  apt::source { 'dotdeb':
    location          => "http://packages.dotdeb.org",
    release           => $lsbdistcodename ? {
      squeeze => "squeeze",
      wheezy => "wheezy",
    },
    repos             => "all",
    key               => "89DF5277",
    key_server        => "subkeys.pgp.net",
    pin               => "10",
    include_src       => false
  }

  package { "dnsutils": ensure => present;
            "atop":     ensure => present;
            "htop":     ensure => present;
            "unzip":    ensure => present;
            "sysstat":  ensure => present;
            "screen":   ensure => present;
            "curl":     ensure => present;
            "wget":     ensure => present;
            "libpcre3": ensure => present;
            "acl":      ensure => present;
  }
  nass::users{'dosu':}
  class { 'nass::ssh_keys::perso':}
  class { 'liquidprompt':}
  liquidprompt::user{ 'dosu' : }
  class { 'hosts':
    dynamic_mode => true,
  }
  class { 'postfix': }
  class { 'timezone':
    timezone => 'Europe/Paris',
  }
  file { ['/space']:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
  }
  sudo::directive { 'dosu':
    content => "dosu ALL=(ALL) NOPASSWD:ALL \n", # Double quotes and newline (\n) are needed here
  }

}
