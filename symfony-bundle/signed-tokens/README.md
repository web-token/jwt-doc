# Signed Tokens

To use the signed tokens \(JWS\), you have to install the [`web-token/jwt-signature` component](https://github.com/web-token/jwt-signature).

```bash
composer require web-token/jwt-signature
```

When this component is installed, signature algorithms are automatically handles by the Algorithm Manager Factory.

* [JWS serializers](jws-serializers.md),
* [JWS creation](jws-creation.md),
* [JWS verification](jws-verification.md).

New in version 1.3: you can use `symfony/serializer` to serialize/unserialize your tokens:

```php
// $serializer corresponds to the Symfony serializer
$serializer->serialize($data, 'jws_compact');
```

