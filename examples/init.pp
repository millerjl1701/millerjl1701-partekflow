node default {

  notify { 'enduser-before': }
  notify { 'enduser-after': }

  class { 'partekflow':
    require => Notify['enduser-before'],
    before  => Notify['enduser-after'],
  }

}
