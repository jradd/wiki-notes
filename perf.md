# Performance
Performance --> Network, FreeBSD, TCP, RPC/NFS, etc...

## Network



### TCP
When trying to attain maximum throughput, the most important options involve
TCP window sizes and send/recv space buffers.
```
 ddb.panic=0                    # do not enter ddb console on kernel panic, reboot if possible
kern.bufcachepercent=90        # Allow the kernel to use up to 90% of the RAM for cache (default 10%)
machdep.allowaperture=2        # Access the X Window System (if you use X on the system)
net.inet.ip.forwarding=1       # Permit forwarding (routing) of packets through the firewall
net.inet.ip.ifq.maxlen=512     # Maximum allowed output queue length (256*number of physical interfaces)
net.inet.ip.mtudisc=0          # TCP MTU (Maximum Transmission Unit) discovery off since our mss is small enough
net.inet.tcp.rfc3390=1         # Enable RFC3390 TCP window increasing so larger CWND can take affect
net.inet.tcp.mssdflt=1440      # maximum segment size (1440 from scrub pf.conf match statement)
#net.inet.udp.recvspace=131072 # Increase UDP "receive" buffer size. Good for 200Mbit without packet drop.
#net.inet.udp.sendspace=131072 # Increase UDP "send" buffer size. Good for 200Mbit without packet drop.
```

## Performance Testing

##### iperf listening server
`root@test1: iperf -s`

##### iperf sending client
`root@test0: iperf -i 1 -t 30 -c test1`


`systat vmstat` - gives a top like display of memory totals, paging amount,
swap numbers, interrupts per second and much more.


## RTT
Round Trip Time

### Misc
any extra buffering overhead causes latency

van jacobsen

#### Queues
* Queues are necessary to handle bursts
* Too small ==> REDUCED THROUGHPUT
* Too LARGE ==> Latency Spikes
* Queues get larger ... TCP Global Sync can happen (BAD)

Perfect fair queuing is impossibe, so various hashing techniques are used.
- Divide flows up by a hash value based on a tuple of information
  * ip.src, ip.dst, port.src, port.dst, hw.addr
- Even an infinitely sized buffer will eventually lose packets [rfc970].























[rfc970]:     https://tools.ietf.org/html/rfc970 "On Packet Switches With Infinite Storage"



