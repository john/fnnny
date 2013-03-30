class openjdk_7_jdk {
  
  package { "openjdk-7-jdk":
    ensure => present,
  }
  
  package { "jsvc":
    ensure => present,
    require => Package["openjdk-7-jdk"]
  }
}