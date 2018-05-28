# Filesystem
Notes on Linux, Unix, BSD or Windows File Systems and Storage.

## Linux


### Memory Devices

```
0		Unnamed devices (e.g. non-device mounts)
		  0 = reserved as null device number
		See block major 144, 145, 146 for expansion areas.
|:--------|:-----------------|:-----------------------------------------------|
|  1 char |Memory devices    |Description 									  |
|		 | 1 = /dev/mem		|Physical memory access|
|		 | 2 = /dev/kmem	|Kernel virtual memory access|
|		 | 3 = /dev/null	|Null device|
|		 | 4 = /dev/port	|	|I/O port access|
|        | 5 = /dev/zero	|	Null byte source|
|	     |6 = /dev/core		|OBSOLETE - replaced by /proc/kcore|
|	| 7 = /dev/full		|Returns ENOSPC on write|
|	| 8 = /dev/random	|Nondeterministic random number gen.|
|	| 9 = /dev/urandom	|Faster, less secure random number gen.|
|	|10 = /dev/aio		|Asyncronous I/O notification interface|
|	|11 = /dev/kmsg		|Writes to this come out as printk's|
| |1 block| RAM disk|                                                         |
| |0 = /dev/ram0        |		First RAM disk|
| |1 = /dev/ram1	    |	Second RAM disk|
| | ...|
| |250 = /dev/initrd|	Initial RAM disk {2.6}|

		Older kernels had /dev/ramdisk (1, 1) here.
		/dev/initrd refers to a RAM disk which was preloaded
		by the boot loader; newer kernels use /dev/ram0 for
		the initrd.
...
```  



### Shared Memory



* `/dev/pts       devpts`     PTY slave filesystem
* `/dev/shm       tmpfs`      POSIX shared memory maintenance access




`mount -t tmpfs -o size=10G,nr_inodes=10k,mode=0700 tmpfs /mytmpfs`  

Read more about [tmpfs].

#### Example FSTAB  

`tmpfs     /run/shm  tmpfs     nosuid,nodev,size=40%,mode=1777    0    0`  



[tmpfs]: http://lwn.net/2001/1206/a/tmpfs.php3
