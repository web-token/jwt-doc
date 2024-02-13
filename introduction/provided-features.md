# Provided Features

## Supported Input Types:

JWS or JWE objects support every input that can be encoded into JSON:

* `string`, `array`, `integer`, `float`...
* Objects that implement the `\JsonSerializable` interface such as `JWK` or `JWKSet`

The [detached payload](../advanced-topics/signed-tokens-and/detached-payload.md) is supported.

## Supported Serialization Modes

| Serialization syntax | JWS | JWE |
| -------------------- | --- | --- |
| Compact              | YES | YES |
| Flattened JSON       | YES | YES |
| General JSON         | YES | YES |



## Supported Compression Methods

| Compression mode | Supported |
| ---------------- | --------- |
| Deflate (`DEF`)  | YES       |

{% hint style="info" %}
The library is able to support any other compression methods just by declaring new classes.
{% endhint %}

## Supported Key Types (JWK)

| Key Type | Supported | Comment                               |
| -------- | --------- | ------------------------------------- |
| oct      | YES       | Symmetric keys                        |
| RSA      | YES       | RSA based asymmetric keys             |
| EC       | YES       | Elliptic Curves based asymmetric keys |
| OKP      | YES       | Octet Key Pair based asymmetric keys  |

JWK objects support JSON Web Key Thumbprint ([RFC 7638](https://tools.ietf.org/html/rfc7638)).

{% hint style="info" %}
A `none` key type for the `none` algorithm. It is used to explicitly allow this unsecured algorithm.
{% endhint %}

## Key Sets (JWKSet)

JWKSet is fully supported.

## Supported Signature Algorithms

| Signature Algorithm                  | Supported | Comment                                                                          |
| ------------------------------------ | --------- | -------------------------------------------------------------------------------- |
| <p>HS256</p><p>HS384</p><p>HS512</p> | YES       |                                                                                  |
| <p>ES256</p><p>ES384</p><p>ES512</p> | YES       |                                                                                  |
| <p>RS256</p><p>RS384</p><p>RS512</p> | YES       |                                                                                  |
| <p>PS256</p><p>PS384</p><p>PS512</p> | YES       | <mark style="color:orange;">GMP or BCMath extension is highly recommended</mark> |
| none                                 | YES       | **Please note that this is not a secured algorithm. USE IT WITH CAUTION!**       |
| EdDSA with Ed25519 curve             | YES       |                                                                                  |
| EdDSA with Ed448 curve               | NO        | No extension or built-in implementation available                                |

{% hint style="info" %}
Other signature algorithms like `RS1`, `HS1` or `HS256/64` are also available. These algorithms should be used for testing purpose only or for compatibility with old systems
{% endhint %}

## Supported Key Encryption Algorithms

| Key Encryption Algorithm                                                      | Supported |                                                                                                                                                                  |
| ----------------------------------------------------------------------------- | --------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| dir                                                                           | YES       |                                                                                                                                                                  |
| <p>RSA1_5</p><p>RSA-OAEP</p><p>RSA-OAEP-256</p>                               | YES       | <p><mark style="color:orange;">GMP or BCMath extension is highly recommended</mark><br><br><mark style="color:red;"><strong>Read note below!</strong></mark></p> |
| <p>ECDH-ES</p><p>ECDH-ES+A128KW</p><p>ECDH-ES+A192KW</p><p>ECDH-ES+A256KW</p> | YES       |                                                                                                                                                                  |
| <p>ECDH-SS</p><p>ECDH-SS+A128KW</p><p>ECDH-SS+A192KW</p><p>ECDH-SS+A256KW</p> | YES       |                                                                                                                                                                  |
| <p>A128KW</p><p>A192KW</p><p>A256KW</p>                                       | YES       |                                                                                                                                                                  |
| <p>PBES2-HS256+A128KW</p><p>PBES2-HS384+A192KW</p><p>PBES2-HS512+A256KW</p>   | YES       |                                                                                                                                                                  |
| <p>A128GCMKW</p><p>A192GCMKW</p><p>A256GCMKW</p>                              | YES       |                                                                                                                                                                  |
| ECDH-ES with X25519 curve                                                     | YES       |                                                                                                                                                                  |
| ECDH-ES with X448 curve                                                       | NO        |                                                                                                                                                                  |

{% hint style="info" %}
Other encryption algorithms like `RSA-OEAP-384` or `ChaCha20-Poly1305` are also available. These algorithms should be used for testing purpose only or for compatibility with old systems
{% endhint %}

{% hint style="danger" %}
The algorithms `RSA1_5` and `RSA-OAEP` are now deprecated. Please use with caution.
{% endhint %}

## Supported Content Encryption Algorithms

| Content Encryption Algorithm                                 | Supported |
| ------------------------------------------------------------ | --------- |
| <p>A128CBC+HS256</p><p>A192CBC+HS384</p><p>A256CBC+HS512</p> | YES       |
| <p>A128GCM</p><p>A192GCM</p><p>A256GCM</p>                   | YES       |

{% hint style="info" %}
Other encryption algorithms like `A128CTR`, `A192CTR` and `A256CTR` are also available. These algorithms should be used for testing purpose only or for compatibility with old systems
{% endhint %}
