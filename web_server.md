


`sudo apt-get install python-pip`

`sudo pip install --upgrade pip`

`sudo pip install --upgrade $(pip freeze)

`sudo apt-get install libpq-dev python-dev`





### Debian 7

### syslog-ng
`apt-get -y update && apt-get upgrade`
`apt-get install syslog-ng`

> "/etc/syslog-ng/syslog-ng.conf"


```
keep_hostname(yes);
long_hostnames(on);
create_dirs(yes);
```
```
destination clientslogs {
                      file("/var/log/debian-edu/$YEAR$MONTH$DAY/$HOST.auth");

        };
```
```
log {
              source(clients); destination(clientslogs);
        };
```

`/etc/init.d/syslog-ng restart`


------------------------------------------------------------------------------
		
OR:
```
destination d_tcp { tcp(“192.168.1.100″ port(1234) localport(999)); };
log { source(s_src); destination(d_tcp); }
```
##### For all clients:
Append to;
> "/etc/syslog-ng/syslog-ng.conf"
```
source s_net { tcp(ip(192.168.1.100) port(1234)); };

destination collector {
file(“/var/log/HOSTS/$HOST/$YEAR/$MONTH/$DAY/$FACILITY.log”
owner(root) group(root) perm(0600) dir_perm(0700) create_dirs(yes)
);
};

log { source(s_net); destination(collector); };
```

##### Client-side:

on clients check for `/var/log` dir containing syslog-ng for each host.

`apt-get install syslog-ng`

> "/etc/syslog-ng/syslog-ng.conf "

Add dest for main server (host)
```
destination tjener_syslog-ng {
           tcp( "10.0.2.2" port(514) );
        };
```
```
filter tjener_auth { facility(auth, authpriv) and match("pam_unix"); };
```

define new log:

```
log {
                source(s_all);
                filter(tjener_auth);
                destination(tjener_syslog-ng);
        };
```

`/etc/init.d/syslog-ng restart`



------------------------------------------------------------------------------

##### PostgreSQL-9.3
To install PostgreSQL version 9.3 on Debian 7 (wheezy):
```
echo "deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main" > /apt/sources.list.d/postgresql.list
```
Add the key:
```
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
  sudo apt-key add -
sudo apt-get update
```

`sudo apt-get install postgresql-9.3`

##### Compile NodeJS from source 
```
sudo apt-get install python g++ make checkinstall fakeroot
src=$(mktemp -d) && cd $src
wget -N http://nodejs.org/dist/node-latest.tar.gz
tar xzvf node-latest.tar.gz && cd node-v*
./configure
sudo fakeroot checkinstall -y --install=no --pkgversion $(echo $(pwd) | sed -n -re's/.+node-v(.+)$/\1/p') make -j$(($(nproc)+1)) install
sudo dpkg -i node_*
```

 
 
 
### Centos 6

`sudo rpm --import https://fedoraproject.org/static/0608B895.txt`

Then install

`sudo rpm -Uvh http://download-i2.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm`

And then the following command to install node and npm

`sudo yum install nodejs npm --enablerepo=epel`


or install node separately
`sudo yum install npm --enablerepo=epel`

### CentOS 7

`yum install docker docker-registry`
`systemctl start docker.service`
`systemctl enable docker.service`

Disable firewalld as it conflicts with docker:
`systemctl stop firewalld.service`
`systemctl disable firewalld.service`



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