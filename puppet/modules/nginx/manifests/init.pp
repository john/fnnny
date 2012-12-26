class nginx {
  package { "nginx":
    ensure => present,
  }
  
  service { "nginx":
    ensure => running,
    require => Package["nginx"],
  }
}