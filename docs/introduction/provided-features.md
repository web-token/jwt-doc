# Provided features

## Supported input types:

JWS or JWE objects support every input that can be encoded into JSON:

* `string`, `array`, `integer`, `float`...
* Objects that implement the `\JsonSerializable` interface such as `JWK` or `JWKSet`

The [detached payload](../advanced-topics/signed-tokens-and/detached-payload.md) is supported.

## Supported serialization modes

| Serialization syntax | JWS | JWE |
| -------------------- | --- | --- |
| Compact              | YES | YES |
| Flattened JSON       | YES | YES |
| General JSON         | YES | YES |

## Supported compression methods

!!! danger

    Compression is not recommended. For 4.0.0, the support of compression is no longer available. See [RFC8725](https://datatracker.ietf.org/doc/html/rfc8725#section-3.6) for more information.

## Supported key types (JWK)

| Key Type | Supported | Comment                               |
| -------- | --------- | ------------------------------------- |
| oct      | YES       | Symmetric keys                        |
| RSA      | YES       | RSA based asymmetric keys             |
| EC       | YES       | Elliptic Curves based asymmetric keys |
| OKP      | YES       | Octet Key Pair based asymmetric keys  |

JWK objects support JSON Web Key Thumbprint ([RFC 7638](https://tools.ietf.org/html/rfc7638)).

!!! info

    A `none` key type for the `none` algorithm. It is used to explicitly allow this unsecured algorithm.

## Key sets (JWKSet)

JWKSet is fully supported.

## Supported signature algorithms

| Signature Algorithm                  | Supported | Comment                                                                                                    |
| ------------------------------------ | --------- | ---------------------------------------------------------------------------------------------------------- |
|HS256<br>HS384<br>HS512| YES       |                                                                                                            |
|ES256<br>ES384<br>ES512| YES       |                                                                                                            |
|RS256<br>RS384<br>RS512| YES       |                                                                                                            |
|PS256<br>PS384<br>PS512| YES       | GMP or BCMath extension is highly recommended                           |
| EdDSA with Ed25519 curve             | YES       | SODIUM extension is required                                            |
| EdDSA with Ed448 curve               | NO        | No extension or built-in implementation available                                                          |
| none                                 | YES       | **Please note that this is not a secured algorithm. USE IT WITH CAUTION!** |

!!! info

    Other signature algorithms like `RS1`, `HS1` or `HS256/64` are also available. These algorithms should be used for testing purpose only or for compatibility with old systems

## Supported key encryption algorithms

| Key Encryption Algorithm                                                      | Supported |                                                                                                                                                                  |
| ----------------------------------------------------------------------------- | --------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| dir                                                                           | YES       |                                                                                                                                                                  |
|RSA1_5<br>RSA-OAEP<br>RSA-OAEP-256| YES       |GMP or BCMath extension is highly recommended<br><br><strong>Read note below!</strong>|
|ECDH-ES<br>ECDH-ES+A128KW<br>ECDH-ES+A192KW<br>ECDH-ES+A256KW| YES       | `spomky-labs/aes-key-wrap` is required for \*KW algorithms                                                                                                       |
|ECDH-SS<br>ECDH-SS+A128KW<br>ECDH-SS+A192KW<br>ECDH-SS+A256KW| YES       | `spomky-labs/aes-key-wrap` is required for \*KW algorithms                                                                                                       |
|A128KW<br>A192KW<br>A256KW| YES       | `spomky-labs/aes-key-wrap` is required                                                                                                                           |
|PBES2-HS256+A128KW<br>PBES2-HS384+A192KW<br>PBES2-HS512+A256KW| YES       | `spomky-labs/aes-key-wrap` is required                                                                                                                           |
|A128GCMKW<br>A192GCMKW<br>A256GCMKW| YES       | `spomky-labs/aes-key-wrap` is required                                                                                                                           |
| ECDH-ES with X25519 curve                                                     | YES       | SODIUM extension is required                                                                                                  |
| ECDH-ES with X448 curve                                                       | NO        | No extension or built-in implementation available                                                                                                                |

!!! info

    Other encryption algorithms like `RSA-OEAP-384` or `ChaCha20-Poly1305` are also available. These algorithms should be used for testing purpose only or for compatibility with old systems

!!! danger

    The algorithms `RSA1_5` and `RSA-OAEP` are now deprecated. Please use with caution.

## Supported content encryption algorithms

| Content Encryption Algorithm                                 | Supported |
| ------------------------------------------------------------ | --------- |
|A128CBC+HS256<br>A192CBC+HS384<br>A256CBC+HS512| YES       |
|A128GCM<br>A192GCM<br>A256GCM| YES       |

!!! info

    Other encryption algorithms like `A128CTR`, `A192CTR` and `A256CTR` are also available. These algorithms should be used for testing purpose only or for compatibility with old systems
