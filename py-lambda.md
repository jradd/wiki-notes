# lambda
anonymous function (function literal, lambda abstraction) is a function
definition that is not bound to an identifier.

```python
def notLambda(x): return x**2
>>> def notLambda(x): return x**2
...
>>> print(notLambda(7))
49
>>> f = lambda x: x**2
>>>
>>> print(f(7))
49
>>> print(notLambda(7))
49
```

### Usage/Examples of Lambda Functions

```python
def lambda_incrementor(n): return lambda x: x + n

```

```python

```

The expression `x % 3 == 0` computes as:  
"The remainder of x divided by 3 and compare our result with 0"
(meaning; True if x is evenly divisible by 3).


#### Use with `filter()` `map()` and `reduce()` functions:   
```python
>>> def iterQuad():
...     for i in range(5):
...         yield i*i
...
...
>>> for j in iterQuad():
...     print(j)
...
...
0
1
4
9
16
>>> def quadcube(x):
...     return x**2, x**3
...
>>> quadcube(4)
(16, 64)
>>> a, b = quadcube(4)
>>> print(a)
16
>>> print(b)
64
>>> def notLambda(x): return x**2
...
>>> print(notLambda(7))
49
>>> f = lambda x: x**2
>>>
>>> print(f(7))
49
>>> print(notLambda(7))
49
>>> def generateIncrement(n): return lambda x: x + n
...
>>> test1 = generateIncrement(3)
>>> test2 = generateIncrement(5)
>>> print(test1(60),test2(60))
63 65
>>> print(generateIncrement(4)(44))
48
>>> print(generateIncrement(4))
<function generateIncrement.<locals>.<lambda> at 0x7f097c2e9400>
>>> z = generateIncrement(2)
>>> print(z)
<function generateIncrement.<locals>.<lambda> at 0x7f097c2e9400>
>>> z = generateIncrement(2)(4)
>>> print(z)
6
>>> foo = [2,3,5,7,11,13,17,19,23,29]
>>> print(filter(lambda x: x % 3 == 0, foo))
<filter object at 0x7f097c266be0>
>>> print(map(lambda x: x * 2 + 1, foo))
<map object at 0x7f097c266080>
>>> print(repr(map(lambda x: x * 2 +1, foo)))
<map object at 0x7f097c266240>
>>>
>>>
>>>
>>>
>>>
>>> foo = [2, 18, 9, 22, 17, 24, 8, 12, 27]
>>>
>>> f = filter(lambda x: x % 3 == 0, foo)
>>> print(f)
<filter object at 0x7f097c266518>
>>> m = map(lambda x: x * 2 + 10, foo)
>>> print(m)
<map object at 0x7f097c266a20>
>>> from functools import reduce
>>> r = reduce(lambda x, y: x + y, foo)
>>> print(r)
139
```  



True if multiple of `3` -- `filter(lambda x: x % 3 == 0, foo)`   
lambda function for each element in a list and return to a new list.
