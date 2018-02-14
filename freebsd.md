# FreeBSD







## OpenSSH


```
ChallengeResponseAuthentication no         
X11Forwarding                   no        
UsePAM                          no 
VersionAddendum                 none    # prevents os fingerprinting
```








## Package Management


### Install Python
example of installing common python package under freebsd


```sh
setenv PACKAGEROOT http://ftp.us.freebsd.org
setenv PACKAGESITE http://ftp.us.freebsd.org/pub/FreeBSD/ports/`uname -p`/packages-`uname -r |cut -d
- -f 1,2 |tr "[:upper:]" "[:lower:]"`/Latest/
pkg_add -r python
```


## Filesystem

### Swap  
`/etc/fstab` entry for standard swap partition:  

```sh
# Device                Mountpoint      FStype  Options         Dump    Pass#
/dev/ada0p3             none            swap    sw              0       0
```

`/etc/fstab` entry for automatically–encrypted swap
```sh
# Device                Mountpoint      FStype  Options         Dump    Pass#
/dev/ada0p3.eli         none            swap    sw              0       0
```  
> Simply append the `.eli` extension to the device name and a one-time key
will be generated upon mount and destroyed on subsequent umount of the device.
FreeBSD does this by default in later releases.


Foot
______  

[source]:         https://vez.mrsk.me/freebsd-defaults.txt
