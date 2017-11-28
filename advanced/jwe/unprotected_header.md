Unprotected Header
==================

As well as the [signed tokens](../jws/unprotected_header.md), the encrypted tokens also have unprotected header.
But with one difference: there are two unprotected headers:

* Shared unprotected header applicable to all recipients.
* Per-recipient unprotected header.

With the example below, we will create an encrypted token for two recipient and some unprotected header parameters:

```php
$jwe = $jweBuilder
    ->create()
    ->withPayload('...')
    ->withSharedProtectedHeader(['enc' => 'A256GCM', 'alg' => 'A256KW'])
    ->withSharedHeader(['author' => 'John Doe'])
    ->addRecipient($recipient_public_key_1, ['message' => 'Hello World!'])
    ->addRecipient($recipient_public_key_2, ['description' => 'Nice song for you'])
    ->build();
```

The variable `$jwe` will be a valid JWE object built for two recipients.
The unprotected header parameter `author` is applicable to the whole token while `message` and `description` are available
only for the first and second recipient respectively.

**Note: when an unprotected header is set, the Compact Serialization mode is not available.**
