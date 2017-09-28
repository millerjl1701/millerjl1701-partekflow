# Class: partekflow
# ===========================
#
# Main class that includes all other classes for manangement of the Partek Flow application.
#
# @param package_name [String] Specifies the name of the package to install. Default value: partekflow.
# @param package_ensure [String] Whether to install the partekflow package, and what version. Values: 'present', 'latest', or a specific version number. Default value: present.
# @param service_name [String] Specifies the name of the service to manage. Default value: partekflowd.
class partekflow (
  String $package_ensure,
  String $package_name,
  String $service_name,
) {

  # validate parameters here

  case $::operatingsystem {
    'RedHat', 'CentOS': {
      class { '::partekflow::install': } ->
      class { '::partekflow::config': } ~>
      class { '::partekflow::service': } ->
      Class['::partekflow']
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
