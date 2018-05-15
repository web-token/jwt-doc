# PHAR Application

## PHAR Application

## Installation

To install the application, you just have to download it and download the associated public key \(the application is digitally signed\):

```bash
curl -OL https://github.com/web-token/jwt-app/raw/gh-pages/jose.phar
curl -OL https://github.com/web-token/jwt-app/raw/gh-pages/jose.phar.pubkey
```

If everything is fine, you should have two files:

* `jose.phar`
* `jose.phar.pubkey`

You can move these files wherever you want \(e.g. `/usr/local/bin`\).

To use it, just execute the following line:

```bash
./jose.phar
```

## Update

The application can be updated easily:

```bash
./jose.phar selfupdate
```

If a new version exists, it will be downloaded automatically. If there is something wrong with the new version, you can reinstall the previous revision:

```bash
./jose.phar rollback
```

