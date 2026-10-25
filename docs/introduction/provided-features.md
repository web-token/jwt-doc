# Provided features

## Supported input types

JWS or JWE objects support every input that can be encoded into JSON:

* `string`, `array`, `integer`, `float`...
* Objects that implement the `\JsonSerializable` interface such as `JWK` or `JWKSet`

The [detached payload](../advanced-topics/signed-tokens/detached-payload.md) is supported.

## Supported serialization modes

| Serialization syntax | JWS | JWE |
| -------------------- | --- | --- |
| Compact              | YES | YES |
| Flattened JSON       | YES | YES |
| General JSON         | YES | YES |

## Supported compression methods

!!! danger

    Compression is not recommended. Since version 4.0, compression support has been removed. See [RFC 8725](https://datatracker.ietf.org/doc/html/rfc8725#section-3.6) for more information.

## Supported key types (JWK)

| Key Type | Supported | Comment                               |
| -------- | --------- | ------------------------------------- |
| oct      | YES       | Symmetric keys                        |
| RSA      | YES       | RSA based asymmetric keys             |
| EC       | YES       | Elliptic Curves based asymmetric keys |
| OKP      | YES       | Octet Key Pair based asymmetric keys  |
| AKP      | YES       | Algorithm Key Pair (RFC 9964): the ML-DSA keys. `alg` is required, `pub` is the public key, `priv` the 32-byte seed. Since 4.3 |

JWK objects support JSON Web Key Thumbprint ([RFC 7638](https://tools.ietf.org/html/rfc7638)) and JWK Thumbprint URI ([RFC 9278](https://www.rfc-editor.org/rfc/rfc9278.html)).

!!! info

    A `none` key type is available for the `none` algorithm. It is used to explicitly allow this unsecured algorithm.

## Supported elliptic curves

| Key Type | Curve                              | Supported | Comment                                                                                          |
| -------- | ---------------------------------- | --------- | ------------------------------------------------------------------------------------------------ |
| EC       |P-256<br>P-384<br>P-521| YES       | ECDSA signatures (`ES256`/`ES384`/`ES512`) and `ECDH-ES*`/`ECDH-SS*` key agreement               |
| EC       | secp256k1                          | YES       | `ES256K` signatures (RFC 8812) and `ECDH-ES*`/`ECDH-SS*` key agreement                             |
| EC       |BP-256<br>BP-384<br>BP-512| YES  | Brainpool curves. `BP256R1`/`BP384R1`/`BP512R1` signatures are in the `Jose\Experimental` namespace |
| OKP      | Ed25519                            | YES       | `Ed25519` signatures (and the deprecated `EdDSA`). SODIUM extension, or OpenSSL on PHP 8.4+ |
| OKP      | X25519                             | YES       | `ECDH-ES*`/`ECDH-SS*` key agreement. SODIUM extension, or OpenSSL on PHP 8.4+ |
| OKP      | Ed448                              | YES       | `Ed448` signatures. PHP 8.4+ is required (OpenSSL) |
| OKP      | X448                               | YES       | `ECDH-ES*`/`ECDH-SS*` key agreement. PHP 8.4+ is required (OpenSSL) |

!!! warning

    The Brainpool curves are not registered with IANA, and neither are their signature algorithms. The identifiers follow the convention adopted by the other implementations, so keys and tokens using them are only interoperable with the implementations sharing that convention.

## Key sets (JWKSet)

JWKSet is fully supported.

## Supported signature algorithms

| Signature Algorithm                  | Supported | Comment                                                                                                    |
| ------------------------------------ | --------- | ---------------------------------------------------------------------------------------------------------- |
|HS256<br>HS384<br>HS512| YES       |                                                                                                            |
|ES256<br>ES384<br>ES512| YES       |                                                                                                            |
| ES256K                               | YES       | ECDSA over secp256k1 (RFC 8812). In the library since 4.3, in `Jose\Experimental` before                   |
|RS256<br>RS384<br>RS512| YES       |                                                                                                            |
|PS256<br>PS384<br>PS512| YES       | GMP or BCMath extension is highly recommended                           |
| Ed25519                              | YES       | SODIUM extension, or OpenSSL on PHP 8.4+. Fully-specified algorithm of RFC 9864, since 4.3 |
|ML-DSA-44<br>ML-DSA-65<br>ML-DSA-87| YES | Post-quantum (FIPS 204, RFC 9964). PHP 8.4+ and an OpenSSL 3.5+ runtime are required, see `MLDSA44::isSupported()`. Since 4.3 |
| Ed448                                | YES       | PHP 8.4+ is required (OpenSSL). Fully-specified algorithm of RFC 9864, since 4.3 |
| EdDSA with Ed25519 curve             | YES       | Deprecated by RFC 9864: use `Ed25519`. SODIUM extension, or OpenSSL on PHP 8.4+ |
| EdDSA with Ed448 curve               | NO        | Use `Ed448`                                                                                                |
| none                                 | YES       | **Not a secured algorithm. USE IT WITH CAUTION!** Shipped by `web-token/jwt-unsecured` |

!!! info

    Other signature algorithms like `RS1`, `HS1`, `HS256/64`, `BP256R1`, `BP384R1`, `BP512R1` and `Blake2b` are also available in the `Jose\Experimental` namespace. These algorithms should be used for testing purposes only or for compatibility with old systems.

## Supported key encryption algorithms

| Key Encryption Algorithm                                                      | Supported |                                                                                                                                                                  |
| ----------------------------------------------------------------------------- | --------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| dir                                                                           | YES       |                                                                                                                                                                  |
|RSA-OAEP<br>RSA-OAEP-256| YES       |GMP or BCMath extension is highly recommended<br><br><strong>Read note below!</strong>|
| RSA1_5                                                                        | YES       | <strong>Read note below!</strong> Shipped by `web-token/jwt-rsa15`                                                              |
|ECDH-ES<br>ECDH-ES+A128KW<br>ECDH-ES+A192KW<br>ECDH-ES+A256KW| YES       | `spomky-labs/aes-key-wrap` is required for \*KW algorithms. See the [supported curves](#supported-elliptic-curves)                                               |
|ECDH-SS<br>ECDH-SS+A128KW<br>ECDH-SS+A192KW<br>ECDH-SS+A256KW| YES       | `spomky-labs/aes-key-wrap` is required for \*KW algorithms. See the [supported curves](#supported-elliptic-curves)                                               |
|A128KW<br>A192KW<br>A256KW| YES       | `spomky-labs/aes-key-wrap` is required                                                                                                                           |
|PBES2-HS256+A128KW<br>PBES2-HS384+A192KW<br>PBES2-HS512+A256KW| YES       | `spomky-labs/aes-key-wrap` is required                                                                                                                           |
|A128GCMKW<br>A192GCMKW<br>A256GCMKW| YES       | `spomky-labs/aes-key-wrap` is required                                                                                                                           |
| ECDH-ES with X25519 curve                                                     | YES       | SODIUM extension, or OpenSSL on PHP 8.4+                                                                                                  |
| ECDH-ES with X448 curve                                                       | YES       | PHP 8.4+ is required (OpenSSL). Since 4.3                                                                                     |

!!! info

    Other key encryption algorithms like `RSA-OAEP-384`, `RSA-OAEP-512`, and `chacha20-poly1305` are also available in the `Jose\Experimental` namespace. These algorithms should be used for testing purposes only or for compatibility with old systems.

!!! danger

    The algorithms `RSA1_5` and `RSA-OAEP` are now deprecated. Please use with caution.

    Since 4.3, `RSA1_5` is shipped by the dedicated `web-token/jwt-rsa15` package and `none` by `web-token/jwt-unsecured`, so enabling either of them is an explicit decision recorded in your dependencies.

## Supported content encryption algorithms

| Content Encryption Algorithm                                 | Supported |
| ------------------------------------------------------------ | --------- |
|A128CBC-HS256<br>A192CBC-HS384<br>A256CBC-HS512| YES       |
|A128GCM<br>A192GCM<br>A256GCM| YES       |

!!! info

    Other content encryption algorithms like `A128CTR`, `A192CTR`, `A256CTR`, and various AES-CCM algorithms (e.g., `A128CCM-16-128`, `A256CCM-64-64`) are also available in the `Jose\Experimental` namespace. These algorithms should be used for testing purposes only or for compatibility with old systems.
