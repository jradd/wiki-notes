# Python List Comprehensions

List comprehensions in Python can be very useful to express
mathematical expressions.


#### Math  
Few math expressions for example:

```
S = {x2 : x in {0 ... 9}}
V = (1, 2, 4, 8, ..., 2¹²)
M = {x | x in S and x even}
```  

#### Python Math

```python
>>> S = [x**2 for x in range(10)]
>>> V = [2**i for i in range(13)]
>>> M = [x for x in S if x % 2 == 0]
>>> for i in [S, V, M]:
...     print(i)
...
...
[0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
[1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096]
[0, 4, 16, 36, 64]
```  

#### Python Primes
An interesting approach to listing primes using Python List Comprehensions:  
```python
>>> composites = [j for i in range(2, 8) for j in range(i*2, 90, i)]
>>> primes     = [x for x in range(2, 90) if x not in composites]
>>> print(primes)
[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89]
```  


#### Python Types
List comprehension of all the types  

```python
>>> words    = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'.split()
>>> transf   = [[w.lower(), len(w)] for w in words]
>>> for i in transf:
...     print(i)
...
...
['lorem', 5]
['ipsum', 5]
['dolor', 5]
['sit', 3]
['amet,', 5]
['consectetur', 11]
['adipiscing', 10]
['elit.', 5]
>>>
>>>
>>> stuff = map(lambda w: [w.upper(), len(w)], words)
>>> for i in stuff:
...     print(i)
['LOREM', 5]
['IPSUM', 5]
['DOLOR', 5]
['SIT', 3]
['AMET,', 5]
['CONSECTETUR', 11]
['ADIPISCING', 10]
['ELIT.', 5]
```  
The above example uses list comprehension to show that you can do the
same thing with `map()` and a [[lambda]] function. 




