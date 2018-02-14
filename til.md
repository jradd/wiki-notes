# today i learned

need to fix ssl :(


# L0


`apt-get install libpq-dev`
to install client-side libraries for postgresql so that you can `pip install psycopg2` without
having postgresql installed on your devel machine.



## FreeBSD
Tidbits on BSD


### ACL's

```sh
root@vxbsdev:/ # dumpfs /tmp |head -1
magic   19540119 (UFS2) time    Wed Jan 25 04:46:46 2017
```  

```sh
root@vxbsdev:/ # tunefs -p /dev/md0
tunefs: POSIX.1e ACLs: (-a)                                disabled
tunefs: NFSv4 ACLs: (-N)                                   disabled
tunefs: MAC multilabel: (-l)                               disabled
tunefs: soft updates: (-n)                                 disabled
tunefs: soft update journaling: (-j)                       disabled
tunefs: gjournal: (-J)                                     disabled
tunefs: trim: (-t)                                         disabled
tunefs: maximum blocks per file in a cylinder group: (-e)  4096
tunefs: average file size: (-f)                            16384
tunefs: average number of files in a directory: (-s)       64
tunefs: minimum percentage of free space: (-m)             8%
tunefs: space to hold for metadata blocks: (-k)            80
tunefs: optimization preference: (-o)                      time
tunefs: volume label: (-L)                                 
```  

```sh
root@vxbsdev:/srv/share/test_dir # umask
27
root@vxbsdev:/srv/share/test_dir # getfacl file.txt 
# file: file.txt
# owner: root
# group: radd
            owner@:rw-p--aARWcCos:-------:allow
            group@:r-----a-R-c--s:-------:allow
         everyone@:------a-R-c--s:-------:allow
```


```sh
root@vxbsdev:/srv/share/test_dir # setfacl -m u::rw,g::r,u:radd:rw,m::r file.txt 
setfacl: file.txt: branding mismatch; existing ACL is NFSv4, entry to be merged is POSIX.1e
root@vxbsdev:/srv/share/test_dir # getfacl file.txt 
# file: file.txt
# owner: root
# group: radd
            owner@:rw-p--aARWcCos:-------:allow
            group@:r-----a-R-c--s:-------:allow
         everyone@:------a-R-c--s:-------:allow
```

#### Removing ACL
```sh
root@vxbsdev:/srv/share/test_dir # setfacl -bn file.txt 
root@vxbsdev:/srv/share/test_dir # getfacl file.txt 
# file: file.txt
# owner: root
# group: radd
            owner@:rw-p--aARWcCos:-------:allow
            group@:r-----a-R-c--s:-------:allow
         everyone@:------a-R-c--s:-------:allow
```


#### Default ACL's
DACL entries provide a way to propogate ACL information automatically to files and directories
as they inherit ACL info's from parent directory IF THAT PARENT HAS AN
ACL THAT CONTAINS DEFAULT ENTRIES (only on dirs).


* before you set any dacl entries for users or groups you must set default acl entries 
for GROUP, OTHER as well as ACL mask.



* to delete default acls from dir use: `setacl -k <dir>` now check with `getfacl -d <dir>`

```sh
To delete a default ACL entry for user bin do:
   % mkdir dir
   % setfacl -dm u::rwx,m::rwx,g::rx,o::rx dir
   % setfacl -dm u:gregory:rwx,u:bin:rwx,m::rwx dir
   % getfacl -d dir
   #file:dir
   #owner:1009
   #group:0
   user::rwx
   user:bin:rwx
   user:gregory:rwx
   group::r-x
   mask::rwx
   other::r-x
Create acls.txt file which looks like:
   % cat acls.txt
   u:bin:rwx
   % setfacl -dX acls.txt dir
   alphax% getfacl -d dir
   #file:dir
   #owner:1009
   #group:0
   user::rwx
   user:gregory:rwx
   group::r-x
   mask::rwx
   other::r-x
```

or simply type:
    `% setfacl -d -x u:bin:rwx dir`  
Things to remember
setfacl(1) always recalculates the ACL mask to allow maximum effective permissions for every ACL entry, unless the “-n” switch is used.
If you use the chmod(1) command to change the file group owner permissions on a file with ACL entries, both the file group owner permissions and the ACL mask are changed to the new permissions. Be aware that the new ACL mask permissions may change the effective permissions for additional users and groups who have ACL entries on the file.
