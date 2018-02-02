#OpenSSL
Guide to one of the most useful services of the web: OpenSSL

## Encrypt File
`openssl aes-256-cbc -a -e -salt -in foo -out foo.aes`
## Decrypt File
`openssl aes-256-cbc -a -d -salt -in foo.aes -out foo`

## Tunnel
`radd@WORK: ssh -R 12345:localhost:22 guido@HOME`
`guido@HOME: ssh localhost -p 12345`
