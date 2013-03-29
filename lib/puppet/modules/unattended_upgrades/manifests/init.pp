class unattended_upgrades {
  
  $ua_home = "/etc/apt/apt.conf.d"
  
  package { "unattended-upgrades":
    ensure => present,
  }
  
  file { "10periodic":
    path => "${ua_home}/10periodic",
    content => template("unattended_upgrades/10periodic.erb"),
    require => Package["unattended-upgrades"],
  }
  
  file { "50unattended":
    path => "${ua_home}/50unattended-upgrades",
    content => template("unattended_upgrades/50unattended-upgrades.erb"),
    require => File["10periodic"],
  }
  
}