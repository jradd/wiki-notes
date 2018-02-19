# Notes
For all the things


SSH
===============

`chmod 700 ${HOME}/.ssh`  
`chmod 600 ${HOME}/.ssh/authorized_keys`  

Copying public key using ssh:

`cat ~/.ssh/id_rsa.pub | ssh username@remote_host "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"`

Secret Disconnect:
<RETURN> ~ .
(ENTER SHIFT TILDE PERIOD)

Tunnel
===============

Requires a middleman host (goo) and someone (ctm) at the remote PC.

have the remote user (ctm) ssh to the middleman host

```
ssh -R 10002:localhost:22 ctm@goo.net.some.com
# you ssh to the same host normally

ssh you@goo.net.some.com
# you use/hijack ctm’s ssh session via tunneling

ssh ctm@localhost -p 10002
```
X11 Forwarding
===============
Some tid-bits on X11 forwarding in my attempt to address:
CVE-2015-5352

Viz. of X11 Forwarding Functionality:

[  ssh client  ] --> [  ssh server  ]  
 [ x11 server ]       [ x11 client ]


x11 sudo:
`xauth list`
`xauth add flip.nac.uci.edu/unix:10  MIT-MAGIC-COOKIE-1 c6df14142a75ed93ff1aa7b4a4e2b660`

Debian
===============
Export packages to replicate debian system:

`dpkg --get-selections > pkginstalled`

Now to import:
`dpkg --set-selections < pkginstalled`
`apt-get dselect-upgrade`

If you get a bunch of warnings like: package blabla not in database

You’ll need to install and use the dselect package to set things right:
```
sudo apt-get install dselect
sudo dselect
   -> Update
   -> Install
```
Generate list of packages and how to reinstall them:

`dpkg --get-selections |grep -v deinstall | cut -f1`

Update init scripts:
```
sudo update-rc.d <basename> defaults
# ie
sudo update-rc.d sgeexecd defaults
```
Fix missing keys:
```
export THEKEY='' # like '2A8E3034D018A4CE' (from above)  or whatever it is
gpg --keyserver subkeys.pgp.net --recv ${THEKEY}
gpg --export --armor ${THEKEY} | sudo apt-key add -
```

Now clean out list dir:
```
apt-get clean
cd /var/lib/apt
mv lists lists.old
mkdir -p lists/partial
apt-get clean
apt-get update
```

RHEL
==============

Repair yum:
```
yum clean metadata
yum clean dbcache
yum update

# or even
yum clean all


Linux:
==============

DELETE FILES FAST (CAUTION)
```
mkdir empty
rsync -a --delete empty/ targetdir/
```
`perl -e 'for(<*>){((stat)[9]<(unlink))}'`


Flush ALL cache:

```
sync && echo 1 > /proc/sys/vm/drop_caches
```

Recursive wget:
`wget -e robots=off --wait 1 http://your.site.here`


# Last (will show you your remote host name, and other awesome shit!!!)
`last -ad`
`last root`



Move data fast!!!!


* SEND  
`pv -pet HG-U133_Plus_2.na26.annot.csv | nc -l -p 1234`  

* RECV
`nc bongo.nac.uci.edu 1234 |pv -b >test.file`

Networking
================

IPv4 Forwarding:

```
echo 1 > /proc/sys/net/ipv4/ip_forward
/sbin/iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
/sbin/iptables -A FORWARD -i eth1 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT
```


Force a user to log out:
`pkill -KILL -u username`

```
comm [-1] [-2] [-3 ] file1 file2
-1 Suppress the output column of lines unique to file1.
-2 Suppress the output column of lines unique to file2.
-3 Suppress the output column of lines duplicated in file1 and file2.
```


### Displays all terminal colors to screen
```
for i in $(seq 0 10 256); do for j in $(seq 0 1 9); do n=$(expr $i + $j); \
    [ $n -gt 256 ] && break || echo -ne "\t\033[38;5;${n}m${n}\033[0m"; done; echo; done
```


Grep OR
```
grep -rin  "this\|that" * |wc
grep -v 'DROPPED\|ntpd\|dhcpd' /var/log/syslog |less
egrep "relative error|tstep, maxcr=        4000" somefile
```
Query strings in database:
```
sqlite> select * from pcinfo where hostname like "bong%";
2|2|128.200.34.111|bongo.nac.uci.edu|4|1|1|0
45|16|128.200.84.8|bongo.nacs.uci.edu|4|1|1|0

sqlite>  select * from owner  where userid like "ps%";
29|Pegah|Sattari|psattari@uci.edu|0|psattari@uci.edu|uciuser@uci.edu|(949)
231-9908|backupaccount|2009-01-20
```

mysql root password:
```
shell> mysql -u root
Issue the following statements in the mysql client:

 mysql> UPDATE mysql.user SET Password=PASSWORD('newpwd')
     ->                   WHERE User='root';
      mysql> FLUSH PRIVILEGES;
```

Time commands:

```
/usr/bin/time -p -a -o lstime ls -lR nacs > lso
```

```
#!/bin/bash
ROOT=/lsi;
H=`hostname`;
SPATH=${ROOT}/hmangala/${H}
mkdir -p ${SPATH};
    echo -n "$H : Loadavg: "
    cat /proc/loadavg;
for II in $(seq 1 10); do
    dd if=/dev/zero of=${SPATH}/out${II} bs=1M count=2K &
done
sync
wait
```

Bash Array:
```
#!/bin/bash
IP_ARRAY=("106.51.107.164" "109.161.229.120" "117.18.231.29" "121.243.33.212")
# note the array spec above and the reference format below.  If the elements
# were integers or even floats(?), wouldn't need the "" (I think).

for i in ${IP_ARRAY[@]}; do
        echo "$i = "
        nslookup ${i} | grep "name ="| scut -f 1 -d '=' | uniq
    echo "==============="
done
```




```
list='a64-112 a64-120 a64-129 a64-178 claw2 claw3 claw4 n121'
for hj in $list; do
  echo $hj
done

# also the famous ITER:
for ITER in $(seq -f "%03g" 1 140); do echo A64HOST=a64-${ITER}; done
for ITER in $(echo {p..q}); do time rsync -a $ITER*  /h; done

# to nest padded and unpadded ITERs:
for UNPAD in $(seq 1 10) ; do
  PAD=$(printf  "%03g" "$UNPAD")
  echo "A64HOST${UNPAD}=a64-${PAD}"
done
```





FIND:

```
DAYSOLD=90
find .  -size 0c \
        -o \( \
        \( -name \*.fast\[aq\] \
        -o -name \*.f\[aq\]  \
        -o -name \*.txt  \
        -o -name \*.sam  \
        -o -name \*pileup \
        -o -name \*.vcf \) \
        -a -mtime +${DAYSOLD} \)
```

Convert static lib into shared
```
ar -x libsomename.a
gcc -shared -fpic -o libsomename.so *.o
```
