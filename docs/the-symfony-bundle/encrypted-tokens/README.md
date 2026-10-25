# Encrypted Tokens

Encryption algorithms are automatically handled by the Algorithm Manager Factory.

* [JWE serializers](jwe-serializers.md),
* [JWE creation](jwe-creation.md),
* [JWE decryption](jwe-decryption.md).

You can use `symfony/serializer` to serialize/unserialize your tokens:

```php
// $serializer corresponds to the Symfony serializer
$serializer->serialize($data, 'jwe_compact');
```
