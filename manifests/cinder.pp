class openstack::cinder(
  $sql_connection,
  $rabbit_password,
  $rabbit_host     = '127.0.0.1',
  $volume_group    = 'cinder-volumes',
  $enabled         = true,
  $purge_cinder_config = true,
) {
  if ($purge_cinder_config) {
    resources { 'cinder_config':
      purge => true,
    }
  }

  class { 'cinder::base':
    rabbit_password => $rabbit_password,
    rabbit_host     => $rabbit_host,
    sql_connection  => $sql_connection,
    verbose         => $verbose,
  }

  # Install / configure nova-volume
  class { 'cinder::volume':
    enabled => $enabled,
  }
  if $enabled {
    class { 'cinder::volume::iscsi':
      volume_group     => $volume_group,
    }
  }
}
