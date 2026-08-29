# Unprotected Headers

As well as the [signed tokens](../signed-tokens/unprotected-header.md), the encrypted tokens also have unprotected header. But with one difference: there are two unprotected headers:

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

The variable `$jwe` will be a valid JWE object built for two recipients. The unprotected header parameter `author` is applicable to the whole token while `message` and `description` are available only for the first and second recipient respectively.

**Note: when an unprotected header is set, the Compact Serialization mode is not available.**

## Disjoint Header Parameters

[RFC 7516 section 7.2.1](https://datatracker.ietf.org/doc/html/rfc7516#section-7.2.1) requires the header parameter names of the three locations to be **disjoint**: a given parameter must appear in exactly one of them. The builder refuses to produce such a token, and since 4.2 the `JWEDecrypter` refuses to read one.

Keep in mind that only the shared **protected** header is covered by the AAD:

* put `alg`, `enc` and anything a recipient must be able to trust in the shared protected header. `alg` and `enc` are never read from the shared unprotected header;
* keep the unprotected headers for the informational parameters, like the `author`, `message` and `description` of the example above.

