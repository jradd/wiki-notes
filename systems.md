# Systems Engineering
Helpful bits of information regarding systems engineering.
Typically Unix, Linux, BSD or POSIX related material.


## Filesystem

`rm` --> `unlink` --> `unlinkat` (`unlink(const char *pathname)`)

`unlink()` deletes a name from the filesystem. If that name was the last link to a file
and no processes have the file open, the file is deleted and the space it was using is made
available for reuse.

If the name was the last link to a file but any processes still have the file open, the file will
remain in existence until the last file descriptor referring to it is closed.

If the name referred to a symbolic link, the link is removed.

If the name referred to a socket, FIFO, or device; the name for it is removed but processes which
have the object open may continue to use it.

If the pathname given in `pathname` is relative, then it is interpreted relative
to the directory referred to by the file descriptor `dirfd` (rather than
relative to the cwd of the calling process, as is done by `unlink()` and `rmdir(2)`
for a relative pathname.


If the pathname given in `pathname` is absolute, then `dirfd` is ignored.

### AT_REMOVEDIR
By default, `unlinkat()` performs the equivalent of `unlink()` on `pathname`. If 
the `AT_REMOVEDIR` flag is specified, then performs the equivalent of `rmddir(2)` on
`pathname`.

### ERRORS

|:------------|:--------------------------------------------------------------|
| ERRNO       | DESC                                                          |
| EACCESS     | Write access to the directory containing `pathname` is not allowed for the process's
effective UID, or on e of the directories in `pathname` did not allow search permission






temp_notes:

`man 7 path_resolution`
filename or pathname resolved as follows:

1. start
If `pathname` starts with the '/' character, teh starting lookup directory is
the root of the calling process.

( a process inherits its root directory from its parent )

- usually this will be the root of the directory or file hierarchy.  
- a process may get a different root directory by use of the `chroot(2)` syscall.  
- a process may get an entirely private mountspace in case it—or one of its
ancestors—was started by an invocation of the `clone(2)` syscall that had the
`CLONE_NEWNS` flag set. This handles the '/' part of the pathname.  



2. path walk
Set the current lookup directory to the starting lookup directory.
Now for each non—final component of the pathname, where component is
a substring delimited by '/' characters, this component is looked up in the
current lookup directory.

If the process does not have **search permission** on the current *lookup directory*
an `EACCESS` error is returned ("Permission Denied").

If the component is not found: `ENOENT` (no entry found " no such file or...")

If the component is found, but is neither a directory nor a symbolic link, an
`ENOTDIR` error is returned. ("not a directory")

If the component is found and is a directory, we set the current *lookup directory*
to **that directory**, and go to the next component.

If the component is found and is a symbolic link (symlink), we first resolve
this symlink (with current **lookup directory** as the **starting lookup directory**.

If the resolution of the symlink is successfull and returns a directory, we set
the current *lookup directory* to that directory , and go to the next component.

Note that the resolution process here involves recursion.
In order to protect the kernel against stack overflow, and also to protect against 
denial of service, there are limits on the maximum recursion depth, and on the
 maximum number of symlinks followed.
An `ELOOP` error is returned when the maximum is exceeded ("Too many levels of 
symbolic links").



3. find final entry
same as the other components of our lookup

##### Trailing Slashes
If  a pathname ends in a '/', that forces resolution of the preceding component
as in Step #2: it has to exist and resolve to a directory. Otherwise, a 
trailing '/' is ignored. (or, equivalently, a pathname with a trailing '/' is
equivalent to the pathname obtained by appending '.' to it.)

###### Final Symlink
If last component of pathnamem is a symlink, then it depends on the system
call whether the file referred to will be the symbolic link or the result of
path resolutionon its contents. 

> e.g.
the system call `lstat(2)` will operate
on the symlink, while `stat(2)` operates on the file pointed to by the symlink.

##### Length Limit
There is a max length for pathnames. If the pathname (or some intermediate 
pathname obtained while resolving symbolic links) is too long, an `ENAMETOOLONG`
error is returned ("Filename too long").

##### Empty Pathname
In the original UNIX, the empty pathname referred to the current directory.
Nowadays POSIX decrees that an empty pathname must not be resolved successfully.
Linux returns `ENOENT` in this case.

##### Permissions
The permission bits of a file consist of three groups of three bits,
`chmod(1)` and `stat(2)`. 

The first group of three is used when the *effective* user ID of the calling
process equals the owner ID of the file.

The second group of three is used when the groupo ID of the file either equals 
the *effective* group ID of the calling process, or is 
one of the supplementary group ID's of the calling process (as set by `setgroups(2)`)

When neither holds, the third group is used.

Mode Bits:
- the first bit determines **read** permission
- the second bit determines **write** permission
- the last bit determines **execute** permission in case of **ordinary files**,
or **search** permission in case of **directories**.

**Linux uses the fsuid instead of the effective user ID in permission checks.**
(ordinarily the fsuid will equal the effective user ID, but the fsuid can be 
changed by the system call `setfsuid(2)`).

Here "fsuid" stands for something like "filesystem user ID". The concept was
required for the implementation of a user space NFS server at a time when
processes could send a signal to a process with the same effective user ID. It 
is OBSOLETE now, no one should use `setfsuid(2)`.


#### Bypassing Permission Checks: superuser and capabilities
On a traditional UNIX system, the superuser (root, UID 0) is all—powerful, and
bypasses all permissions restrictions when accessing files.

On Linux, superuser privileges are divided into capabilities (see `capabilities(7)`).

Two capabilities are relevant for file permissions checks: 
`CAP_DAC_OVERRIDE`
`CAP_DAC_READ_SEARCH` (a process has these caps if its fsuid is 0)

- `CAP_DAC_OVERRIDE`
overrides all permission checking, but grants execute permission only when at
least one of the file's three execute permission bits is set.

- `CAP_DAC_READ_SEARCH`
grants **read** and **search** permission on **directories**, and **read**
permission on ordinary **files**.



