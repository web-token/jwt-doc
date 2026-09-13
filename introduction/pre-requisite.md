# Prerequisites

This framework needs at least:

* PHP 8.2+
* Extensions (required):
  * openssl

* Extensions (recommended):
  * gmp or bcmath (for better performance with RSA/PSS algorithms)
  * sodium (for Ed25519 and X25519 on PHP 8.2 and 8.3 — PHP 8.4 can use OpenSSL instead — and faster Base64URL encoding)
  * curl (for loading keys from remote URLs)

{% hint style="info" %}
The `json` extension is built-in with PHP 8.2+ and no longer needs to be installed separately.
{% endhint %}

{% hint style="info" %}
When the `ext-sodium` extension is available, the framework automatically uses it for Base64URL encoding/decoding operations, providing significant performance improvements.
{% endhint %}

<mark style="color:orange;">Please note that cryptographic operations may be really slow, especially RSA functions. It is highly recommended to enable GMP or BCMath.</mark>
