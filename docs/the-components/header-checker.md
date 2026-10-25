# Header checker

When you receive a JWT (JWS or JWE), it is important to check **ALL** header parameters **BEFORE** any other action. In case something goes wrong, the token should be rejected.

!!! warning

    This is a strong recommendation as there are known vulnerabilities on tokens that are processed without header verification.

!!! info

    Please note that some algorithms may use additional header parameters. Please read carefully the details on the [signature](signed-tokens-jws/signature-algorithms.md) or [encryption](encrypted-tokens-jwe/encryption-algorithms.md) algorithms page.

The header parameters are checked by a Header Checker Manager. This manager can contain several header checkers.

!!! success

    The header parameter `crit` (critical) is always checked.

!!! info

    Even if the cryptographic process will check the `alg`/`enc` header parameters, it is useful to check them beforehand to reject invalid tokens earlier.&#x20;

## Header checker manager

To create a header checker manager, you will need to add header checkers and at least one token type.&#x20;

In the following example, we want to check the `alg` header parameter for the signed tokens (JWS) received by our application.

```php
<?php

use Jose\Component\Checker\HeaderCheckerManager;
use Jose\Component\Checker\AlgorithmChecker;
use Jose\Component\Signature\JWSTokenSupport;

$headerCheckerManager = new HeaderCheckerManager(
    [
        new AlgorithmChecker(['HS256']),
        // We want to verify that the header "alg" (algorithm)
        // is present and contains "HS256"
    ],
    [
        new JWSTokenSupport(), // Adds JWS token type support
    ]
);
```

You can then call the `check` method.

* The first parameter is the JWT to check,
* The second one is the index of the signature/recipient. It could be ignored if you are not using the Flattened or General JSON Serialization Modes.

```php
$headerCheckerManager->check($jwt, 0);
```

In some cases, it could be interesting to reject tokens that do not contain some mandatory header parameters. A list of mandatory parameters can be set as third argument. If one of those parameters is missing, an exception is thrown even if that header parameter has not been checked.

In the following example, an exception will be thrown if the `alg`, `enc` or `crit` parameter is missing.

```php
$headerCheckerManager->check($jwt, 0, ['alg', 'enc', 'crit']);
```

!!! info

    Since 4.3, the manager implements `HeaderCheckerManagerInterface`. Type-hint the interface rather than the concrete class: it is what the loaders expect, and it lets you decorate the manager. Extending `HeaderCheckerManager` is deprecated.

## Provided header checker objects

The library provides several header checker classes you can instantiate and use at will. They are all located in the namespace `Jose\Component\Checker`.

!!! info

    For time-based parameter checker classes, a PSR-20 clock object is mandatory.

