group { "puppet":
  ensure => "present",
}

exec { "apt-update":
  command => "/usr/bin/apt-get update",
  require => Group[puppet]
}

Exec["apt-update"] -> Package <| |>

package { "openjdk-7-jdk":
  ensure => present
}

include git
include gcc
include jruby
include nginx
include trinidad