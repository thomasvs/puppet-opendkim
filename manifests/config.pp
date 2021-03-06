# you cannot pass undef to oversignheaders, so use '' to disable
class opendkim::config(
  $syslog                  = $opendkim::params::syslog,
  $umask                   = $opendkim::params::umask,
  $oversignheaders         = $opendkim::params::oversignheaders,
  $logwhy                  = $opendkim::params::logwhy,
  $milterdebug             = $opendkim::params::milterdebug,
) inherits ::opendkim::params {

  concat { '/etc/opendkim.conf':
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  concat::fragment {
    'opendkim config':
      target  => '/etc/opendkim.conf',
      content => template('opendkim/opendkim.conf.erb'),
      order   => 01;
  }

  concat { '/etc/opendkim/KeyTable':
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  concat::fragment {
    'opendkim KeyTable header':
      target  => '/etc/opendkim/KeyTable',
      source  => 'puppet:///modules/opendkim/etc/opendkim/KeyTable.header',
      order   => 01;
  }

  concat { '/etc/opendkim/SigningTable':
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  concat::fragment {
    'opendkim SigningTable header':
      target  => '/etc/opendkim/SigningTable',
      source  => 'puppet:///modules/opendkim/etc/opendkim/SigningTable.header',
      order   => 01;
  }


  if ($::opendkim::params::service_flavor == 'Debian') {
    concat { $::opendkim::params::service_config:
      owner => root,
      group => root,
      mode  => '0644';
    }

    concat::fragment {
      'opendkim default config':
        target  => '/etc/default/opendkim',
        content => template('opendkim/opendkim_default.erb'),
        order   => 01;
    }
  }
}
