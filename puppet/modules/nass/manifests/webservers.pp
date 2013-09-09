class nass::webservers {
  class {'apache':
    mpm_module => 'prefork',
  }
  apache::listen{ '80':}
  class {'apache::mod::php':}
  apache::mod { 'expires':}
  apache::mod { 'headers':}
  apache::mod { 'include':}
  apache::mod { 'info':}
  apache::mod { 'rewrite':}
  apache::mod { 'status':}
  apache::mod { 'suexec':}

  class { 'php': }
  php::module { 'imagick':}
  php::module { 'gd':}
  php::module { 'curl':}
  php::module { "apc":
    module_prefix => "php-"
  }
  php::pecl::module { 'memcached': }

  php::augeas {
    'php-memorylimit':
      entry  => 'PHP/memory_limit',
      value  => '256M';
    'php-date_timezone':
      entry  => 'Date/date.timezone',
      value  => 'Europe/Paris';
  }
  User <| title == dosu |>
  User <| title == dosu |> {groups +> "www-data"}
  User <| title == www-data |>
  User <| title == www-data |> {groups +> "dosu"}

  class { 'mysql::php': }

}
