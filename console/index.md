# Console Commands

The project comes with console commands.  
They are available:

* [as a standalone command](standalone.md)
* [through the dedicated Symfony console command](symfony.md)
* [as a PHAR (PHP Archive)](phar.md)

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
