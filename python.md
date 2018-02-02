# Python
Notes

## Generators
Example of a Python "generator" function, which can be used
as an iterable object which creates objects on the fly: 

```python
>>> def iterquad():
...     for i in range(9):
...         yield i*i
...
>>> for j in iterquad():
...     print(j)
0
1
4
9
16
25
36
49
64
```  
```python
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
```

### Positional Arguments  

```python
def my_generator():
  for i in range(10):
    yield i

def my_func(*args):
  print(args)

pos = my_generator()
my_fun(*pos)
```

```python
def remainder(number, divisor):
  return number % divisor

assert remainder(20, 7) == 6
```

```python
remainder(20, 7)
remainder(20, divisor=7)
remainder(divisor=7, number=20)
```

Logging  
----------------
```python
def log(message, when=None):
  when = datetime.now() if when is None else when
  print('%s: %s' % (when, message))
```

```python
log('Hello, World!')
```

Operators  
----------------
* Arithmetic:
    +, -, *, **, /, //, %
* Bit-wise:
    <<, >>, &, |, ^, ~
* Comparison:
    <, >, <=, >=,==, !=

Slices  
----------------
[START:STOP:STEP]

"word"[::-1] == 'drow'  

```python
>>> some_list = ["a", "d", "f"]
>>> some_list[1:] = ["b", "c"]
>>> some_list
['a', 'b', 'c', 'd', 'f']
>>> some_List[4:4] = ["e"]
>>> some_list
['a', 'b', 'c', 'd', 'e', 'f']
```  

## Strings
Parsing strings into substrings:

`'01.03.05.15'.split('.')` to create the sequence:
`['01', '03', '05', '15']`  


- `join()` is the inverse of `split()`  

***Not to be used with filenames/paths, use `os.path` instead***


### Namespace

```python
def f():
    n = 7
    print("printing n inside of f:", n)

def g():
    n = 42
    print("printing n inside of g:", n)

n = 11
print("printing n before calling f:", n)
f()
print("printing n after calling f:", n)
g()
print("printing n after calling g:", n)
```

### Dict
dict from iterable object

```python
>>> idx = {k: v for (k, v) in enumerate(chars)}`
```




