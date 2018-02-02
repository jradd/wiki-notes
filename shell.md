# Shell
Notes on Unix, Linux shell's and POSIX standards.



#### Glob Ignore
For safer globs in the shell.


```bash
GLOBIGNORE=`printf '.[!/.]*:..[!/]*:*/.[!/.]*:*/..[!/]*:*[\001-\037\177]*:-*'`
```



#### Bad Files
Find "bad-filenames" in bash

```bash
badfile=`printf '*[\\x01-\\x1f\\x7f]*'`
  find / -name "$badfile" -exec echo 1 \; | wc -l
```

