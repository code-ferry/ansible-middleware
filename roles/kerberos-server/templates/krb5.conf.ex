[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 dns_lookup_realm = false
 dns_lookup_kdc = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true
 renewable = true
 rdns = false
 pkinit_anchors = /etc/pki/tls/certs/ca-bundle.crt
 default_realm = EXAMPLE.COM
 # default_ccache_name = KEYRING:persistent:%{uid}
 default_ccache_name = /tmp/krb5cc_default_%{uid}
 udp_preference_limit = 1

[realms]
 EXAMPLE.COM = {
  kdc = host201.example.com
  admin_server = host201.example.com
  default_realm = EXAMPLE.COM
  default_ccache_name = /tmp/krb5cc_example_%{uid}
 }

 NEWLAND.COM = {
  kdc = host202.example.com
  admin_server = host202.example.com
  default_realm = NEWLAND.COM
  default_ccache_name = /tmp/krb5cc_newland_%{uid}
 }

[domain_realm]
 .example.com = EXAMPLE.COM
 example.com = EXAMPLE.COM
 .newland.com = NEWLAND.COM
 newland.com = NEWLAND.COM
