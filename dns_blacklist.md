# Project
Notes for projects i'm working on or will never get to.


## DNS Blacklist
Script to determine whether or not you are listed in a blacklist.

```zsh
dns_blacklist=($(curl -s https://en.wikipedia.org/wiki/Comparison_of_DNS_blacklists |grep -Po
"[[:graph:]]{1,}\.\w{3}(?=</td)" |cut -b5-))

ip_address=$(curl -s http://httpbin.org/ip |awk '/"origin":/ {print $2}')
```
