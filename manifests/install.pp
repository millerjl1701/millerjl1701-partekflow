# @api private
#
# This class is called from partekflow for installing the Partek Flow application.
#
class partekflow::install {
  group { $::partekflow::user_name:
    ensure => $::partekflow::user_ensure,
    gid    => $::partekflow::user_gid,
  }
  group { $::partekflow::user_groupname:
    ensure => $::partekflow::user_ensure,
    gid    => $::partekflow::user_groupname_gid,
  }
  user { $::partekflow::user_name:
    ensure     => $::partekflow::user_ensure,
    uid        => $::partekflow::user_uid,
    gid        => $::partekflow::user_groupname,
    groups     => $::partekflow::user_name,
    system     => true,
    comment    => $::partekflow::user_comment,
    managehome => $partekflow::user_managehome,
    home       => $partekflow::user_home,
    shell      => $partekflow::user_shell,
  }
  file { 'partek-public.key':
    ensure   => present,
    path     => '/etc/pki/rpm-gpg/partek-public.key',
    selrange => 's0',
    selrole  => 'object_r',
    seltype  => 'cert_t',
    seluser  => 'system_u',
    source   => 'puppet:///modules/partekflow/partek-public.key',
  }
  gpg_key { 'partek-public.key':
    path => '/etc/pki/rpm-gpg/partek-public.key',
  }
  if $::partekflow::yumrepo_manage {
    if $::partekflow::yumrepo_enabled_stable {
      $enabled_stable = '1'
    }
    else {
      $enabled_stable = '0'
    }
    if $::partekflow::yumrepo_enabled_unstable {
      $enabled_unstable = '1'
    }
    else {
      $enabled_unstable = '0'
    }
    if $::partekflow::yumrepo_ensure_stable {
      $ensure_stable = 'present'
    }
    else {
      $ensure_stable = 'absent'
    }
    if $::partekflow::yumrepo_ensure_unstable {
      $ensure_unstable = 'present'
    }
    else {
      $ensure_unstable = 'absent'
    }
    yumrepo { 'partekrepo-stable':
      ensure   => $ensure_stable,
      baseurl  => "${::partekflow::yumrepo_baseurl_server}${::partekflow::yumrepo_baseurl_stablepath}/\$basearch",
      enabled  => $enabled_stable,
      gpgcheck => 0,
      gpgkey   => 'file:///etc/pki/rpm-gpg/partek-public.key',
      require  => Gpg_key['partek-public.key'],
    }
    yumrepo { 'partekrepo-noarch-stable':
      ensure   => $ensure_stable,
      baseurl  => "${::partekflow::yumrepo_baseurl_server}${::partekflow::yumrepo_baseurl_stablepath}/noarch",
      enabled  => $enabled_stable,
      gpgcheck => 0,
      gpgkey   => 'file:///etc/pki/rpm-gpg/partek-public.key',
      require  => Gpg_key['partek-public.key'],
    }
    yumrepo { 'partekrepo-unstable':
      ensure   => $ensure_unstable,
      baseurl  => "${::partekflow::yumrepo_baseurl_server}${::partekflow::yumrepo_baseurl_unstablepath}/\$basearch",
      enabled  => $enabled_unstable,
      gpgcheck => 0,
      gpgkey   => 'file:///etc/pki/rpm-gpg/partek-public.key',
      require  => Gpg_key['partek-public.key'],
    }
    yumrepo { 'partekrepo-noarch-unstable':
      ensure   => $ensure_unstable,
      baseurl  => "${::partekflow::yumrepo_baseurl_server}${::partekflow::yumrepo_baseurl_unstablepath}/noarch",
      enabled  => $enabled_unstable,
      gpgcheck => 0,
      gpgkey   => 'file:///etc/pki/rpm-gpg/partek-public.key',
      require  => Gpg_key['partek-public.key'],
    }
    package { $::partekflow::package_name:
      ensure  => $::partekflow::package_ensure,
      require => [ User[$::partekflow::user_name], Yumrepo['partekrepo-stable'], Yumrepo['partekrepo-noarch-stable'], ],
    }
  }
  else {
    package { $::partekflow::package_name:
      ensure  => $::partekflow::package_ensure,
      require => User[$::partekflow::user_name],
    }

  }
}
