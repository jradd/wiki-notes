# SmartCard
Misc notes on my experience with gpg2 on OS X with yubikey




### Todo
Try adding 4K length key strength to card instead of 2K


```
~ ❯❯❯ gpg2 --edit-card                                                                                                              ⏎ 

Reader ...........: Yubico Yubikey NEO OTP U2F CCID
Application ID ...: D2760001240102000006054958450000
Version ..........: 2.0
Manufacturer .....: Yubico
Serial number ....: 05495845
Name of cardholder: [not set]
Language prefs ...: [not set]
Sex ..............: unspecified
URL of public key : [not set]
Login data .......: jradd
Signature PIN ....: not forced
Key attributes ...: rsa2048 rsa2048 rsa2048
Max. PIN lengths .: 127 127 127
PIN retry counter : 3 3 3
Signature counter : 4
Signature key ....: 1D38 6516 6E76 CB69 014A  F8E5 8400 1C37 E2D5 0608
      created ....: 2018-02-12 05:15:14
Encryption key....: EF5A 46C0 BA46 F7E6 CFE0  2D1E C111 A54F 32BA 9248
      created ....: 2018-02-12 05:15:14
Authentication key: 9F67 517F D136 E6AE 1648  FBBC F289 EBC9 9C20 9455
      created ....: 2018-02-12 05:15:14
General key info..: pub  rsa2048/0x84001C37E2D50608 2018-02-12 jradd (gh) <jredd42@gmail.com>
sec>  rsa2048/0x84001C37E2D50608  created: 2018-02-12  expires: never     
                                  card-no: 0006 05495845
ssb>  rsa2048/0xF289EBC99C209455  created: 2018-02-12  expires: never     
                                  card-no: 0006 05495845
ssb>  rsa2048/0xC111A54F32BA9248  created: 2018-02-12  expires: never     
                                  card-no: 0006 05495845

gpg/card> admin
Admin commands are allowed

gpg/card> generate
...
```

##### Reset PIN Retries
```
gpg-connect-agent --hex < "/hex
scd serialno
scd apdu 00 20 00 81 08 40 40 40 40 40 40 40 40
scd apdu 00 20 00 81 08 40 40 40 40 40 40 40 40
scd apdu 00 20 00 81 08 40 40 40 40 40 40 40 40
scd apdu 00 20 00 81 08 40 40 40 40 40 40 40 40
scd apdu 00 20 00 83 08 40 40 40 40 40 40 40 40
scd apdu 00 20 00 83 08 40 40 40 40 40 40 40 40
scd apdu 00 20 00 83 08 40 40 40 40 40 40 40 40
scd apdu 00 20 00 83 08 40 40 40 40 40 40 40 40
scd apdu 00 e6 00 00
scd apdu 00 44 00 00
/echo card has been reset to factory defaults"
```
