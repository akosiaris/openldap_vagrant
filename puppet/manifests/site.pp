#

class { '::openldap':
    server_id => 1,
    suffix => 'dc=corp,dc=wikimedia,dc=org',
    datadir => '/var/lib/ldap/corp',
}
