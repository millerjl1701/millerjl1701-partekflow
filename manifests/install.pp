# @api private
#
# This class is called from partekflow for installing the Partek Flow application.
#
class partekflow::install {
  group { $::partekflow::user_groupname:
    ensure => $::partekflow::user_ensure,
    gid    => $::partekflow::user_gid,
  }
  user { $::partekflow::user_name:
    ensure     => $::partekflow::user_ensure,
    uid        => $::partekflow::user_uid,
    gid        => $::partekflow::user_gid,
    system     => true,
    comment    => $::partekflow::user_comment,
    managehome => $partekflow::user_managehome,
    home       => $partekflow::user_home,
    shell      => $partekflow::user_shell,
    require    => Group[$::partekflow::user_groupname],
  }
  package { $::partekflow::package_name:
    ensure  => $::partekflow::package_ensure,
    require => User[$::partekflow::user_name],
  }
}
