# Key \(JWK\) and Key Set \(JWKSet\)

To perform cryptographic operations \(signature/verification and encryption/decryption\), you will need keys. The keys can be grouped in key sets.

The `JWK` and `JWKSet` objects are part of the `web-token/jwt-core` component:

```bash
composer require web-token/jwt-core
```

## JWK

A JWK object represents a key. It contains all parameters needed by the algorithm and also information parameters.

This framework is able to create private and public keys easily. It can also generate those keys from external resources.

Read [this section](key-management.md) to know how to create your keys.

## JWKSet

A JWKSet object represents a key set. It can contain several keys.

_We recommend you to avoid mixing public, private or shared keys in the same key set_.

Please refer to [this page](key-set-management.md) to know how to create and use the key sets.

