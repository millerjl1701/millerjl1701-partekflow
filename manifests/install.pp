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
  yumrepo { 'partekrepo-stable':
    ensure   => present,
    baseurl  => 'http://packages.partek.com/redhat/stable/$basearch',
    enabled  => 1,
    gpgcheck => 0,
    gpgkey   => 'file:///etc/pki/rpm-gpg/partek-public.key',
    require  => Gpg_key['partek-public.key'],
  }
  yumrepo { 'partekrepo-noarch-stable':
    ensure   => present,
    baseurl  => 'http://packages.partek.com/redhat/stable/noarch',
    enabled  => 1,
    gpgcheck => 0,
    gpgkey   => 'file:///etc/pki/rpm-gpg/partek-public.key',
    require  => Gpg_key['partek-public.key'],
  }
  yumrepo { 'partekrepo-unstable':
    ensure   => present,
    baseurl  => 'http://packages.partek.com/redhat/unstable/$basearch',
    enabled  => 0,
    gpgcheck => 0,
    gpgkey   => 'file:///etc/pki/rpm-gpg/partek-public.key',
    require  => Gpg_key['partek-public.key'],
  }
  yumrepo { 'partekrepo-noarch-unstable':
    ensure   => present,
    baseurl  => 'http://packages.partek.com/redhat/unstable/noarch',
    enabled  => 0,
    gpgcheck => 0,
    gpgkey   => 'file:///etc/pki/rpm-gpg/partek-public.key',
    require  => Gpg_key['partek-public.key'],
  }
  package { $::partekflow::package_name:
    ensure  => $::partekflow::package_ensure,
    require => [ User[$::partekflow::user_name], Yumrepo['partekrepo-stable'], Yumrepo['partekrepo-noarch-stable'], ],
  }
}
