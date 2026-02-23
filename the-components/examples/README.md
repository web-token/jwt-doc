# Examples

This section provides practical, copy-paste ready examples for common JWT operations. Each example is self-contained and can be run as-is after installing the library.

```bash
composer require web-token/jwt-library
```

{% hint style="info" %}
These examples use the **standalone PHP API** (no framework). If you use Symfony, refer to the [Symfony Bundle](../../the-symfony-bundle/symfony-bundle.md) section for a more integrated approach.
{% endhint %}

## Available Examples

* [Signed Tokens (JWS)](signed-tokens.md) — Create and verify signed JWTs using HMAC, RSA, and Elliptic Curve algorithms.
* [Encrypted Tokens (JWE)](encrypted-tokens.md) — Encrypt and decrypt JWTs using RSA-OAEP, ECDH-ES, and password-based encryption.
* [Claim and Header Validation](validation.md) — Validate token claims (`exp`, `iss`, `aud`, etc.) and headers after signature verification or decryption.
