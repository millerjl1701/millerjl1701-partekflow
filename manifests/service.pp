# @api private
#
# This class is meant to be called from partekflow to manage the partekflowd service.
#
class partekflow::service {

  service { $::partekflow::service_name:
    ensure     => $::partekflow::service_ensure,
    enable     => $::partekflow::service_enable,
    hasstatus  => true,
    hasrestart => true,
  }
}
