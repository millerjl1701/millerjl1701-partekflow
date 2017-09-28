# Class: partekflow
# ===========================
#
# Full description of class partekflow here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class partekflow (
  $package_name,
  $service_name,
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
