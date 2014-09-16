#

class openldap {

    package { [
        'slapd',
        'python-ldap',
        ]:
        ensure => installed,
    }

    service { 'slapd':
        ensure     => running,
        hasstatus  => true,
        hasrestart => true,
    }

    # our replication dir
    file { '/var/lib/ldap/corp/':
        ensure  => directory,
        recurse => false,
        owner   => 'openldap',
        group   => 'openldap',
        mode    => '0750',
        force   => true,
    }

    file { '/etc/ldap/slapd.conf' :
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0444',
        content => template('openldap/slapd.erb'),
    }

    file { '/etc/default/slapd' :
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0444',
        content => template('openldap/default.erb'),
    }

    # Relationships
    Package['slapd'] -> File['/etc/ldap/slapd.conf']
    Package['slapd'] -> File['/etc/default/slapd']
    Package['slapd'] -> File['/var/lib/ldap/corp/']
    File['/etc/ldap/slapd.conf'] ~> Service['slapd']
    File['/etc/default/slapd'] ~> Service['slapd']
    File['/var/lib/ldap/corp/'] -> Service['slapd']
}
