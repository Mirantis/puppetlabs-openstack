class openstack::cinder(
  $sql_connection,
  $rabbit_password,
  $rabbit_host     = '127.0.0.1',
  $volume_group    = 'cinder-volumes',
  $enabled         = true,
  $manage_volumes  = true,
  $purge_cinder_config = true,
  $package_ensure  = 'present'
) {
  if ($purge_cinder_config) {
    resources { 'cinder_config':
      purge => true,
    }
  }

  class { 'cinder::base':
    package_ensure  => $package_ensure,
    rabbit_password => $rabbit_password,
    rabbit_host     => $rabbit_host,
    sql_connection  => $sql_connection,
    verbose         => $verbose,
  }

  if $manage_volumes {
    class { 'cinder::volume':
      package_ensure  => $package_ensure,
      enabled => $enabled,
    }
    if $enabled {
      class { 'cinder::volume::iscsi':
        volume_group     => $volume_group,
      }
    }
  }
}
