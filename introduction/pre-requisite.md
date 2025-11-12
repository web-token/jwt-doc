# Pre-requisite

This framework needs at least:

* PHP 8.2+
* Extensions (required):
  * mbstring
  * json
  * openssl

* Extensions (recommended):
  * gmp or bcmath (for better performance with RSA/PSS algorithms)
  * sodium (for EdDSA with Ed25519 and ECDH-ES with X25519)
  * curl (for loading keys from remote URLs)

<mark style="color:orange;">Please note that cryptographic operations may be really slow, especially RSA functions. It is highly recommended to enable GMP or BCMath.</mark>
