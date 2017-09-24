# == Class partekflow::service
#
# This class is meant to be called from partekflow.
# It ensure the service is running.
#
class partekflow::service {

  service { $::partekflow::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
