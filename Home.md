# GOLLEM WIKI
git–based wiki for notes

configure `docker-compose.yml` to use `nginx-gen` and most importantly; 
`VIRTUAL_PORT=` in addition to the required parameters:

Run:
`docker-compose up`

Additional containers:

```
docker run -d \
VIRTUAL_HOST=$NAMES
LETSENCRYPT_HOST=$NAMES
LETSENCRYPT_EMAIL=$EMAIL
VIRTUAL_NETWORK=nginx-proxy
VIRTUAL_PORT=$EXPOSED
somerepo/dirp:latest
```

Blog running **[Jekyll](https://jekyllrb.com/docs/home/ "Blog–aware, static site–generator.").**  

[https://JeremyRedd.com](https://jeremyredd.com)  
[Blog](https://blog.jeremyredd.com)  
Wiki [here](https://wiki.jeremyredd.com)  

## Links  
[github/jtredd](https://github.com/jtredd)  
[github/jradd](https://github.com/jradd)

[Facebook](https://facebook.com/jeremytredd)  
[Google+](https://plus.google.com/JeremyRedd+)  
[LinkedIn](https://linkedin.com/in/jeremytredd)  
[Twitter](https://twitter.com/jeremytredd)  
[Slack](https://jredd.slack.com)  
[Reddit](https://www.reddit.com/user/jradd)  
[SuperUser](https://superuser.com/users/87239/jredd)  
[StackOverflow](https://stackoverflow.com/users/2789486/jredd)  


### TO DO:  

#### Public Repositories  
* https://github.com/jradd/wiki-notes  
* https://github.com/jradd/blog

#### Resources  

* [PGP Signature](https://jeremyredd.com/jredd_pgp_sig)  

* [Public Key](https://jeremyredd.com/jredd_key.pub)  

#### Projects  


##### Complete  

* [crawl.py](crawl)  
* [dns_blacklist.py](dns_blacklist)  

### To Do
* Finish frontend for blog
* Publish posts
* Portal
- crystal-lang webserver
- flask-app
I want to build a SPA with ReactJS on flask with rest.
NOT EASY
- crystal-lang c bindings (lua, pcap)
Cannot figure out how to get these working on mac or linux. I think it is
related to my c library path.



### Development and Learning  

- C, Python, Crystal–lang
- BSD/Unix, Linux Systems Programming
- TCP/IP inter–systems communication
- Network, CPU/MEM, Disk, and Software performance