| Class | Header | Time-based |
|---|---|---|
| AlgorithmChecker | `alg` | No |
| TypeChecker | `typ`<br>Explicit typing, see [below](#explicit-typing-with-the-typ-header). Since 4.3. | No |
| AudienceChecker | `aud`<br>This is a replicated claim as per the [RFC7516 section 5.3](https://tools.ietf.org/html/rfc7519#section-5.3) | No |
| ExpirationTimeChecker | `exp` | **Yes** |
| IssuedAtChecker | `iat` | **Yes** |
| IssuerChecker | `iss` | No |
| NotBeforeChecker | `nbf` | **Yes** |
| UnencodedPayloadChecker | `b64`<br>See [unencoded payload](../advanced-topics/signed-tokens/unencoded-payload.md) for more information. | No |
| CallableChecker | Generic object that can execute a callable for checking a particular parameter | No |
| IsEqualChecker | Generic object that can compare a particular parameter to a predefined value | No |

## Explicit typing with the `typ` header

The `typ` header names the profile of the token: `at+jwt` for an OAuth 2.0 access token ([RFC 9068](https://www.rfc-editor.org/rfc/rfc9068.html)), `dpop+jwt` for a DPoP proof ([RFC 9449](https://www.rfc-editor.org/rfc/rfc9449.html)), `secevent+jwt` for a security event token ([RFC 8417](https://www.rfc-editor.org/rfc/rfc8417.html)), `logout+jwt` for an OpenID Connect back-channel logout token, and so on. [RFC 8725 section 3.11](https://www.rfc-editor.org/rfc/rfc8725.html#section-3.11) recommends that a verifier accepts only the profile it expects: a token issued for one purpose can then not be replayed for another one, even when it is signed by the same key.

The `TypeChecker` implements this recommendation. It takes the accepted media type(s) and rejects any other value.

```php
<?php

use Jose\Component\Checker\HeaderCheckerManager;
use Jose\Component\Checker\AlgorithmChecker;
use Jose\Component\Checker\TypeChecker;
use Jose\Component\Signature\JWSTokenSupport;

$headerCheckerManager = new HeaderCheckerManager(
    [
        new AlgorithmChecker(['ES256'], true),
        new TypeChecker(['at+jwt']), // Or several types: ['at+jwt', 'dpop+jwt']
    ],
    [
        new JWSTokenSupport(),
    ]
);

$headerCheckerManager->check($jwt, 0, ['alg', 'typ']);
```

The comparison follows [RFC 7515 section 4.1.9](https://www.rfc-editor.org/rfc/rfc7515.html#section-4.1.9): media types are case-insensitive and the `application/` prefix is optional, so `at+jwt`, `AT+JWT` and `application/at+jwt` are the same type. You do not need to list the variants.

!!! warning

    The checker only reads the **protected** header. A `typ` set in the unprotected header of a JSON serialized token is rejected, as the guarantee relies on the value being integrity protected.

    Like every other checker, it does nothing when the header is absent. List `typ` in the mandatory header parameters (third argument of `check()`) to reject tokens that do not declare their type.

### Securing a verifier

RFC 8725 lists the checks a verifier performs before trusting a token. With this library, they translate to:

1. an `AlgorithmChecker` restricted to the algorithm(s) your application expects, reading the protected header only (second argument `true`);
2. a `TypeChecker` restricted to the profile your application expects;
3. `alg` and `typ` listed as mandatory header parameters, so a token that omits one of them is rejected;
4. a [Claim Checker Manager](claim-checker.md) that verifies at least `exp`, `iss` and `aud`, with `exp`, `iss` and `aud` listed as mandatory claims.

## Header checker manager factory

The Header Checker Manager Factory will help you create as many Header Checker Managers as you need to fit your application requirements.

```php
<?php

use Jose\Component\Checker\HeaderCheckerManagerFactory;
use Jose\Component\Checker\AlgorithmChecker;
use Jose\Component\Encryption\JWETokenSupport;
use Jose\Component\Signature\JWSTokenSupport;

$headerCheckerManagerFactory = new HeaderCheckerManagerFactory();
$headerCheckerManagerFactory->add('signature_alg', new AlgorithmChecker(['HS256']));
$headerCheckerManagerFactory->add('key_encryption_alg', new AlgorithmChecker(['RSA-OAEP-256']));
$headerCheckerManagerFactory->addTokenTypeSupport(new JWSTokenSupport());
$headerCheckerManagerFactory->addTokenTypeSupport(new JWETokenSupport());

$headerCheckerManagerForSignatures = $headerCheckerManagerFactory->create(['signature_alg']);
$headerCheckerManagerForEncryption = $headerCheckerManagerFactory->create(['key_encryption_alg']);
```

## Custom header checker

With the previous examples, we will only check the `alg` (algorithm) and `typ` (type) header parameters. But your application may use other header parameters e.g. `cty`, `kid`...

If you need, you can create your own header checker. It must implement the interface `Jose\Component\Checker\HeaderChecker`. In the following example, we will check that the protected header parameter `custom` is an array with value `foo` or `bar`.

```php title="Acme\Checker\CustomChecker.php"
<?php

namespace Acme\Checker;

use Jose\Component\Checker\HeaderChecker;
use Jose\Component\Checker\InvalidHeaderException;

final class CustomChecker implements HeaderChecker
{
    public function checkHeader($value)
    {
        if (!is_array($value) || !in_array($value, ['foo', 'bar'], true)) {
            throw new InvalidHeaderException('Invalid header "custom".', 'custom', $value);
        }
    }

    // This header parameter name.
    public function supportedHeader(): string
    {
        return 'custom';
    }

    // This method indicates if this parameter must be in the protected header or not.
    public function protectedHeaderOnly(): bool
    {
        return true;
    }
}
```

## Custom token type support

A header checker manager reads the headers of a token through a **token type support**: `JWSTokenSupport` knows how to read a JWS, `JWETokenSupport` a JWE. If your application carries tokens in another shape, implement `Jose\Component\Checker\TokenTypeSupport` and register it with `addTokenTypeSupport()`, as the factory example above does.

```php
public function supports(JWT $jwt): bool;

public function retrieveTokenHeaders(
    JWT $jwt,
    int $index,                 // The signature or recipient index
    array &$protectedHeader,
    array &$unprotectedHeader
): void;
```

The `$index` matters with the JSON General serialization mode, which allows several signatures or recipients. For a JWE, the unprotected header is the shared unprotected header merged with the header of the selected recipient.

!!! warning

    `retrieveTokenHeaders()` is the last public interface of the library built on output parameters. In 5.0 it returns a `Jose\Component\Checker\TokenHeaders` object and the two `array &$header` parameters are removed:

    ```php
    public function retrieveTokenHeaders(JWT $jwt, int $index): TokenHeaders;
    ```

    Nothing changes in 4.3 — the interface is untouched — but the object already ships, so an implementation can be prepared today:

    ```php
    return new TokenHeaders($protectedHeader, $unprotectedHeader);
    ```

    A support given a token it does not handle returns an object carrying two empty headers, which is what it does today by leaving the two output parameters untouched.

