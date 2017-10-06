# Class: partekflow
# ===========================
#
# Main class that includes all other classes for manangement of the Partek Flow application.
#
# @param config_catalina_tmpdir [Stdlib::Absolutepath] Specifies the directory for temporary files. Default value: /home/flow/partek_flow/temp
# @param config_file [Stdlib::Absolutepath] Specifies the partekflowd configuration file. Default value: /etc/partekflow.conf
# @param config_installdir [Stdlib::Absolutepath] Specifies the path to the location of the Partek Flow insallation. Default value: /opt/partek_flow
# @param config_template [String] Specifies an absolute or relative file path to an ERB template for the config file. Default value: partekflow/partekflow.conf.erb
# @param package_ensure [String] Whether to install the partekflow package, and what version. Values: 'present', 'latest', or a specific version number. Default value: present.
# @param package_name [String] Specifies the name of the package to install. Default value: partekflow.
# @param service_enable [Boolean] Whether to enable the partekflowd service at boot. Default value: true.
# @param service_ensure [Enum['running', 'stopped']] Whether the patrekflowd service should be running. Default value: 'running'.
# @param service_name [String] Specifies the name of the service to manage. Default value: partekflowd.
# @param user_comment [String] Specifies User ID info for the user account. Default: Partek Flow daemon.
# @param user_ensure [Enum['present', 'absent']] Whether the parteflowd user and group should be present. Default value: true
# @param user_gid [Integer[1, 999]] The gid of the group to create for the service account with name of user_name (flow); however this is not the primary group of the user. Default value: 495.
# @param user_groupname [String] The name of the primary group to create for the partekdflow server. Default value: flowuser
# @param user_groupname_gid [Integer[1, 999]] The gid of the primary group (flowuser) to create for the partekflowd server. Default value: 494.
# @param user_home [Stdlib::Absolutepath] Location of user home directory. Default value: /home/flow
# @param user_managehome [Boolean] Whether or not to manage the user home directory. Default value: true.
# @param user_name [String] The user used to run the partekflowd server. Default value: flow.
# @param user_shell [Stdlib::Absolutepath] User shell. Default value: /bin/sh
# @param user_uid [Integer[1, 999]] The uid of the user to create for the partekflowd server. Default value: 495.
# @param yumrepo_baseurl_server [Optional Stdlib::Httpurl] URI of repository server. Default value (on osfamily=RedHat): http://packages.partek.com
# @param yumrepo_baseurl_stablepath [Optional String] path to the location of the stable repositories not including the architecture portion (i.e. basearch or noarch). Default value (on osfamily=RedHat): /redhat/stable
# @param yumrepo_baseurl_unstablepath [Optional String] path to the location of the unstable package repositories not including the architecture portion (i.e. basearch or noarch). Default value (on osfamily=RedHat): /redhat/unstable
# @param yumrepo_enabled_stable [Optional Boolean] Whether or not to enable the stable yumrepo resources. Default value (on osfamily=RedHat): true
# @param yumrepo_enabled_unstable [Optional Boolean] Whether or not to enable the unstable yumrepo resources. Default value (on osfamily=RedHat): false
# @param yumrepo_ensure_stable [Optional Boolean] Specifies if the stable yumrepos.d config files should be present (true) or absent (false). Default value (on osfamily=RedHat): true
# @param yumrepo_ensure_unstable [Optional Boolean] Specifies if the unstable yumrepos.d config files should be present (true) or absent (false). Default value (on osfamily=RedHat): true
# @param yumrepo_manage [Optional Boolean] Whether or not to manage the package repositories. Default value (on osfamily=RedHat): true.
class partekflow (
  Stdlib::Absolutepath $config_catalina_tmpdir,
  Stdlib::Absolutepath $config_file,
  Stdlib::Absolutepath $config_installdir,
  String $config_template,
  String $package_ensure,
  String $package_name,
  Boolean $service_enable,
  Enum['running', 'stopped'] $service_ensure,
  String $service_name,
  String $user_comment,
  Enum['present', 'absent'] $user_ensure,
  Integer[1, 999] $user_gid,
  String $user_groupname,
  Integer[1, 999] $user_groupname_gid,
  Stdlib::Absolutepath $user_home,
  Boolean $user_managehome,
  String $user_name,
  Stdlib::Absolutepath $user_shell,
  Integer[1, 999] $user_uid,
  Optional[Stdlib::Httpurl] $yumrepo_baseurl_server,
  Optional[String] $yumrepo_baseurl_stablepath,
  Optional[String] $yumrepo_baseurl_unstablepath,
  Optional[Boolean] $yumrepo_enabled_stable,
  Optional[Boolean] $yumrepo_enabled_unstable,
  Optional[Boolean] $yumrepo_ensure_stable,
  Optional[Boolean] $yumrepo_ensure_unstable,
  Optional[Boolean] $yumrepo_manage,
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
