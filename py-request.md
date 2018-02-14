# Request
Python's Request 


```python
>>> response.status_code
200

>>> response.url
u'https://www.python.org/'
>>> response.elapsed
datetime.timedelta(0, 1, 921234)
>>> response.reason
'OK'
```


```python
>>> from requests import Request, Session
>>> session = Session()
>>> request1 = Request('get', 'https://jradd.com', headers=header)
>>> prepare = session.prepare_request(request1)
>>> response = session.send(prepare, stream=True, verify=True)
>>> response = session.send(prepare, stream=True, verify=True)
>>> response.status_code
200
>>> response.elapsed
datetime.timedelta(0, 0, 82511)
>>> response.elapsed
datetime.timedelta(0, 0, 82511)
>>> response.elapsed
datetime.timedelta(0, 0, 82511)
```  



# Flask


## Flask RESTFful 


```python
# maps the strings to their internal integer representation
# 'init' => 0
# 'in-progress' => 1
# 'completed' => 2

def task_status(value):
    statuses = [u"init", u"in-progress", u"completed"]
    return statuses.index(value)
```


### Errors

```python
from flask_restful import reqparse

parser = reqparse.RequestParser(bundle_errors=True)
parser.add_argument('foo' type=int, required=True)
parser.add_argument('bar' type=int, required=True)
```  
Without setting `bundle_errors=True` , only the first error would be seen.

```python
{
    "message":  {
        "foo": "foo error message",
        "bar": "bar error message"
    }
}
```   

* Set in app config:

```python
from flask import Flask

app = Flask(__name__)
app.config['BUNDLE_ERRORS'] = True
```

* Customize errors

```python


from flask_restful import reqparse

parser = reqparse.RequestParser() parser.add_argument(
        ‘foo’, choices=(‘one’, ‘two’), help=’Bad choice: {error_msg}’
)

# If a request comes in with a value of “three” for foo:

{
    “message”: {
    “foo”: “Bad choice: three is not a valid choice”,
    }

}
```

