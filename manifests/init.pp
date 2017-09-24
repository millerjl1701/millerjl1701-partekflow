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
  $package_name = $::partekflow::params::package_name,
  $service_name = $::partekflow::params::service_name,
) inherits ::partekflow::params {

  # validate parameters here

  class { '::partekflow::install': } ->
  class { '::partekflow::config': } ~>
  class { '::partekflow::service': } ->
  Class['::partekflow']
}
