class nass::test {

  file { ['/space/logs', '/space/confs']:
    ensure          => directory,
    owner           => 'dosu',
    group           => 'dosu',
  }

  case $role {
      'web':{
        class {'nass::webservers':}
        
        file { ['/space/logs/www', '/space/confs/www']:
          ensure          => directory,
          owner           => 'dosu',
          group           => 'dosu',
        }

#        file { ['/space/confs/www/htpasswd']:
#            owner => 'webadmin',
#            group => 'webadmin',
#            mode  => '0644',
#            source => 'puppet:///modules/nass/files/www/htpasswd',
#            require => File['/space/conf/www'];
#        }

  file { ['/space/www', '/space/www/uploadfr.com', '/space/www/uploadfr.com/current']:
    ensure          => directory,
    owner           => 'dosu',
    group           => 'dosu',
  }


  apache::vhost { 'www.uploadfr.com':
    add_listen      => false,
    ip              => '127.0.0.1',
    port            => '8080',
    servername      => 'www.uploadfr.com',
    docroot         => '/space/www/uploadfr.com/current',
    aliases         => [  { alias => '/favicon.ico', path => '/space/www/cms/drupal/v7/otil/culturebox/current/public/sites/all/themes/culturebox/favicon.ico' }, ],
    directories     => [ {  path => '/space/www/uploadfr.com', 
          options => ['-Indexes','FollowSymLinks'], 
          auth_type       => 'basic',
          auth_name       => 'Acces restreint',
          auth_user_file  => '/space/secure/www_htpasswd',
          auth_require    => 'user ftvc_team exploit',    
          allow_override => ['All'], 
#         allow => 'from 127.0.0.1', 
#         allow => 'from 194.51.35',
#         allow => 'from 62.39.79',
#         deny => 'from all',
          satisfy => 'any',
        }],
        logroot         => '/space/logs/www',
        access_log      => true,
        access_log_file      => 'a2_access_www.uploadfr.com.log',
        error_log      => true,
        error_log_file      => 'a2_error_www.uploadfr.com.log',
      }
    }

    'bdd':{
      class {'nass::bddservers':}
      file { ['/space/logs/bdd']:
        ensure          => directory,
        owner           => 'dosu',
        group           => 'dosu',
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
