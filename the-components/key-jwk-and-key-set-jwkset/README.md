# Key \(JWK\) and Key Set \(JWKSet\)

To perform cryptographic operations \(signature/verification and encryption/decryption\), you will need keys.

The `JWK` object is part of the `web-token/jwt-core` component:

```bash
composer require web-token/jwt-core
```

## JWK

A JWK object represents a key. It contains all parameters needed by the algorithm and also information parameters.

This framework is able to create private and public keys easily. It can also generate those keys from external resources.

## JWKSet

The keys can be grouped in key sets. A `JWKSet` object represents a key set. It can contain as many keys as you need.

{% hint style="warning" %}
We strongly recommend you to avoid mixing public, private or shared keys in the same key set.
{% endhint %}

