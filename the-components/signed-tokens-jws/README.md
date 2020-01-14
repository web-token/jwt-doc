# Signed Tokens \(JWS\)

To use the signed tokens \(JWS\), you have to install the [`web-token/jwt-signature` component](https://github.com/web-token/jwt-signature).

```bash
composer require web-token/jwt-signature
```

This component provides lot of signature algorithms and classes to load and create signed tokens.

Please refer to [this signature algorithm table](signature-algorithms.md) to know what algorithms are available.

Then, you will find an [example to create a signed token here](jws-creation.md) and another [example to load and verify](jws-loading.md) incoming tokens.

