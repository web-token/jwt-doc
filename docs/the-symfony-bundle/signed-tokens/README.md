# Signed Tokens

Signature algorithms are automatically handled by the Algorithm Manager Factory.

* [JWS serializers](jws-serializers.md),
* [JWS creation](jws-creation.md),
* [JWS verification](jws-verification.md).

You can use `symfony/serializer` to serialize/unserialize your tokens:

```php
// $serializer corresponds to the Symfony serializer
$serializer->serialize($data, 'jws_compact');
```
