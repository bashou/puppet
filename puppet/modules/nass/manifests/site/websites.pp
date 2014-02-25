class nass::websites {

  case $site {
    'uploadfr':{
      class {'nass::web_apache':}
      class {'nass::bddservers':}

      file { ['/space/www/uploadfr.com', '/space/cache/uploadfr', '/space/secure/backup/uploadfr']:
        ensure          => directory,
        owner           => 'dosu',
        group           => 'dosu',
      }

      file { ['/space/www/uploadfr.com/images']:
        ensure          => directory,
        owner           => 'www-data',
        group           => 'www-data',
      }

      file { ['/space/www/uploadfr.com/current']:
        ensure          => link,
        target          => "/var/www",
        replace         => false,
      }

      file { ['/space/www/kixmytee.com', '/space/cache/kixmytee', '/space/secure/backup/kixmytee']:
        ensure          => directory,
        owner           => 'dosu',
        group           => 'dosu',
      }

      file { ['/space/www/kixmytee.com/current']:
        ensure          => link,
        target          => "/var/www",
        replace         => false,
      }

      apache::listen{ '8080':}

      apache::vhost { 'www.uploadfr.com':
        add_listen      => false,
        ip              => '*',
        port            => '8080',
        servername      => 'www.uploadfr.com',
        docroot         => '/space/www/uploadfr.com/current',
        aliases         => [
          { alias => '/favicon.ico', path => '/space/www/uploadfr.com/current/content/system/favicon.ico' }, 
        ],
        directories     => [ 
          {   path => '/space/www/uploadfr.com', 
              options => ['-Indexes','FollowSymLinks', 'ExecCGI'], 
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
        ip              => '*',
        port            => '8080',
        servername      => 'adm.uploadfr.com',
        docroot         => '/space/www/uploadfr.com/current',
        aliases         => [
          { alias => '/favicon.ico', path => '/space/www/uploadfr.com/current/content/system/favicon.ico' }, 
          { alias => '/robots.txt', path => '/space/secure/robots.txt' }, 
        ],
        directories     => [ 
          {   path => '/space/www/uploadfr.com', 
              options => ['-Indexes','FollowSymLinks', 'ExecCGI'], 
#              auth_type       => 'basic',
#              auth_name       => 'Acces restreint',
#              auth_user_file  => '/space/secure/htpasswd',
#              auth_require    => 'user nass',    
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
        ip              => '*',
        port            => '8080',
        servername      => 'pics.uploadfr.com',
        docroot         => '/space/www/uploadfr.com/images',
        aliases         => [
          { alias => '/robots.txt', path => '/space/secure/robots.txt' }, 
        ],
        directories     => [ 
          {   path => '/space/www/uploadfr.com', 
              options => ['-Indexes','FollowSymLinks','ExecCGI'], 
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

      apache::vhost { 'www.kixmytee.com':
        add_listen      => false,
        ip              => '*',
        port            => '8080',
        servername      => 'www.kixmytee.com',
        docroot         => '/space/www/kixmytee.com/current',
        directories     => [ 
          {   path => '/space/www/kixmytee.com', 
              options => ['-Indexes','FollowSymLinks', 'ExecCGI'], 
              allow_override => ['All'], 
              satisfy => 'any',
          }
        ],
        logroot         => '/space/logs/www',
        access_log      => true,
        access_log_file      => 'a2_access_www.kixmytee.com.log',
        error_log      => true,
        error_log_file      => 'a2_error_www.kixmytee.com.log',
      }

      class { "nginx":
        log_file => [
          '/space/logs/www/ngx_access.log',
          '/space/logs/www/ngx_errors.log',
        ],
        source_dir       => "puppet:///modules/nass/nginx/",
        source_dir_purge => true, # Set to true to purge any existing file not present in $source_dir
      }

      mysql::db { 'chevereto_v2':
        user            => 'chevereto_uf',
        password        => 'uf201012dec',
        host            => 'localhost',
        grant           => ['all'],
      }

      mysql::db { 'kixmytee':
        user            => 'u71252643',
        password        => 'MEN88TOS',
        host            => 'localhost',
        grant           => ['all'],
      }

      logrotate::file {
        'nginx':
          log => '/space/logs/www/ngx_*.log',
          options => [ 'daily', 'missingok', 'rotate 21', 'compress', 'delaycompress', 'notifempty', 'create 0644 dosu dosu', 'sharedscripts' ],
          postrotate => [ '[ ! -f /var/run/nginx.pid ] || kill -USR1 `cat /var/run/nginx.pid`' ],
          ensure => 'present';
       'apache2':
          log => '/space/logs/www/a2_*.log',
          options => [ 'daily', 'missingok', 'rotate 21', 'compress', 'delaycompress', 'notifempty', 'copytruncate' ],
          ensure => 'present';
      }

      file { '/space/secure/crons/backup_uploadfr.sh':
        owner => 'dosu',
        group => 'dosu',
        mode => '0755',
        source => 'puppet:///modules/nass/crons/backup_uploadfr.sh',
        require => File['/space/secure'];
      }

      class {'cron':}
      cron::job{
        'backup_uploadfr':
          minute => '30',
          hour => '1',
          date => '*',
          month => '*',
          weekday => '*',
          user => 'dosu',
          command => '/bin/bash /space/secure/crons/backup_uploadfr.sh 1>/dev/null 2>&1',
          environment => [ 'SHELL=/bin/bash', 'PATH=/usr/local/bin:/usr/bin:/bin' ];
      }

      cron::job{
        'wp_cron_kixmytee':
          minute => '*/15',
          hour => '*',
          date => '*',
          month => '*',
          weekday => '*',
          user => 'dosu',
          command => '/usr/bin/cron http://www.kixmytee.com/wp-cron.php 1>/dev/null 2>&1',
          environment => [ 'SHELL=/bin/bash', 'PATH=/usr/local/bin:/usr/bin:/bin' ];
      }
    }
  }
}
