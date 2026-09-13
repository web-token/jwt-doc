# Signature Algorithms

This framework comes with several signature algorithms. These algorithms are in the following namespace: `Jose\Component\Signature\Algorithm`.

<table><thead><tr><th width="207">Algorithm</th><th>Description</th></tr></thead><tbody><tr><td><p>HS256</p><p>HS384</p><p>HS512</p></td><td>HMAC with SHA-2 Functions</td></tr><tr><td><p></p><p>ES256</p><p>ES384</p><p>ES512</p></td><td>Elliptic Curve Digital Signature Algorithm (ECDSA)</td></tr><tr><td>ES256K</td><td>ECDSA over the secp256k1 curve with SHA-256 (RFC 8812). Since 4.3, see below</td></tr><tr><td><p>RS256</p><p>RS384</p><p>RS512</p></td><td>RSASSA-PKCS1 v1_5</td></tr><tr><td><p>PS256</p><p>PS384</p><p>PS512</p></td><td>RSASSA-PSS</td></tr><tr><td><p>Ed25519</p><p>Ed448</p></td><td>Edwards-curve Digital Signature Algorithm (EdDSA), fully-specified per RFC 9864. Since 4.3; <code>Ed448</code> needs PHP 8.4</td></tr><tr><td><p>ML-DSA-44</p><p>ML-DSA-65</p><p>ML-DSA-87</p></td><td>Module-Lattice-Based Digital Signature Algorithm (ML-DSA, FIPS 204), post-quantum, per RFC 9964. Since 4.3; needs PHP 8.4 and OpenSSL 3.5</td></tr><tr><td>EdDSA (<em>only with the</em> Ed25519 <em>curve</em>)</td><td><mark style="color:orange;">Deprecated by RFC 9864</mark>, use <code>Ed25519</code>. See below</td></tr><tr><td>none</td><td><mark style="color:red;">Not a secure algorithm. Please use with caution</mark></td></tr></tbody></table>

### The `ES256K` Algorithm

`ES256K` — ECDSA over the secp256k1 curve with SHA-256, [RFC 8812](https://www.rfc-editor.org/rfc/rfc8812.html) — is a standard algorithm that lived in the experimental package for historical reasons. Since 4.3 it is `Jose\Component\Signature\Algorithm\ES256K`, next to `ES256`, and the Symfony Bundle registers it under the `ES256K` alias like any other algorithm. Keys are `EC` keys with `crv: secp256k1`; an `ES256KKeyAnalyzer` checks them.

```php
<?php

use Jose\Component\Signature\Algorithm\ES256K;
```

{% hint style="warning" %}
`Jose\Experimental\Signature\ES256K` still works — it is a deprecated subclass of the new class, and the bundle keeps its service for the applications that inject it — but it is removed in 5.0. Change the `use` statement.

Known limitation, unchanged: a secp256k1 key exported to PEM cannot be loaded back through the key loader on some OpenSSL builds. Keep such keys as JWK.
{% endhint %}

### The `Ed25519` And `Ed448` Algorithms

[RFC 9864](https://www.rfc-editor.org/rfc/rfc9864.html) registers the fully-specified `Ed25519` and `Ed448` algorithms and deprecates the polymorphic `EdDSA`: the name of the algorithm alone must say which curve is in use. The keys are unchanged — an `OKP` key with `crv: Ed25519` or `crv: Ed448` — only the `alg` value differs.

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Signature\Algorithm\Ed25519;
use Jose\Component\Signature\Algorithm\Ed448;

$algorithmManager = new AlgorithmManager([new Ed25519(), new Ed448()]);
```

Each algorithm accepts its own curve only: `Ed25519` refuses a key on `Ed448` and `Ed448` a key on `Ed25519`, with an `InvalidKeyException`.

* `Ed25519` runs on the `sodium` extension when it is loaded, as `EdDSA` always did, and on OpenSSL otherwise (PHP 8.4 or later).
* `Ed448` runs on OpenSSL only, and needs PHP 8.4 or later — before that version PHP cannot ask OpenSSL for the digest-less signature the Edwards curves require. `Ed448::isSupported()` tells whether the platform can run it; the constructor throws a `MissingDependencyException` when it cannot, and the Symfony Bundle registers the algorithm only when it can run.

{% hint style="warning" %}
**`EdDSA` is deprecated since 4.3.** It keeps working — the tokens already in circulation still verify — and signing with it raises a deprecation notice. Migrate the issuer first, then the verifiers:

1. register `Ed25519` next to `EdDSA` on the verifiers, so that both `alg` values are accepted;
2. switch the issuer to `Ed25519`: same key, `alg: Ed25519` in the header;
3. once no `EdDSA` token is in circulation any more, drop `EdDSA` from the verifiers.

A key carrying `alg: EdDSA` is refused by the `Ed25519` algorithm, and a key carrying `alg: Ed25519` by `EdDSA`: update the `alg` of the keys with the issuer, or leave it out during the migration. The key analyzer reports keys still declaring `alg: EdDSA`.
{% endhint %}

### The `ML-DSA-44`, `ML-DSA-65` And `ML-DSA-87` Algorithms

[RFC 9964](https://www.rfc-editor.org/rfc/rfc9964.html) registers ML-DSA ([FIPS 204](https://csrc.nist.gov/pubs/fips/204/final), the module-lattice signature scheme) for JOSE: the first post-quantum signature of the registries. The three parameter sets are the pure ML-DSA of FIPS 204 with an empty context — no HashML-DSA, which section 7.2 of the RFC excludes.

The keys are of the `AKP` type (section 3), with `pub` the encoded public key and `priv` the **32-byte seed** — the only private key representation the RFC allows (section 4), from which the whole key is derived. `alg` is **required** on every AKP key: the type says nothing about the algorithm.

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\KeyManagement\JWKFactory;
use Jose\Component\Signature\Algorithm\MLDSA44;
use Jose\Component\Signature\Algorithm\MLDSA65;
use Jose\Component\Signature\Algorithm\MLDSA87;

$algorithmManager = new AlgorithmManager([new MLDSA44(), new MLDSA65(), new MLDSA87()]);

$key = (new JWKFactory())->mldsa('ML-DSA-65', ['use' => 'sig']);
// {"kty":"AKP","alg":"ML-DSA-65","pub":"...","priv":"...32-byte seed...","use":"sig"}
```

Before OpenSSL sees a key, the algorithm checks it as section 7.3 requires: `alg` present and equal to the algorithm, `pub` of the size of the parameter set (1312, 1952 or 2592 bytes), `priv` of exactly 32 bytes, and — when the key carries both — that `pub` is the key the seed expands to. Signatures are 2420, 3309 or 4627 bytes; a signature of another length is `false` before any computation.

{% hint style="warning" %}
**Platform requirement.** The computation is OpenSSL's, and needs **PHP 8.4** (the first version able to sign without a digest through OpenSSL) and an **OpenSSL 3.5** runtime. The OpenSSL check is a runtime probe — `OPENSSL_VERSION_TEXT` reports the headers PHP was built against, not the library it loaded — so `MLDSA44::isSupported()` tells whether the platform can run the algorithms; the constructors throw a `MissingDependencyException` naming the missing piece, and the Symfony Bundle registers the algorithms only when they can run.
{% endhint %}

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
