# sed examples

See all examples at: \[\[sed1liners\|[http://www.pement.org/sed/sed1line.txt](http://www.pement.org/sed/sed1line.txt)\]\] or \[\[sed1liners\]\]

```bash:test.sh\`\`\`
## Replace Lines in–place
sed is typically used for stream editing, but you can also use to
append or replace lines in a file in–place with `-i`.


```bash
$ ls
foo.txt
$
$ cat foo.txt
#!/bin/sh echo 'shebang'
# This is a comment 
flag=1
flag=2
flag=3
$ sed -i "\$a APPEND_LASTLINE" foo.txt  
$
$ cat foo.txt
#!/bin/sh echo 'shebang'
# This is a comment 
flag=1
flag=2
flag=3
APPEND_LASTLINE
$
$ sed -i "s/$a*//" foo.txt
$
$ cat foo.txt
#!/bin/sh echo 'shebang'
# This is a comment 
flag=1
flag=2
flag=3
APPEND_LASTLINE
$
$ sed -i "s/APPEND_LASTLINE//" foo.txt
$
$ cat foo.txt
#!/bin/sh echo 'shebang'
# This is a comment 
flag=1
flag=2
flag=3
```

#### Replace line matching PATTERN

```zsh
$ sed -i 's/flag=2/REPLACED/' test/foo.txt
$ cat $_
# This is a comment 
flag=1
REPLACED
flag=3
$
```

#### Delete last line

```sh
$
$ sed -i "$d" foo.txt
$ cat foo.txt
#!/bin/sh echo 'shebang'
# This is a comment 
flag=1
flag=2
flag=3

$
$ sed -i '$d' foo.txt           
$
$ cat foo.txt
#!/bin/sh echo 'shebang'
# This is a comment 
flag=1
flag=2
flag=3

$
$ sed -i '$d' foo.txt
$
$ cat foo.txt
#!/bin/sh echo 'shebang'
# This is a comment 
flag=1
flag=2
flag=3
```



