# == Class partekflow::install
#
# This class is called from partekflow for install.
#
class partekflow::install {

  package { $::partekflow::package_name:
    ensure => present,
  }
}
