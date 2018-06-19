# ScaPy

### Misc commands
Port scan example:
```
>>> p=sr(IP(src=" ",dst=" ")/TCP(sport=RandShort(),dport=[20,22,etc]),inter=0.5,retry=3,timeout=1)
>>> ans,unans=_
>>> ans.show()
>>> unans.show()
>>> ans.summary()
```
DNS Query:
```
sr1(IP(dst="10.3.0.100")/UDP()/DNS(rd=1,qd=DNSQR(qname="boothologie.net"))) 
```

`rd=1` --> Recursion desired
`qd=DNSQR(qname=" ")` --> Query Domain = DNS Question Record, qname is the query name

```
sr1(IP(dst=" ")/UDP()/DNS(rd=1,qd=DNSQR(qname=" ", qtype="NS")))
```
`qtype` --> Query Type "NS" (nameservice)

TraceRoute:
```
traceroute([" "], maxttl=20)
```

`...,dport=80` --> default

ARP Ping
`arping("10.3.0.*")`

Sniff
`sniff()`
`a=_`
`a.nsummary()`

`sniff(iface="eth0",filter="icmp",count=10)`


pcap:

```
>>> pkts = rdpcap("/tmp/read1.pcap")
```
`pkts.summary()`
`pkts[1]`

`>>> pkts=sniff(iface="eth0",filter="tcp and port 80",count=10)`

`wrpcap("/tmp/outfile.pcap",pkts)`


`packets=Ether()/IP(dst=" ")/ICMP()`


`wireshark(packets)`

```
>>pkts=rdpcap(“/tmp/attack.pcap”)
>>>for pkt in pkts:
>>> send(pkt)
>>>
```

