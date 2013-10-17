class nass::websites {
  class {'nass::webservers':}
  class {'nass::bddservers':}

  case $site {
    'uploadfr':{
      file { ['/space/www/uploadfr.com', '/space/www/uploadfr.com/images']:
        ensure          => directory,
        owner           => 'dosu',
        group           => 'dosu',
      }

      file { ['/space/www/uploadfr.com/current']:
        ensure          => link,
        target          => "/var/www",
        replace         => false,
      }

      apache::vhost { 'www.uploadfr.com':
        add_listen      => false,
        ip              => '127.0.0.1',
        port            => '8080',
        servername      => 'www.uploadfr.com',
        docroot         => '/space/www/uploadfr.com/current',
        aliases         => [
          { alias => '/favicon.ico', path => '/space/www/uploadfr.com/current/content/system/favicon.ico' }, 
        ],
        directories     => [ 
          {   path => '/space/www/uploadfr.com', 
              options => ['-Indexes','FollowSymLinks'], 
              allow_override => ['All'], 
              satisfy => 'any',
          }
        ],
        logroot         => '/space/logs/www',
        access_log      => true,
        access_log_file      => 'a2_access_www.uploadfr.com.log',
        error_log      => true,
        error_log_file      => 'a2_error_www.uploadfr.com.log',
      }

      apache::vhost { 'adm.uploadfr.com':
        add_listen      => false,
        ip              => '127.0.0.1',
        port            => '8080',
        servername      => 'www.uploadfr.com',
        docroot         => '/space/www/uploadfr.com/current',
        aliases         => [
          { alias => '/favicon.ico', path => '/space/www/uploadfr.com/current/content/system/favicon.ico' }, 
        ],
        directories     => [ 
          {   path => '/space/www/uploadfr.com', 
              options => ['-Indexes','FollowSymLinks'], 
              auth_type       => 'basic',
              auth_name       => 'Acces restreint',
              auth_user_file  => '/space/secure/htpasswd',
              auth_require    => 'user nass',    
              allow_override => ['All'], 
              satisfy => 'any',
          }
        ],
        logroot         => '/space/logs/www',
        access_log      => true,
        access_log_file      => 'a2_access_adm.uploadfr.com.log',
        error_log      => true,
        error_log_file      => 'a2_error_adm.uploadfr.com.log',
      }

      apache::vhost { 'pics.uploadfr.com':
        add_listen      => false,
        ip              => '127.0.0.1',
        port            => '8080',
        servername      => 'pics.uploadfr.com',
        docroot         => '/space/www/uploadfr.com/images',
        directories     => [ 
          {   path => '/space/www/uploadfr.com', 
              options => ['-Indexes','FollowSymLinks'], 
              allow_override => ['All'], 
              satisfy => 'any',
          }
        ],
 
        rewrite_cond => [
          '%{REQUEST_FILENAME} !-f',
          '%{REQUEST_FILENAME} !-d',
        ],
        rewrite_rule => [
          '^(.+)(\s|%20)$ /$1 [R=301,QSA,L,NE]',
          '^(.+).(\s|%20)(jpg|jpeg|png|gif)$ /$1.$3 [R=301,QSA,L,NE]',
          '^/([A-Za-z0-9-]+)\.(jpg|jpeg|gif|png)$ /index.php?ir=$1.$2 [L]',
        ],



        logroot         => '/space/logs/www',
        access_log      => true,
        access_log_file      => 'a2_access_pics.uploadfr.com.log',
        error_log      => true,
        error_log_file      => 'a2_error_pics.uploadfr.com.log',
      }

      mysql::db { 'chevereto_v2':
        user            => 'chevereto_uf',
        password        => '{md5}$1$zUyvJn4o$MmppXr3LxkaVJwRiK6jjx/',
        host            => 'bdd',
        grant           => ['all'],
      }
    }
  }
}
