# == Class partekflow::params
#
# This class is meant to be called from partekflow.
# It sets variables according to platform.
#
class partekflow::params {
  case $::osfamily {
    'RedHat': {
      $package_name = 'partekflow'
      $service_name = 'partekflow'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
