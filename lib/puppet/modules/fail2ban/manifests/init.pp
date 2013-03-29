class fail2ban {
  
  package { "fail2ban":
    ensure => present,
  }
  
  service { 'fail2ban':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['fail2ban'],
  }
  
}