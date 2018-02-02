# Javascript
Notes on some basic javascript, and differences with python

js objects --> python dicts
js arrays --> python lists


```python
# Python
d = {'name': 'Groucho', 'occupation': 'Ruler of Freedonia'}
l = ['Harpo', 'Groucho', 99]
t = ('an', 'immutable', 'container')
```  

```javascript
// JavaScript
d = {'name': 'Groucho', 'occupation': 'Ruler of Freedonia'}
l = ['Harpo', 'Groucho', 99]
```  

| JavaScript array (a)             |  Python list (l)          |
|  :-----------                    |  :-----------             |
|   `a.length`                     |  `len(l)`                 |
|   `a.push(item)`                 |  `l.append(item)`         |
|   `a.pop()`                      |  `l.pop()`                |
|   `a.shift()`                    |  `l.pop(0)`               |
|   `a.unshift(item)`              |  `l.insert(0, item)`      |
|   `a.slice(start, end)`          | `l[start:end]`            |
|`a.splice(start,howMany, i1, ...)`|`l[start:end] = [i1, ...]` |  




## Iterating
for loops or functional alternatives

### Python  

```python
foo = {'a':3, 'b':2}
for x in foo:
    print(x)
#==> 'a' 'b'
```  

- iterate over key value pairs using the dict's `items` method:

```python
for x in foo.items():
    print(x)
#==> ('a', 3) ('b', 2)
```  


### JS  
> ucky...

```javascript
for(var i in ['a', 'b', 'c']){
    console.log(i)
}
// ==> 1, 2, 3
```  

```javascript
var obj = {a3, b:2, c:4};
for (var prop in obj) {
    if( obj.hasOwnProperty( prop ) ) {
        console.log("o." + prop + " = " + obj[prop]);
    }
}
// ==> o.a = 3, ob.b = 2, o.c = 4
```  



## File I/O  


### Python  

```python
# READING A FILE
f = open("data.txt") # open file for reading
for line in f: # iterate over file-lines
    print(line)

lines = f.readlines() # grab all lines in file into array
data = f.read() # read all of file as single string

# WRITING TO A FILE
f = open("data.txt", 'w') # use 'w' to write, 'a' to append to file
f.write("this will be written as a line to the file")
f.close() # explicitly close the file
```

```python
with open("data.txt") as f:
    lines = f.readlines()
    ...
```  




## Classes  

### Python

```python
class Winner(Citizen):

def __init__(self, name, country, category, year):
    super(Winner, self).__init__(name, country)
    self.category = year
    self.year = year

def print_details(self):
    print('Nobel winner %s from %s, category %s, year %s' \
%(self.name, self.country, self.category, str(self.year)))

w = Winner('Albert E.', 'Switzerland', 'Physics', 1921)
w.print_details()
#==> 
# Nobel prize-winner  Albert E. from Switzerland, category Physics, year 1921
```  



### JS  

```javascript
var Citizen = function(name, country){
    this.name = name;
    this.country = country;
};
Citizen.prototype = {
printDetails: function(){
                  console.log('Citizen ' + this.name + ' from ' + this.country);
              }
};
var c = new Citizen('Groucho M.', 'Freedonia');
c.printDetails();
Out:
Citizen Groucho M. from Freedonia
typeof(c) # object
```  



#### Object Inheritence

```javascript
var Citizen = {
setCitizen: function(name, country){
                this.name = name;
                this.country = country;
                return this;
            },
printDetails: function(){
                  console.log('Citizen ' + this.name + ' from ', + this.country);
              }
};
var Winner = Object.create(Citizen);
Winner.setWinner = function(name, country, category, year){
    this.setCitizen(name, country);
    this.category = category;
    this.year = year;
    return this;
};
Winner.printDetails = function(){
    console.log('Nobel winner ' + this.name + ' from ' +
            this.country + ', category ' + this.category + ', year ' +
            this.year);
};
var albert = Object.create(Winner)
    .setWinner('Albert Einstein', 'Switzerland', 'Physics', 1921);
    albert.printDetails();
Out:
Nobel winner Albert Einstein from Switzerland, category
Physics, year 1921
```




## Enumerating Lists  



### Python  

```python
names = ['Jason', 'Steve', 'Susan']

for i, n in enumerate(names):
    print('%d: %s'%(i, n))
```  


### JS  

```javascript
var names = ['Jason', 'Steve', 'Susan']

names.forEach(function(n, i){
    console.log(i + ': ' + n);
});
```




- Tuple Unpacking in Python

```python
def fibonacci(n):
    x, y = 0, 1
for i in range(n):
    print(x)
x, y = y, x + y
```

```python
winner = 'Albert Einstein', 'Physics', 1921, 'Swiss'

name, _, _, nationality = winner
```
> you can ignore unpacked variables with `_`  




## Map, reduce, filter with lambdas

```python
from functools import reduce # python 3+

nums = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

odds    = filter(lambda x: x % 2, nums)
odds_sq = map(lambda x: x * x, odds)
reduce(lambda x, y: x + y, odds_sq)

#==> 165
```


### JS  

```javascript
function Counter(inc) {
    var count = 0
    var add = function() {
        count += inc;
        console.log('Current count: ' + count);
}

var inc2 = Counter(2);
inc2();
```


```javascript
function Counter(inc) {
    var count = 0;
    var api = {};
    api.add = function() {
        count += inc;
        console.log('Current count: ' + count);
    }
    api.sub = function() {
        count -= inc;
        console.log('Current count: ' + count)
    }
    api.reset = function() {
        count = 0;
        console.log('Count reset to 0')
    }
    return api;
}
cntr = Counter(3);
    cntr.add() // Current count: 3
    cntr.add() // Current count: 6
    cntr.sub() // Current count: 3
cntr.reset() // Count reset to 0
```  


### Python

```python
def get_counter(inc):
    count = 0

    def add():
        count += inc
        print('Current count: ' + str(count))
    return add

cntr = get_counter(2)
cntr()
#==>
...
UnboundLocalError: local variable 'count' referenced before assignment
```  

```python3
...
def add():
    nonlocal count
    count += inc
...
```  


or in python2, using a hack to allow mutation of our closed variables:

```python
def get_counter(inc):
    vars = {'count': 0}
    def add():
        vars['count'] += inc
        print('Current count: ' + str(vars['count']))
    return add
```  





