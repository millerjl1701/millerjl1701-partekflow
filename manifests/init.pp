# Class: partekflow
# ===========================
#
# Main class that includes all other classes for manangement of the Partek Flow application.
#
# @param package_ensure [String] Whether to install the partekflow package, and what version. Values: 'present', 'latest', or a specific version number. Default value: present.
# @param package_manage [Boolean] Whether to manage the partekflow package. Default value: true.
# @param package_name [String] Specifies the name of the package to install. Default value: partekflow.
# @param service_enable [Boolean] Whether to enable the partekflowd service at boot. Default value: true.
# @param service_ensure [Enum['running', 'stopped']] Whether the patrekflowd service should be running. Default value: 'running'.
# @param service_name [String] Specifies the name of the service to manage. Default value: partekflowd.
class partekflow (
  String $package_ensure,
  Boolean $package_manage,
  String $package_name,
  Boolean $service_enable,
  Enum['running', 'stopped'] $service_ensure,
  String $service_name,
) {

  # validate parameters here

  case $::operatingsystem {
    'RedHat', 'CentOS': {

      contain partekflow::install
      contain partekflow::config
      contain partekflow::service

      Class['::partekflow::install']
      -> Class['partekflow::config']
      ~> Class['partekflow::service']

    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
