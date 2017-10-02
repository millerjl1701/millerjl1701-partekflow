# Class: partekflow
# ===========================
#
# Main class that includes all other classes for manangement of the Partek Flow application.
#
# @param package_ensure [String] Whether to install the partekflow package, and what version. Values: 'present', 'latest', or a specific version number. Default value: present.
# @param package_name [String] Specifies the name of the package to install. Default value: partekflow.
# @param service_enable [Boolean] Whether to enable the partekflowd service at boot. Default value: true.
# @param service_ensure [Enum['running', 'stopped']] Whether the patrekflowd service should be running. Default value: 'running'.
# @param service_name [String] Specifies the name of the service to manage. Default value: partekflowd.
# @param user_comment [String] Specifies User ID info for the user account. Default: Partek Flow daemon.
# @param user_ensure [Enum['present', 'absent']] Whether the parteflowd user and group should be present. Default value: true
# @param user_gid [Integer[1, 499]] The gid of the group to create for the partekflowd server. Default value: 499.
# @param user_groupname [String] The name of the group to create for the partekdflow server. Default value: flowuser
# @param user_home [Stdlib::Absolutepath] Location of user home directory. Default value: /home/flow
# @param user_managehome [Boolean] Whether or not to manage the user home directory. Default value: true.
# @param user_name [String] The user used to run the partekflowd server. Default value: flow.
# @param user_shell [Stdlib::Absolutepath] User shell. Default value: /bin/sh
# @param user_uid [Integer[1, 499]] The uid of the user to create for the partekflowd server. Default value: 499.
class partekflow (
  String $package_ensure,
  String $package_name,
  Boolean $service_enable,
  Enum['running', 'stopped'] $service_ensure,
  String $service_name,
  String $user_comment,
  Enum['present', 'absent'] $user_ensure,
  Integer[1, 499] $user_gid,
  String $user_groupname,
  Stdlib::Absolutepath $user_home,
  Boolean $user_managehome,
  String $user_name,
  Stdlib::Absolutepath $user_shell,
  Integer[1, 499] $user_uid,
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
