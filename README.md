## NAT Hole Punching Example

This code should never be used, ever. But, it's a nice demonstration of how
to punch holes and have two NAT'd peers talk to each other.

### Compile with:
```
$ zig build
```


Server is 1.2.3.4 and is on the public internet accepting UDP:49918.
Client A is NAT'd and doesn't know its IP address.
Client B is NAT'd and doesn't know its IP address.

### Server runs:
```
$ ./server
```

### Client A runs:
```
# ip link add wg0 type wireguard
# ip addr add 10.200.200.1 peer 10.200.200.2 dev wg0
# wg set wg0 private-key ... peer ... allowed-ips 10.200.200.2/32
# ./client 1.2.3.4 wg0
# ping 10.200.200.2
```

### Client B runs:
```
# ip link add wg0 type wireguard
# ip addr add 10.200.200.2 peer 10.200.200.1 dev wg0
# wg set wg0 private-key ... peer ... allowed-ips 10.200.200.1/32
# ./client 1.2.3.4 wg0
# ping 10.200.200.1
```

And voila! Client A and Client B can speak from behind NAT.

### Warnning:
Keep in mind that this is proof-of-concept example code. It is not code that
should be used in production, ever. It is woefully insecure, and is unsuitable
for any real usage. With that said, this is useful as a learning example of
how NAT hole punching might work within a more developed solution.
