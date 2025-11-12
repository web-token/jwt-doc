# Pre-requisite

This framework needs at least:

* PHP 8.3+,
* Extensions:
  * MBString
  * JSON

Depending on the algorithms you using, other PHP extensions may be required (e.g. OpenSSL, Sodium).

<mark style="color:orange;">Please note that cypher operation may be really slow, especially RSA functions. It is highly recommended to enable GMP or BCMath.</mark>
