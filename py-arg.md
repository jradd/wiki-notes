# Python Arguments

## Command–Line Arguments
The most simple and effective way to parse arguments is with `sys.argv`

```python
#
# If url specified on command-line, then use it.
#
if len(sys.argv) > 1:
    SOME_URL = str(sys.argv[1])
    print SOME_URL
```


```python
import sys

for arg in sys.argv:
print arg
```


```python
import sys

print "\n".join(sys.argv)

# $1
print sys.argv[1:]

# $2
print sys.argv[2:]

# $3
print sys.argv[3:]
```



### Positional Arguments

Example using local web server.  

```python
import sys, os
from http.server import HTTPServer, CGIHTTPRequestHandler

webdir='.'
port=80

if len(sys.argv) > 1: webdir = sys.argv[1]
if len(sys.argv) > 2: port   = int(sys.argv[2])
    print('webdir "%s", port %s' % (webdir, port))

    os.chdir(webdir)
    srvaddr  = ('', port)
    srvobj   = (HTTPServer(srvaddr, CGIHTTPRequestHandler)
    srvobj.serve_forever()
```



