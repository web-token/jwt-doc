# Signature Algorithms

This framework comes with several signature algorithms. These algorithms are in the following namespace: `Jose\Component\Signature\Algorithm`.

<table><thead><tr><th width="207">Algorithm</th><th>Description</th></tr></thead><tbody><tr><td><p>HS256</p><p>HS384</p><p>HS512</p></td><td>HMAC with SHA-2 Functions</td></tr><tr><td><p></p><p>ES256</p><p>ES384</p><p>ES512</p></td><td>Elliptic Curve Digital Signature Algorithm (ECDSA)</td></tr><tr><td><p>RS256</p><p>RS384</p><p>RS512</p></td><td>RSASSA-PKCS1 v1_5</td></tr><tr><td><p>PS256</p><p>PS384</p><p>PS512</p></td><td>RSASSA-PSS</td></tr><tr><td>EdDSA (<em>only with the</em> Ed25519 <em>curve</em>)</td><td>Edwards-curve Digital Signature Algorithm (EdDSA)</td></tr><tr><td>none</td><td><mark style="color:red;">Not a secure algorithm. Please use with caution</mark></td></tr></tbody></table>

### The `none` Algorithm

Since 4.3, `none` lives in its own package, so that enabling it is an explicit and auditable decision:

```bash
composer require web-token/jwt-unsecured
```

```php
<?php

use Jose\Unsecured\Signature\None;
```

It is deliberately **not** part of `web-token/jwt-experimental`: `none` is perfectly standard, and an application asking for `Blake2b` should not get it in the bargain.

{% hint style="warning" %}
`Jose\Component\Signature\Algorithm\None` still works — it is an empty subclass of the new class — but it is deprecated since 4.3 and removed in 5.0. In the Symfony Bundle, the configuration alias is unchanged: `none` still names the algorithm.
{% endhint %}

{% hint style="danger" %}
`none` disables signature verification altogether. Read [Security Recommendations](../../introduction/security-recommendations.md#avoid-weak-algorithms) before enabling it.
{% endhint %}

### Experimental Algorithms

The following signature algorithms are experimental and must not be used in production unless you know what you are doing. <mark style="color:red;">They are proposed for testing purpose only.</mark>

They are provided through the package `web-token/jwt-experimental`.

| Algorithm | Description                                                                    |
| --------- | ------------------------------------------------------------------------------ |
| RS1       | RSASSA-PKCS1 v1\_5 with SHA-1 hashing function                                |
| HS1       | HMAC with SHA-1 hashing function                                               |
| HS256/64  | HMAC with SHA-256 truncated to 64 bits                                         |
| ES256K    | Elliptic curve secp256k1 support                                               |
| BP256R1   | ECDSA using the brainpoolP256r1 curve (`BP-256`) and SHA-256                   |
| BP384R1   | ECDSA using the brainpoolP384r1 curve (`BP-384`) and SHA-384                   |
| BP512R1   | ECDSA using the brainpoolP512r1 curve (`BP-512`) and SHA-512                   |
| Blake2b   | Blake2b MAC algorithm. <mark style="color:orange;">Sodium extension required</mark> |

{% hint style="warning" %}
The Brainpool algorithms and their curves are **not registered with IANA**. The identifiers `BP256R1`/`BP384R1`/`BP512R1` and `BP-256`/`BP-384`/`BP-512` follow the convention already adopted by the other implementations, so tokens using them are only interoperable with the implementations sharing that convention.

The curves themselves are part of the core library: [creating a Brainpool key](../key-jwk-and-key-set-jwkset/key-management.md#elliptic-curve-key-pair) or using one with `ECDH-ES`/`ECDH-SS` does not require the experimental package.
{% endhint %}

## How To Use

These algorithms have to be used with the [Algorithm Manager](../algorithm-management-jwa.md). They do not need any arguments.

Example:

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Signature\Algorithm\PS256;
use Jose\Component\Signature\Algorithm\ES512;
use Jose\Component\Signature\Algorithm\None;

$algorithm_manager = new AlgorithmManager([
    new PS256(),
    new ES512(),
    new None(),
]);
```
