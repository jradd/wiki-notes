# pfSense Lab Guide

## Virtualbox


### Network Adapters


#### WAN0 // le0 // Public-facing
- Attached to: "Bridged Adapter"
- Name: "en0"
- Adapter Type: "PCnet-PCI II (Am79C970A)"
- Promiscuous Mode: "Deny

#### LAN0 // le1 // Private-internal
- Attached to: "Internal Network"
- Name: "intnet"
- Type: "PCnet-PCI II"
- Promiscuous Mode: "Deny"


#### Network Configuration

|:-----------|:-----------------------|
|Interface   | Network/Subnet         |
|WAN -> le0  | DHCP: 192.168.1.102/24 |
|LAN -> le1  | 10.0.0.1/24            |
|            | 10.0.0.11 --> 10.0.0.20|  





> revert to http as the webconf protocol. "Y"
> admin/pfsense
> Be sure to use 'intnet' for vm's on this network


