# GeoDjango et cetera
Notes for Geo-Django and django in general.

migrate will by default only run on `default` database. So you must specify the database to migrate
if you have multiple DB's:

`python manage.py migrate --database=geocampy`

## Installation
```
sudo apt-get install binutils libproj-dev gdal-bin
```

1: The models module is imported from django.contrib.gis.db.
2: You must override the model’s default manager with GeoManager to perform spatial queries.

The default spatial reference system for geometry fields is WGS84 (meaning the SRID is 4326) – in other words, the field coordinates are in longitude, latitude pairs in units of degrees. To use a different coordinate system, set the SRID of the geometry field with the srid argument. Use an integer representing the coordinate system’s EPSG code.

```
./manage.py migrate
./manage.py migrate --database=users
```
#### MULTI-DB
Selecting which database to save to:
```
>>> my_object.save(using='legacy_users')
```


If you don’t want every application to be synchronized onto a particular database, you can define a database router that implements a policy constraining the availability of particular models.

Alternatively, if you want fine-grained control of synchronization, you can pipe all or part of the output of sqlall for a particular application directly into your database prompt, like this:

`./manage.py sqlall sales | ./manage.py dbshell`

`allow_migrate(db, model)`
Determine if the model should have tables/indexes created in the database with alias db. Return True if the model should be migrated, False if it should not be migrated, or None if the router has no opinion. This method can be used to determine the availability of a model on a given database.

Note that migrations will just silently not perform any operations on a model for which this returns False. This may result in broken ForeignKeys, extra tables or missing tables if you change it once you have applied some migrations.

The value passed for model may be a historical model, and thus not have any custom attributes, methods or managers. You should only rely on _meta.


Router doesn’t have to provide all these methods – it may omit one or more of them. If one of the methods is omitted, Django will skip that router when performing the relevant check.

#### Hints
The hints received by the database router can be used to decide which database should receive a given request.


### Import Data
Import geographical data using ogrinspect:

`$ python manage.py ogrinspect [options] <data_source> <model_name> [options]`

```
$ python manage.py ogrinspect world/data/TM_WORLD_BORDERS-0.3.shp WorldBorder \
    --srid=4326 --mapping --multi
```
the same thing manually using a load.py file and custom import methods:
```
...
world_shp = os.path.abspath(os.path.join(os.path.dirname(__file__), 'data/TM_WORLD_BORDERS-0.3.shp'))

def run(verbose=True):
    lm = LayerMapping(WorldBorder, world_shp, world_mapping,
                      transform=False, encoding='iso-8859-1')

    lm.save(strict=True, verbose=verbose)
```
LayerMethod class snippet:
```
class LayerMethod(__builtin__.object)

  __init__(self, model, data, mapping, layer=0, source_srs=None, encoding='utf-8', transaction_mode='commit_on_success', transform=True, unique=None, using=None)
  """
  A LayerMapping object is initialized using the given Model (not an instance),
  a DataSource (or string path to an OGR-supported data file), and a mapping dictionary.
  """
```
```
 save(self, verbose=False, fid_range=False, step=False, progress=False, silent=False, stream=<open file '
```

When using raw queries, you should generally wrap your geometry fields with the asText() SQL function (or ST_AsText for PostGIS) so that the field value will be recognized by GEOS:

`City.objects.raw('SELECT id, name, asText(point) from myapp_city')`

Not absolutely required by PostGIS, but you should only use raw queries when you absolutely know what you are doing.


```
prepare_database_save(self, unused)
save(self, force_insert=False, force_update=False, using=None, update_fields=None)
```

