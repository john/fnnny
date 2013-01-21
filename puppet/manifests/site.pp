group { "puppet":
  ensure => "present",
}

exec { "apt-update":
  command => "/usr/bin/apt-get update",
  require => Group[puppet]
}

Exec["apt-update"] -> Package <| |>

include build_essential
include git
include gcc
include jruby
include libcurl4_openssl_dev
include libxml2_dev
include nginx
include openjdk_7_jdk
include trinidad