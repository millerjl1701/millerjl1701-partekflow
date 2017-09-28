# @api private
#
# This class is called from partekflow for installing the Partek Flow application.
#
class partekflow::install {
  if $::partekflow::package_manage {
    package { $::partekflow::package_name:
      ensure => $::partekflow::package_ensure,
    }
  }
}
