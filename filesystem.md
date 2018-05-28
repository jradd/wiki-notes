# Filesystem
Notes on Linux, Unix, BSD or Windows File Systems and Storage.

## Linux

### Shared Memory

`mount -t tmpfs -o size=10G,nr_inodes=10k,mode=0700 tmpfs /mytmpfs`  

Read more about [tmpfs](1).


[1]: "http://lwn.net/2001/1206/a/tmpfs.php3 tmpfs reference"
