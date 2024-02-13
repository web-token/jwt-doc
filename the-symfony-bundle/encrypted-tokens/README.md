# Encrypted Tokens

To use the encrypted tokens (JWE), you have to install the [`web-token/jwt-encryption` component](https://github.com/web-token/jwt-encryption).

```bash
composer require web-token/jwt-encryption
```

When this component is installed, encryption algorithms are automatically handles by the Algorithm Manager Factory.

* [JWE serializers](jwe-serializers.md),
* [JWE creation](jwe-creation.md),
* [JWE decryption](jwe-decryption.md).

You can use `symfony/serializer` to serialize/unserialize your tokens:

```php
// $serializer corresponds to the Symfony serializer
$serializer->serialize($data, 'jwe_compact');
```
