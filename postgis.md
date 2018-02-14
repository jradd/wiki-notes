##### PostGIS

https://github.com/jradd/postgis.git




```
$ psql -h $CONTAINER_IP -p 5432 -U docker -W -c "CREATE DATABASE template_postgis WITH OWNER docker"
# Allows non-superusers the ability to create from this template
$ psql -h $CONTAINER_IP -p 5432 -U docker -W template_postgis -c "UPDATE pg_database SET datistemplate='true' WHERE datname='template_postgis';"

$ psql -h $CONTAINER_IP -p 5432 -U docker -W template_postgis -c "create extension postgis"
$ psql -h $CONTAINER_IP -p 5432 -U docker -W template_postgis -c "create extension postgis_topology"
##### Gotcha
Needed to install postgresql-9.3 + postgis on host for now. (need to automate this in dockerfile somehow)
$ psql -h $CONTAINER_IP -p 5432 -U docker -W template_postgis -f /usr/share/postgresql/9.3/contrib/postgis-2.1/legacy.sql

# Enabling users to alter spatial tables.
$ psql -h $CONTAINER_IP -p 5432 -U docker -W -d template_postgis -c "GRANT ALL ON geometry_columns TO PUBLIC;"
$ psql -h $CONTAINER_IP -p 5432 -U docker -W -d template_postgis -c "GRANT ALL ON geography_columns TO PUBLIC;"
$ psql -h $CONTAINER_IP -p 5432 -U docker -W -d template_postgis -c "GRANT ALL ON spatial_ref_sys TO PUBLIC;"

$ psql -h $CONTAINER_IP -p 5432 -U docker -W postgres
#> CREATE DATABASE geodjango WITH OWNER docker TEMPLATE template_postgis;
```
/usr/share/postgresql/9.3/share/contrib/postgis-2.0/extras/ogc_test_suite

```
$ psql -h $CONTAINER_IP -p 5432  -U docker -a -W -f /usr/share/postgresql/9.3/contrib/postgis-2.1/extras/1_schema.sql ogc >& 1_output.txt
$ psql -h $CONTAINER_IP -p 5432  -U docker -a -W -f /usr/share/postgresql/9.3/contrib/postgis-2.1/extras/2_queries.sql ogc >& 2_output.txt
$ psql -h $CONTAINER_IP -p 5432  -U docker -a -W -f /usr/share/postgresql/9.3/contrib/postgis-2.1/extras/3_cleanupsql ogc >& 3_output.txt
```



#### docker django
```
docker run --rm -v /srv/www/django:/django jradd/django django-admin.py startproject myproject
```
```
docker run -d -v /srv/www/django:/django -p 8000:8000 jradd/django myproject/manage.py runserver 0.0.0.0:8000
```
