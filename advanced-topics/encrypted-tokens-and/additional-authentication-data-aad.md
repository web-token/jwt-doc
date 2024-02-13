# Additional Authentication Data (AAD)

The Additional Authenticated Data (AAD) is an input to an Authenticated Encryption operation. The AAD is integrity protected but not encrypted.

Its value can be any string you want that is needed by your application. With the example below, we will add a dummy AAD:

```php
$jwe = $jweBuilder
    ->create()
    ->withPayload('...')
    ->withSharedProtectedHeader([
        'enc' => 'A256CBC-HS512',
        'alg' => 'RSA-OAEP-256',
        'zip' => 'DEF',
    ])
    ->addRecipient($recipient_key)
    ->withAAD('A,B,C,D')
    ->build();
```

**Note: when the AAD is set, the Compact Serialization mode is not available.**
