


### Models
Model methods provide *row level functionality*
manager methods are *table wide*

`__str__`
`__unicode__`
`get_absolute_url`
`save`
`delete`

`save()`
`full_clean()` ???

`proxy = True`
vs
`abstract = True`



Use *Intermdiate Models* To collect meta-data on Many-to-Many relations  



#### Model Methods  
```python  
def get_absolute_url(self):
  return reverse('author-detail', kwargs={'pk': self.pk})
```  

>> A custom manager method can return anything. Not just a queryset.

```python
from django.db import models
models.Manager()
``` 

Overriding a Manager's base QuerySet, Manager.get_queryset method,
should return a QuerySet:  
```python
class AuthorManager(models.Manager):
  def get_queryset(self):
return super(AuthorManager, self).get_queryset().filter(role='A')
```  

Because `get_queryset()` returns a QuerySet object, you can use `filter()`,
`exclude()` and all the other QuerySet methods within.

Using multiple managers on the same model you can attach
as many Manager() instances to a model as you'd like.

##### Creating Custom Manager Methods  
```pythonn
class Person(models.Model):
## do something 
people = PersonQuerySet.as_manager()
```

- Methods are copied according toe the following rules:  
    1. Public methods are copied by default.
    2. Private methods (prefixed with _ underscore) - *not* copied by default
    3. Methods with a `queryset_only` attribute set to `False` are *always* copied.
    4. Methods with a `queryset_only` attribute set to True are *never* copied.

```python
class CustomQuerySet(models.QuerySet):
  def _private_method(self):
  return
...
opted_out_public_method.queryset_only = True
...
```  

### Files  
Working with files and Django's models.


```python
from django.db import models
from django.core.files.storage import FileSystemStorage
  
fs = FileSystemStorage(location='media/photos')

class Car(models.Model):
  ...
  photo = models.ImageField(storage=fs)
  ...
```


#### ContentType:
Each instance of `ContentType` has three fields which together describe a model

* app_label ---> Only the last part of the applications Python import path
* model ---> Name of the model class
* name ---> The verbose_name of the model class (usually mean plural)

Each instance of `ContentType` has a method that allows you to get from a 
`ContentType` instance to the model it represents or retrieve objects from that model.


`ContentType.get_object_for_this_type(**kwargs)` 

Takes a list of valid lookup arguments for which the model `ContentType`
represents, and performs a `get()` lookup on that model and returns the 
corresponding object.  

`ContentType.model_class()`  
Returns the model the class represented by this ContentType instance  

##### e.g.  
Lookup the `ContentType` for the `User` model
```python
from django.contrib contenttypes.models import ContentType
  user_type = ContentType.objects.get(app_label="auth", model="User")
>>>  user_type
<ContentType.model_class()>
``` 

Return the model class represented by this `ContentType` instance.  
`user_type.get_object_for_this_type(username='Guido')

###### Use cases:  
* Write a high-level generic code that performs queries on any installed model
* Relate another model to `ContentType` as a way of relating instances to the model classes.

`ContentType` has a custom manager: 
`class ContentTypeManager`

###### Lookup ContentType by ID:
`clear_cache()`
`get_for_id(id)`

Uses same shared cache as `get_for_model()` so it is more preferrable to use.


`get_for_model(model[, for_concrete_model=True])` 

Takes either a model class or an instance of a model and returns the ContentType instance
representing that model.

`get_for_models(\*models[, for_concrete_models=True])` 

Takes a variadic count of model classes, and returns a dict.
mapping the model classes to the `ContentType` instancees representing them.  

`get_by_natural_key(app_label, model)`  

Returns the `ContentType` instance uniquely identified by the given application
label and model name.

Allows ContentType objects to be referrenced via a natural key during deserialization.
```python
from django.db import models
from django.contrib.contenttypes.models import ContentType
from django.contrib.contenttypes import generic

class TaggedItem(models.Model):
  tag = models.SlugField()
  content_type = models.ForeignKey(ContentType)
  object_id = models.PositiveIntegerField()
  content_object = generic.GenericForeignKey('content_type', 'object_id')
  # Python 3 def __str__(self):
  def __unicode__(self):
    return self.tag
```  

GenericForeignKey class  
---------------------------
Three parts to setting up:  
* Give your model a `ForeignKey` to `ContentType` typically called `content_type`  
* Give your model a field that can store primary key valus from a model relation:  
  `PositiveIntegerField()` typically called `object_id`.  
* Give your model a `GenericForeignKey` and pass it the names of the `object_id`
and `content_type` fields.  


`GenericForeignKey()` will look for:  
`for_concrete_model`

If `False` field will be able to reference proxy models. (`Default=True`)

`True` mirrors  the `for_concrete_model arg `get_for_model()`  
NOTE: for models whos primary key is not an integer you can use `CharField`
but values must be coerced by `get_db_prep_value()`

Each `TaggedItem` will have a `content_object` field that returns the object 
it's related to. you can also assign to a field or use it when creating 
`TaggedItem`  

```python
>>> from django.contrib.auth.models import User
...  guido = User.objects.get(username='Guido')
...  t = TaggedItem(content_object=guido, tag='bdf1')
...  t.save()
>>> t.content_object  
<User: Guido>
```  

Cannot use `GenericForeignKey` fields with filters directly.

If you know which models you'll be using most often you can add a
"reverse" generic relationship to enable an additional API.  

###### e.g.  
```python
>>> class Bookmark(models.Model):
...   url = models.URLField()
...   tags = generic.GenericRelation(TaggedItem)

...   b = Bookmark(url='https://www.djangoproject.com/')
...
>>> b.save()
>>> t1 = TaggedItem(content_object=b, tag='django')
>>> t1.save()
>>> t2 = TaggedItem(content_object=b, tag='python')
>>> t2save()
>>> b.tags.all()
<TaggedItem: django>, <TaggedItem: python>
```  


if using non-default names for model or values then you must specify that when
  calling GenericRelation
```python
tags = generic.GenericRelation(TaggedItem,
                  content_type_field='content_type_fk',
                  object_id_field='object_primary_key')
```  

#### Generic relations
Adding a `foreignkey` from one of your own models to `ContentType` allows
your model to effectively relate itself to another model class, as in
the example.  

