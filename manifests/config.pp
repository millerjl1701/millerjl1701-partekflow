# @api private
#
# This class is called from partekflow for service config.
#
class partekflow::config {
  file { $::partekflow::config_catalina_tmpdir:
    ensure => directory,
    owner  => $::partekflow::user_name,
    group  => $::partekflow::user_groupname,
    mode   => '0755',
  }
  $config_content = template($::partekflow::config_template)
  file { $::partekflow::config_file:
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $config_content,
  }
}
