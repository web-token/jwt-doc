# Prerequisites

This framework needs at least:

* PHP 8.2+
* Extensions (required):
  * openssl

* Extensions (recommended):
  * gmp or bcmath (for better performance with RSA/PSS algorithms)
  * sodium (for Ed25519 and X25519 on PHP 8.2 and 8.3 — PHP 8.4 can use OpenSSL instead — and faster Base64URL encoding)
  * curl (for loading keys from remote URLs)
* The ML-DSA algorithms (RFC 9964) need PHP 8.4 and an OpenSSL 3.5 runtime; `MLDSA44::isSupported()` tells whether the platform has them.

!!! info

    The `json` extension is built-in with PHP 8.2+ and no longer needs to be installed separately.

!!! info

    When the `ext-sodium` extension is available, the framework automatically uses it for Base64URL encoding/decoding operations, providing significant performance improvements.

Please note that cryptographic operations may be really slow, especially RSA functions. It is highly recommended to enable GMP or BCMath.
