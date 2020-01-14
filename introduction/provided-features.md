# Provided Features

## Supported Input Types:

JWS or JWE objects support every input that can be encoded into JSON:

* `string`, `array`, `integer`, `float`...
* Objects that implement the `\JsonSerializable` interface such as `JWK` or `JWKSet`

The [detached payload](../advanced-topics-1/signed-tokens-and/detached-payload.md) is supported.

## Supported Serialization Modes

* Compact JSON Serialization Syntax for JWS and JWE
* Flattened JSON Serialization Syntax for JWS and JWE
* General JSON Serialization Syntax for JWS and JWE

## Supported Compression Methods

| Compression Method | Supported |
| :--- | :--- |
| Deflate \(`DEF`\) | YES |

## Supported Key Types \(JWK\)

| Key Type | Supported | Comment |
| :--- | :--- | :--- |
| oct | YES | Symmetric keys |
| RSA | YES | RSA based asymmetric keys |
| EC | YES | Elliptic Curves based asymmetric keys |
| OKP | YES | Octet Key Pair based asymmetric keys |

JWK objects support JSON Web Key Thumbprint \([RFC 7638](https://tools.ietf.org/html/rfc7638)\).

{% hint style="info" %}
A `none` key type for the `none` algorithm. It is used to explicitly allow this unsecured algorithm.
{% endhint %}

## Key Sets \(JWKSet\)

JWKSet is fully supported.

## Supported Signature Algorithms

| Signature Algorithm | Supported | Comment |
| :--- | :--- | :--- |
| HS256, HS384 and HS512 | YES |  |
| ES256, ES384 and ES512 | YES |  |
| RS256, RS384 and RS512 | YES |  |
| PS256, PS384 and PS512 | YES |  |
| none | YES | **Please note that this is not a secured algorithm. USE IT WITH CAUTION!** |
| EdDSA with Ed25519 curve | YES | [With PHP 7.1, third party extension highly recommended](https://github.com/jedisct1/libsodium-php) |
| EdDSA with Ed448 curve | NO | No extension or built-in implementation available |

{% hint style="info" %}
Other signature algorithms like `RS1`, `HS1` or `HS256/64` are also available. These algorithms should be used for testing purpose only or for compatibility with old systems
{% endhint %}

## Supported Key Encryption Algorithms

| Key Encryption Algorithm | Supported |
| :--- | :--- |
| dir | YES |
| RSA1\_5, RSA-OAEP and RSA-OAEP-256 | YES |
| ECDH-ES, ECDH-ES+A128KW, ECDH-ES+A192KW and ECDH-ES+A256KW | YES |
| A128KW, A192KW and A256KW | YES |
| PBES2-HS256+A128KW, PBES2-HS384+A192KW and PBES2-HS512+A256KW | YES |
| A128GCMKW, A192GCMKW and A256GCMKW | YES |
| ECDH-ES with X25519 curve | YES |
| ECDH-ES with X448 curve | NO |

{% hint style="info" %}
Other encryption algorithms like `RSA-OEAP-384` or `ChaCha20-Poly1305` are also available. These algorithms should be used for testing purpose only or for compatibility with old systems
{% endhint %}

{% hint style="warning" %}
For the `ECDH-ES` with X25519 curve with PHP 7.1, the [third party extension highly recommended](https://github.com/jedisct1/libsodium-php)
{% endhint %}

{% hint style="danger" %}
The algorithms `RSA1_5` and `RSA-OAEP` are now deprecated. Please use with caution.
{% endhint %}

## Supported Content Encryption Algorithms

| Content Encryption Algorithm | Supported |
| :--- | :--- |
| A128CBC+HS256, A192CBC+HS384 and A256CBC+HS512 | YES |
| A128GCM, A192GCM and A256GCM | YES |

{% hint style="info" %}
Other encryption algorithms like `A128CTR`, `A192CTR` and `A256CTR` are also available. These algorithms should be used for testing purpose only or for compatibility with old systems
{% endhint %}

