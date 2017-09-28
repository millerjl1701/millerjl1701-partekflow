# @api private
#
# This class is meant to be called from partekflow to manage the partekflowd service.
#
class partekflow::service {

  service { $::partekflow::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
