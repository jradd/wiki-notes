# Algorithms

## Searching

### Needle in Haystack

#### Parallel Collision

```
Initialize an empty table of M entries.
for i = 1 to M do
    Pick at random a point xi ∈ [N].
    Set tmp ← xi, len ← 0.
    while f(tmp) is not a distinguished point do
        tmp ← f(tmp).
        Increment len.
        end while
        tmp ← f(tmp).
        Increment len.
        Store in the table the pair (tmp, xi, len).
end for

for All collisions ((pi, xi, leni),(pj , xj , lenj )) s.t. pi = pj do
    Set tmp1 ← xi, tmp2 ← xj .
    if len1 > len2 then
        for i = 1 to len1 − len2 do
            tmp1 ← f(tmp1)
        end for
    end if
if len2 > len1 then
    for i = 1 to len2 − len1 do
        tmp2 ← f(tmp2)
    end for
end if

while f(tmp1) 6= f(tmp2) do
    tmp1 ← f(tmp1), tmp2 ← f(tmp2)
end while

print tmp1, tmp2.
end for
```


<<<<<<< HEAD
### Recursive

```
import sys
sys.setrecursionlimit(1000000)  # long type,32bit OS 4B,64bit OS 8B(1bit for sign)

# return (g, x, y) a*x + b*y = gcd(x, y)
def egcd(a, b):
    if a == 0:
        return (b, 0, 1)
    else:
        g, x, y = egcd(b % a, a)
        return (g, y - (b // a) * x, x)
```


```
>>> def extended_gcd(aa, bb):
    lastremainder, remainder = abs(aa), abs(bb)
    x, lastx, y, lasty = 0, 1, 1, 0
    while remainder:
        lastremainder, (quotient, remainder) = remainder, divmod(lastremainder, remainder)
        x, lastx = lastx - quotient*x, x
        y, lasty = lasty - quotient*y, y
    return lastremainder, lastx * (-1 if aa < 0 else 1), lasty * (-1 if bb < 0 else 1)
 
>>> def modinv(a, m):
    g, x, y = extended_gcd(a, m)
    if g != 1:
        raise ValueError
    return x % m
 
>>> modinv(42, 2017)
1969
```
=======

>>>>>>> 388a339cfb5210b730624e5026b944b25ffac68a
