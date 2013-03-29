class tzdata {
  
  package { "tzdata":
    ensure => present,
  }
  
  file { "/etc/timezone":
    path => "/etc/timezone",
    content => template("tzdata/timezone.erb"),
    require => Package["tzdata"],
  }
  
  exec { "dpkg-reconfigure":
    command => "/usr/sbin/dpkg-reconfigure -f noninteractive tzdata",
    require => File["/etc/timezone"],
  }
  
}