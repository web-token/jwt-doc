Keys And Key Sets Management (JWK and JWKSet)
=============================================

To perform cryptographic operations (signature/verification and encryption/decryption), you will need an algorithm and keys or key sets.

The `JWK` and `JWKSet` objects are part of the `web-token/jwt-core` component:

```sh
composer require web-token/jwt-core
```
# JWK

A JWK object represents a key. It contains all parameters needed by the algorithm and also information parameters.

This framework is able to create private and public keys easily.
It can also generate those keys from external resources.

Read [this section](jwk.md) to know how to create your keys.

# JWKSet

A JWKSet object represents a key set. It can contain several keys.

*We recommend you to avoid mixing public, private or shared keys in the same key set*.

Please refer to [this page](jwkset.md) to know how to create and use the key sets.
