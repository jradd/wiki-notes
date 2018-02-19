# Maria DB / MySQL / Docker

## Setup

### Docker

`docker run -d mariadb -p 3306:3306 tutum/mariadb`  

`docker logs mariadb`  

> Use the syntax and password generated from the output of running container to 
setup mysql database.  


### MariaDB Create

```
mysql> CREATE DATABASE ghost;
mysql> CREATE USER 'ghost'@'localhost' IDENTIFIED BY 'dubbledigitluv';
mysql> GRANT ALL PRIVILEGES ON *.* TO 'ghost'@'localhost';
mysql> FLUSH PRIVILEGES;
mysql> QUIT;
```
