class gcc {
  package{ [ 'gcc', 'gcc-c++' ]:
    ensure => present,
  }
}