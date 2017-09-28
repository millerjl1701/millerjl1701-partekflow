# == Class partekflow::install
#
# This class is called from partekflow for install.
#
class partekflow::install {
  if $::partekflow::package_manage {
    package { $::partekflow::package_name:
      ensure => $::partekflow::package_ensure,
    }
  }
}
