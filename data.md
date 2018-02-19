# datasets and algorithms

### Recursion
Recursion is a function that calls on itself.

```python
def S(seq, i=0):
  if i == len(seq): return 0
  return S(seq, i+1) + seq[i]
```

```python
def T(seq, i=0):
  if i == len(seq): return 1
  return T(seq, i+1) + 1
```

| # |  Recurrence      | Solution  | Examples              |
|:--|:-----------------|:----------|:----------------------|
|1  |T(n) = T(n-1) + 1 | O(n)      | Processing sequence   |
|2  |T(n) = T(n-1) + n | O(n²)     | Handshake problem     |
|3  |T(n) = 2T(n-1) + 1| O(2n)     | Towers of Hanoi       |
|4  |T(n) = 2T(n-1) + n| O(2n)     |                       |
|5  |T(n) = T(n/2) + 1 | O(log n)  | Binary search         |
|6  |T(n) = T(n/2) + n | O(n)      | Randomized select, avg|
|7  |T(n) = 2T(n/2) + 1| O(n)      | Tree traversal        |
|8  |T(n) = 2T(n/2) + n| O(n log n)|Sort by divide&conquer |
|   |                  |           |                       |


##### Gnome Sort:
```python
def gnomesort(seq):
  i = 0
  while i < len(seq):
      if i == 0 or seq[i-1] <= seq[i]:    # find values in wrong order
          i += 1
      else:
          seq[i], seq[i-1] = seq[i-1], seq[i]
          i -= 1
```
##### Merge Sort:
```python
def mergesort(seq):
  mid = len(seq)//2
  lft, rgt = seq[:mid], seq[mid:]
  if len(lft) > 1: lft = mergesort(lft)
  if len(rgt) > 1: rgt = mergesort(rgt)
  res = []
  while lft and rgt:
      if lft[-1] >=rgt[-1]:
          res.append(lft.pop())
      else:
          res.append(rgt.pop())
  res.reverse()
  return (lft or rgt) + res
```





### Reduction, Induction:

- Reduction:
Transforming one problem to another.

- Induction:
Used to show that a statement is true by first showing it to be true for a base
case and showing that it carries over from one object to the next;
if it's true for `n-1`, then it's true for `n`.

### Reduction, Induction:

- Reduction:
Transforming one problem to another.

e.g. "Find the two closest numbers in a sequence"

```python
>> from random import randrange
>>> seq = [randrange(10**10) for i in range(100)]
>>> dd = float("inf")
>>> for x in seq:
...     for y in seq:
...         if x == y: continue
...         d = abs(x-y)
...         if d < dd:
...             xx, yy, dd = x, y, d
...
>>> xx, yy
(6606510544, 6606706051)
```


The nested for loops  results in running time that is loglinear --> O(n log n)
To improve this:

```python
>>> xx, yy
(6606510544, 6606706051)
>>> seq.sort()
>>> dd = float("inf")
>>> for i in range(len(seq)-1):
...     x, y = seq[i], seq[i+1]
...     if x == y: continue
...     d = abs(x-y)
...     if d < dd:
...         xx, yy, dd = x, y, d
...
>>> xx, yy
(6606510544, 6606706051)
```

- Induction:
Used to show that a statement is true by first showing it to be true for a base
case and showing that it carries over from one object to the next;
if it's true for `n-1`, then it's true for `n`.

<no example>


Recursive Insertion Sort  
------------------------
```python
def ins_sort_recurs(seq, i):
    if i==0: return                             # base case -- do nothing
    ins_sort_recurs(seq, i-1)                   # Sort 0..i-1
    j = i                                       # Start "walking" down
    while j > 0 and seq[j-1] > seq[j]:          # Look for OK spot
        seq[j-1], seq[j] = seq[j], seq[j-1]     # Keep moving seq[j] down
        j -= 1                                  # Decrement j
```

Insertion Sort
------------------------
```python
def ins_sort(seq):
  for i in range(1,len(seq)):
    j = i
    while j > 0 and seq[j-1] > seq[j]:
      seq[j-1], seq[j] = seq[j], seq[j-1]
      j -= 1
```


Recursive Selection Sort
------------------------
```python

```

Selection Sort
------------------------
```python

```




