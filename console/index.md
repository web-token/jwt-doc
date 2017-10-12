# Console Commands

The project comes with console commands.  
They are available:

* as a standalone command
* through the dedicated Symfony console command
* ~~as a PHAR \(PHP Archive\)~~ \(available soon\)

# Available Commands

Available commands are:

* For keys
  * `key:analyze`:            JWK quality analyzer.
  * `key:convert:pkcs1`:      Converts a RSA or EC key into PKCS\#1 key.
  * `key:generate:ec`:        Generate an EC key \(JWK format\)
  * `key:generate:oct`:       Generate a octet key \(JWK format\)
  * `key:generate:okp`:       Generate an Octet Key Pair key \(JWK format\)
  * `key:generate:rsa`:       Generate a RSA key \(JWK format\)
  * `key:load:key`:           Loads a key from a key file \(JWK format\)
  * `key:load:p12`:           Load a key from a P12 certificate file.
  * `key:load:x509`:          Load a key from a X.509 certificate file.
  * `key:optimize`:           Optimize a RSA key by calculating additional primes \(CRT\).
  * `key:thumbprint`:         Get the thumbprint of a JWK key.
* For Key sets:
  * `keyset:add:key`:         Add a key into a key set.
  * `keyset:analyze`:         JWKSet quality analyzer.
  * `keyset:convert:public`:  Convert private keys in a key set into public keys. Symmetric keys \(shared keys\) are not changed.
  * `keyset:generate:ec`:     Generate an EC key set \(JWKSet format\)
  * `keyset:generate:oct`:    Generate a key set with octet keys \(JWK format\)
  * `keyset:generate:okp`:    Generate a key set with Octet Key Pairs keys \(JWKSet format\)
  * `keyset:generate:rsa`:    Generate a key set with RSA keys \(JWK format\)
  * `keyset:load:jku`:        Loads a key set from an url.
  * `keyset:load:x5u`:        Loads a key set from an url.
  * `keyset:merge`:           Merge several key sets into one.
  * `keyset:rotate`:          Rotate a key set.

You will get more information by following the command name with `--help`.

# Installation

To install the standalone application, you have to clone the repository and install the dependencies.  
We consider that `git` and `composer` are correctly installed.

```sh
git clone https://github.com/web-token/jwt-app.git
cd jwt-app
composer install --no-dev --optimize-autoloader --classmap-authoritative
```

## Standalone Console Command

You will find the standalone console command in the `bin` folder.

```sh
./bin/jose
```

## PHAR Package Compilation

You can compile this application into a single PHP Archive file \(PHAR\).  
You must first install Box:

```sh
curl -LSs https://box-project.github.io/box2/installer.php | php
```

If everything is fine, the box command should be available:

```sh
box --version
```

Then you can build the archive. This step takes  between one and two minutes.

```sh
box build
```

When the compilation is finished, you will get a `jose.phar` file at the project root folder.  
You can move this file wherever you want \(e.g. `/usr/local/bin`\).

To use it, just execute the following line:

```sh
jose.phar
```



