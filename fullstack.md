## gWiki
The only way to publish notes.

[[https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/Veil_Nebula_-_NGC6960.jpg/640px-Veil_Nebula_-_NGC6960.jpg]]  

- nginx-proxy with automagic LetsEncrypt
- helper container
- git wiki (gollum/RoR)
- ghost blog (nodejs)  


### Workflow [why]

1. Maintain a single repository of text files (notes)
2. Git versioning allows you to keep track of what you publish.
3. Markdown allows you to create pretty html/css on-the-fly.
4. Edit files locally using Vim; then commit.
5. Or edit in web browser (auto commit)
6. There is really no better way to take notes that require code-blocks and formatting.
7. Free/open


[[https://wiki.jradd.com/uploads/Screen-Shot-2016-05-08-at-2.21.19-AM.png|float]]    
[[uploads/Screen-Shot-2016-05-08-at-2.21.19-AM.png|float]]    


This allows you to take notes using vim. 

The only notes that will be published to the wiki, are those which you commit. 

### Create Storage Container

`docker create -v /srv/data/wiki:/wiki --name gollum-data busybox /bin/false 'this would fail if we docker-run_d it'`

### Start the letsencrypt-nginx-proxy container stack 

```bash:containers.sh```  

### Add additional services

Adding nodejs ghost blog 

```
 docker run -d --name ghost-app \¬
  -e "VIRTUAL_HOST=blog.jradd.com" \¬
  -e "LETSENCRYPT_HOST=wiki.jradd.com" \¬
  -e "LETSENCRYPT_EMAIL=jredd42@gmail.com \¬
  --volumes-from ghost-data \¬
  -p 8080:2368 ghost
```

#### Behind the [[magic|https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion]].  

##### Automatic certificate renewal
Every hour (3600 seconds) the certificates are checked and every certificate that will expire in the next 30 days (90 days / 3) are renewed.
