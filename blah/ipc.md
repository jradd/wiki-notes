#Inter Process Communications
on FreeBSD


### Pipes
A pipe is a one-way communication mechansim, with one end opened for reading
and the other end for writing.

Therefor parent and child need to agree on which way to turn the pipe, from
parent to child or the other way around.

We could use the same pipe to communicate both ways, since both parent and
child have access to each side of the descriptor table, but would be
complicated.

If parent and child require two-way communication then the parent creates
two pipes, one for use in each direction.


#### Use of a pipe
A pipe is created by a parent process, which then forks.
When a process forks, the parent's descriptor table is copied into the child's.

1> The parent process makes a call to the system routine `pipe()`.
This routine creates a pipe and places descriptors for the sockets
for the two ends of the pipe in the process's descriptor table.
`Pipe()` is passed an array into which it places the index numbers of the
sockets it created.

The two ends of the array are not equivalent:
The socket whose index is returned in the low word of the array is opened
for reading only, while the socket in the high end is opened only
for writing.

(This corresponds to the fact that the standard input is the first descriptor
of a process's descriptor table and the standard output is the second)

### Streams and Datagrams

Datagrams may be able to perform faster, but there is also the added
overhead and complexity of out of order messages and error handling.

## Protocol
A protocol is a set of rules, data formats and conventions that regulate
the transfer of data between participants in the communication.

In general there is one protocol for each socket type (stream, datagram, etc...)
within each domain.

The code that implements a protocol keeps track of the names that are 
bound to sockets, sets up connections and transfers data between sockets,
or perhaps sending the data across the network.


####MORE
creating and naming sockets:
 socket(2), bind(2)

establishing connections:
listen(2), accept(2), connect(2)

transferring data:
 read(2), write(2), send(2), recv(2)

addresses:
 inet(4F)

protocols:
 tcp(4P), udp(4P).
