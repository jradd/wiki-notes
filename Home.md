---
GOLLEM WIKI
---
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
VIRTUAL_PORT=$EXPOSED
somerepo/dirp:latest
```



 **[Jekyll](https://jekyllrb.com/docs/home/ "Blog–aware, static site–generator.").**

Check out my barebones template if you'd like:  
https://jeremyredd.com
https://blog.jeremyredd.com
https://wiki.jeremyredd.com (here)

### TO DO:  

#### Public Repositories  
* https://github.com/jradd/notes  
* https://github.com/jradd/blog

#### Resources  

* [PGP Signature](https://jeremyredd.com/jredd_pgp_sig)  

* [Public Key](https://jeremyredd.com/jredd_key.pub)  

#### Projects  


##### Complete  

* crawl.py  
* dns_blacklist.py

##### Work in Progress  

* transparent_web_filter (proxy)
  - trusted cert for final, but interim solution uses self–signed certificate
  - proxy options: HTTP(s) over DNS socks5
  - tor services?
  - replace raspberry pi with something smaller, or something bigger that supports wireless AC.

* Automated wireless access security test
  - targeted de–auth
  - mic–exchange capture
  - custom dictionaries / rainbow tables for offline password test.
  - WPS brute–force pin checker (for X models)

### Development and Learning  

I'm constantly changing things up to prevent the _obligatory burn–out_ that comes with technical 
research, development and systems support.

Here is a list of my currently active interests for personal and career development:  

- C, Python, Crystal–lang
- BSD/Unix, Linux Systems Programming
- TCP/IP inter–systems communication
- Network, CPU/MEM, Disk, and Software performance

##### Information Security Research.   

Current interest includes: Spectre[2] and Meltdown, privacy (and sometimes encryption, but I am not the best with math), 
fingerprinting, ssh agent forwarding, shell code and asm (when I'm feeling particularly brave).


##### Personal Goals/Interests
Music, Art, Competitive Sport

New Years Resolution:
1. Learn to play "Intro + Keep it Healthy" by Warpaint on the guitar.
2. Learn to play "Here Comes the Sun." by The Beetles on the guitar.
3. Learn the basics of either Dutch or Norwegian language.
4. Visit Europe (planning to travel to the Netherlands in the Spring)

![Flag](https://upload.wikimedia.org/wikipedia/commons/2/20/Flag_of_the_Netherlands.svg)
![Flag](https://upload.wikimedia.org/wikipedia/commons/d/d9/Flag_of_Norway.svg)

### More Markdown Tests
<a href="http://www.youtube.com/watch?feature=player_embedded&v=lJOhdseSxoY
" target="_blank"><img src="http://img.youtube.com/vi/lJOhdseSxoY/0.jpg" 
alt="Warpaint - Jubilee" width="240" height="180" border="10" /></a>

#### Or…  

<iframe width="560" height="315" src="https://www.youtube.com/embed/lJOhdseSxoY" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>



