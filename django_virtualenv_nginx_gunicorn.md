
```
sudo apt-get update
sudo apt-get install postgresql postgresql-contrib
```

```
sudo su - postgres
	createuser -P
	createdb --owner $ROLE $NEWDB
	logout
```

```
sudo apt-get install libpq-dev python-dev
<$VENV> pip install psycopg2
```

```
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'hello',
        'USER': 'hello_django',
        'PASSWORD': '1Ak5RTQt7mtw0OREsfPhJYzXIak41gnrm5NWYEosCeIduJck10awIzoys1wvbL8',
        'HOST': 'localhost',
        'PORT': '',                      # Set to empty string for default.
    }
}
```

```
$ sudo groupadd --system webapps
$ sudo useradd --system --gid webapps --home /webapps/hello_django hello 
```

```
<$VENV> pip install gunicorn
<$VENV> gunicorn hello.wsgi:application --bind example.com:8001
```

```
#!/bin/bash
 
NAME="hello_app"                                  # Name of the application
DJANGODIR=/webapps/hello_django/hello             # Django project directory
SOCKFILE=/webapps/hello_django/run/gunicorn.sock  # we will communicte using this unix socket
USER=hello                                        # the user to run as
GROUP=webapps                                     # the group to run as
NUM_WORKERS=3                                     # how many worker processes should Gunicorn spawn
DJANGO_SETTINGS_MODULE=hello.settings             # which settings file should Django use
DJANGO_WSGI_MODULE=hello.wsgi                     # WSGI module name
 
echo "Starting $NAME as `whoami`"
 
# Activate the virtual environment
cd $DJANGODIR
source ../bin/activate
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH
 
# Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR

```

```
# Start your Django Unicorn
# Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
exec ../bin/gunicorn ${DJANGO_WSGI_MODULE}:application \
  --name $NAME \
  --workers $NUM_WORKERS \
  --user=$USER --group=$GROUP \
  --log-level=debug \
  --bind=unix:$SOCKFILE
``` 

```
 sudo chown -R hello:users /webapps/hello_django
 sudo chmod -R g+w /webapps/hello_django
 
 sudo usermod -a -G users `whoami`
 
 sudo chmod u+x bin/gunicorn_start
 bin/gunicorn_start
 
 sudo apt-get install python-dev
 
# To display the proper name from the '--name' arg install the C header files for Python-Dev pkg using;
 <$VENV> pip install setproctitle
``` 
