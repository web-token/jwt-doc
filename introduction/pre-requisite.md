# Pre-requisite

This framework needs at least:

* ![PHP 7.2+](https://img.shields.io/badge/PHP-7.2%2B-ff69b4.svg),
* GMP extension.
* MBString extension.

Depending on the algorithms you using, other PHP extensions may be required \(e.g. OpenSSL\).

Please also consider the following optional requirements:

* If you intent to use `EdDSA` or `ECDH-ES` algorithm with `Ed25519`/`X25519` curves on PHP 7.1, please install this [third party extension](https://github.com/jedisct1/libsodium-php)

