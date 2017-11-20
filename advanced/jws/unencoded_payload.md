Unencoded Payload
=================

The [RFC7797](https://tools.ietf.org/html/rfc7797) allows the use of an unencoded payload for the signed tokens.
This behaviour is interesting when your tokens have a detached payload and may reduce the token computation.

Please note that when the Compact Serialization mode is used, the characters of the payload must be limited to the following ASCII ranges:

* From `0x20` to `0x2d`
* From `0x2f` to `0x7e`

This feature is built in the framework and is enabled when the `b64` header parameter is set to `false`.
As per the RFC, this header MUST be protected and also listed as a critical (`crit`) header parameter.

Example:

```php
$jws = $jwsBuilder
    ->create()
    ->withPayload('Hello World!')
    ->addSignature($jwk, ['alg' => 'HS256', 'b64' => false, 'crit' => ['b64']])
    ->build();
```

*As a remainder, both `b64` and `crit` parameters MUST be in the protected header.*
