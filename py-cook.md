# Python
Snippets of python/python3




# Datatypes

## Lists
```python
initialize a result variable to be an empty list
loop
  create a new element
  append it to result
return the result
```



```python
def primes_lessthan(n):
    """ return a list of all prime numbers less than n. """
    result = []
    for i in range(2, n):
        if is_prime(i):
            result.append(i)
    return result
```


## Args
Takes arguments and prints them:
```python
def getopts(argv):
  opts = {}
  while argv:
    if argv[0][0] == '-':
      opts[argv[0]] argv[1]
      argv = argv[2:]
    else:
      argv = argv[1:]
  return opts

if __name__ == '__main__':
  from sys import argv
  myargs = getopts(argv)
  if '-i' in myargs:
    print(myargs['-i'])
  print(myargs)
```

```python
def interact():
  print('Hello stream world!')
  while True:
    try:
      reply = input('Enter a number> ')
    except EOFError:
      break
    else:
      num = int(reply)
      print("%d squared is %d" % (num, num ** 2))
    print('Bye')

if __name__ == '__main__':
  interact()
```

## Streams
Reading/writing files and file-like objects

```python
import sys

class Output:
  def __init__(self):
    self.text = ''
  def write(self, string):
    self.text += string
  def writelines(self, lines):
    for line in lines: self.write(line)

class Input:
  def __init__(self, input=''):
    self.text = input
  def read(self, size=None):
    if size == None:
      res, self.text = self.text, ''
    else:
      res, self.text = self.text[:size], self.text[size:]
    return res
  def readline(self):
    eoln = self.text.find('\n')
    if eoln == -1:
      res, self.text = self.text, ''
    else:
      res, self.text = self.text[:eon+1], self.text[eoln+1:]
    return res

def redirect(function, pargs, kargs, input):
  savestreams = sys.stdin, sys.stdout
  sys.stdin   = Input(input)
  sys.stdout  = Output()
  try:
    result = function(*pargs, **kargs)
    output = sys.stdout.text
  finally:
    sys.stdin, sys.stdout = savestreams
  return (result, output)
```



```python    
def example(a=1, b=1, *c, d, e=2, **f) -> str:
  pass

def get_arguments(func, args, kwargs):
  arguments = {}
  spec = inspect.getfullargumentspec(func)

  if spec.defaults:
    arguments.update(zip(reversed(spec.arguments), reversed(spec.defaults)))

  return arguments

print(get_arguments(example, (1,), {'f' : 4}))
```

```python
#!/usr/bin/env python
def wrapper(*args, **kwargs):
  """ Populate a dictionary of explicit arguments passed positionally"""
  new_args = []
  new_kwargs = {}
  keyword_args = kwargs.copy()

  for name, arg in zip(spec.args, args):
    if name in annotations:
      new_args.append(process(arg, annotations[name]))

      for name in chain(spec.args, spec.kwonlyargs):
        if name in kwargs and name in annotations:
          new_kwargs[name] = process(keyword_args.pop(name), annotations[name])

          if spec.varargs and spec.varargs in annotations:
            annotation = annotations[spec.varargs]

            for arg in args[len(spec.args):]:
              new_args.append(process(arg, annotation))

              if spec.varkw and spec.varkw in annotations:
                annotation = annotations[spec.varkw]
                for name, arg in keyword_args.items():
                  new_kwargs[name] = process(arg, annotation)

                  r = func(*new_args, **new_kwargs)
                  if 'return' in annotations:
                    r = process(r, annotations['return'])
                    return r
```  

### Files
Listing directory  

```python
import os

for dirname, dirnames, filenames in os.walk('.'):
  # print path to all filenames
  for filename in filenames:
   os.path.basename(filename)

  # editing the 'dirnames' list will break os.walk()
  if '.git' in dirnames:
    # don't go in
    dirnames.remove('.git')
```

```python
#!/usr/bin/env python
import os.path
import re

notespath = "/srv/share/notes"
# get names of filesnames
names = [name for name in os.listdir(notespath)
    if os.path.isfile(os.path.basename(notespath))]

notes = [name for name in os.listdir(notespath)
    if name.endswith('md')]

notestring = [elem.rstrip('.md') for elem in notes]

print (notestring)%.
```


```python
import re
# import regex # if you like good times
# intended to replace `re`, the regex module has many advanced
# features for regex lovers. http://pypi.python.org/pypi/regex
subject = 'Jane"" ""Tarzan12"" Tarzan11@Tarzan22 {4 Tarzan34}'
regex = re.compile(r'{[^}]+}|"Tarzan\d+"|(Tarzan\d+)')
# put Group 1 captures in a list
matches = [group for group in re.findall(regex, subject) if group]

######## The six main tasks we're likely to have ########

# Task 1: Is there a match?
print("*** Is there a Match? ***")
if len(matches)>0:
  print ("Yes")
else:
  print ("No")

# Task 2: How many matches are there?
print("\n" + "*** Number of Matches ***")
print(len(matches))

# Task 3: What is the first match?
print("\n" + "*** First Match ***")
if len(matches)>0:
  print (matches[0])
  
# Task 4: What are all the matches?
print("\n" + "*** Matches ***")
if len(matches)>0:
  for match in matches:
      print (match)
    
# Task 5: Replace the matches
def myreplacement(m):
    if m.group(1):
        return "Superman"
    else:
        return m.group(0)
replaced = regex.sub(myreplacement, subject)
print("\n" + "*** Replacements ***")
print(replaced)

# Task 6: Split
# Start by replacing by something distinctive,
# as in Step 5. Then split.
splits = replaced.split('Superman')
print("\n" + "*** Splits ***")
for split in splits:
      print (split)
```
#### Index


```python
>>> def nth(textStr, subStr):
...     start = 0
...     stop = 0
...     while start < len(textStr):
...         if textStr[start+stop] != subStr[stop]:
...             start += 1
...             stop = 0
...             continue
...         stop += 1
...         if stop == len(subStr):
...             return start
...         return -1
```   

#### Iter Items  

```python
def last_iter(it):
    # Ensure it's an iterator and get the first field
    it = iter(it)
    prev = next(it)
    for item in it:
        # Lag by one item so I know I'm not at the end
        yield 0, prev
        prev = item
    # Last item
    yield 1, prev

def test(data):
    result = list(last_iter(data))
    if not result:
        return
    if len(result) > 1:
        assert set(x[0] for x in result[:-1]) == set([0]), result
    assert result[-1][0] == 1

test([])
test([1])
test([1, 2])
test(range(5))
test(xrange(4))

for is_last, item in last_iter("Hi!"):
    print is_last, item
```


#### Primes

```python
>>> def prime(a):
...     return not (a < 2 or any(a % x == 0 for x in xrange(2, int(a**0.5) + 1)))

>>> def primes_below(n):
...     return [i for i in range(n) if prime(i)]
```
