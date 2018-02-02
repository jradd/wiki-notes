















Below is a list of the different ICMP types that you can change within Scapy.
| **TYPE**  |Code| Description                                                              |
|----------:|:---|:------------------------------------------------------------------------:|
| 0         |    |– Echo Reply | Echo reply (used to ping)                                  |
| 1, 2      |    |                                                                          |
|           |  0 | Destination port unreachable                                             |
| 4, 5      |    | Fragmentation required, and DF flag set                                  |
|           |    | Source route failed                                                      |
| 6         |    | Destination network unknown                                              |
| 7         |    | Destination host unknown                                                 |
| 8         |    | Source host isolated                                                     |
| 9         |    | Network administratively prohibited                                      |
| 10        |    | Host administratively prohibited                                         |
| 11        |    | Network unreachable for TOS                                              |
| 12        |    | Host unreachable for TOS                                                 |
| 13        |    | Communication administratively prohibited                                |
| 14        |    | Host Precedence Violation                                                |
| 15        |    | Precedence cutoff in effect                                              |
|           |  0 |Source quench (congestion control)                                        |
|           | 0  |Redirect Datagram for the Network                                         |
| |1 |Redirect Datagram for the Host|
| |2 |Redirect Datagram for the TOS & network|
||3| 
| |5 – Redirect Message|
| | |Destination protocol unreachable|
| |3 ||
| |4| – Source Quench|
| | | Destination host unreachable|
| |2| |
| |3| – Destination Unreachable|
| | | Destination network unreachable|
| |1| Redirect Datagram for the TOS & host|
| 6| | Alternate Host Address|
| 7| | Reserved|
| 8| | – Echo Request 0 Echo request (used to ping)|
| 9| | – Router Advertisement 0 Router Advertisement|
|10| | – Router Solicitation 0 Router discovery/selection/solicitation|
|  |0| TTL expired in transit|
|  |1| Fragment reassembly time exceeded|
|  |0| Pointer indicates the error|
|  |1| Missing a required option|
|  |2| Bad length|
|13| | – Timestamp 0 Timestamp|
|14| | – Timestamp Reply 0 Timestamp reply|
|15| | – Information Request |
|  |0|  Information Request|
|16| |  – Information Reply 0 Information Reply|
| 17 – Address Mask Request 0 Address Mask Request
| 18 – Address Mask Reply 0 Address Mask Reply
  19 
| 11 – Time Exceeded
| 12 – Parameter Problem: Bad IP header
Reserved for security
Reserved for robustness experiment
| 20 through 29
| 30 – Traceroute
| 31
Information Request
Datagram Conversion Error
42
32 Mobile Host Redirect
33 Where-Are-You (originally meant for IPv6)
34 35 Here-I-Am (originally meant for IPv6)
     Mobile Registration Request
36 Mobile Registration Reply
37 Domain Name Request
38 Domain Name Reply
39 SKIP Algorithm Discovery Protocol, Simple Key-Management for Internet Protocol
40 Photuris, Security failures
41 ICMP for experimental mobility protocols such as Seamoby [RFC4065]
42 through 255 Reserved


### DNS RECORD TYPES

