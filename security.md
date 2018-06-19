# Secure Sockets

## Encrypt with openssl
`openssl aes-256-cbc -a -e -salt -in foo -out foo.aes`


## Decrypt
`openssl aes-256-cbc -a -d -salt -in foo.aes -out foo`


#### FIPS 140-2 Cipher List  
```
aes128-ctr 
aes192-ctr 
aes256-ctr 
aes128-cbc 
aes192-cbc 
aes256-cbc 
3des-cbc 
rijndael-cbc@lysator.liu.se 
```

#### Proposed  
```
3des-cbc
aes128-cbc
aes192-cbc
aes256-cbc
rijndael-cbc@lysator.liu.se
aes128-ctr
aes192-ctr
aes256-ctr
aes128-gcm@openssh.com
aes256-gcm@openssh.com
```
