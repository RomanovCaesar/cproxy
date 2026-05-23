package dns

// export functions from tunnel module

import "github.com/RomanovCaesar/cproxy/tunnel"

const RespectRules = tunnel.DnsRespectRules

type dnsDialer = tunnel.DNSDialer

var newDNSDialer = tunnel.NewDNSDialer
