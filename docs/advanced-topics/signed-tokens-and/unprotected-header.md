# Unprotected Header

You may want to set data in a token header that are not important for your application (e.g. general information). The integrity protection of the data is therefore not needed at all.

The [RFC7515](https://tools.ietf.org/html/rfc7515) introduces an unprotected header. This header is supported by this framework.

With the example below, we will create a signed token with some unprotected header parameters:

```php
$jws = $jwsBuilder
    ->create()
    ->withPayload('...')
    ->addSignature($jwk, ['alg' => 'HS256'], ['description' => 'Small description here', 'author' => 'John Doe'])
    ->build();
```

The variable `$jws` will be a valid JWS object with one signature and both headers.

**Note: when an unprotected header is set, the Compact Serialization mode is not available.**
