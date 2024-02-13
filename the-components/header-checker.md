# Header Checker

When you receive a JWT (JWS or JWE), it is important to check **ALL** headers parameters **BEFORE** any other action. In case something went wrong, the token should be rejected.

{% hint style="warning" %}
This is a strong recommendation are there are known vulnerabilities on tokens that are processed without header verification.
{% endhint %}

{% hint style="info" %}
Please note that some algorithms may use additional header parameters. Please read carefully the details on the [signature](signed-tokens-jws/signature-algorithms.md) or [encryption](encrypted-tokens-jwe/encryption-algorithms.md) algorithms page.
{% endhint %}

To use the header checker, install the corresponding component:

```bash
composer require web-token/jwt-checker
```

The header parameters are checked by a Header Checker Manager. This manager can contain several header checkers.

{% hint style="success" %}
The header parameter `crit` (critical) is always checked.
{% endhint %}

{% hint style="info" %}
Even if the cypher process will check the `alg`/`enc` header parameters, it is interesting to check them before to reject tokens earlier.&#x20;
{% endhint %}

## Header Checker Manager

To create a header checker manager, you will need to add header checkers and at least one token type. You will find token type classes for the JWS and JWE tokens in the `web-token/jwt-signature` and `web-token/jwt-encryption` components respectively.

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

In some cases, it could be interesting to reject tokens that do not contain some mandatory header parameters. A list of mandatory parameters can be set as third argument. If one of those parameters is missing an exception is thrown, even if that header parameter have not been checked.

In the following example, an exception will be thrown if the `alg`, `enc` or `crit` parameters is missing.

```php
$headerCheckerManager->check($jwt, 0, ['alg', 'enc', 'crit']);
```

## Provided Header Checker Objects

The library provides several header checker classes you can instantiate and use at will. They are all located in the namespace `Jose\Component\Checker`.

<table><thead><tr><th width="296">Class</th><th width="314">Header</th><th>Time-based</th></tr></thead><tbody><tr><td>AlgorithmChecker</td><td><code>alg</code></td><td>No</td></tr><tr><td>AudienceChecker</td><td><code>aud</code></td><td>No</td></tr><tr><td>ExpirationTimeChecker</td><td><code>exp</code></td><td>Yes</td></tr><tr><td>IssuedAtChecker</td><td><code>iat</code></td><td>Yes</td></tr><tr><td>IssuerChecker</td><td><code>iss</code></td><td>No</td></tr><tr><td>NotBeforeChecker</td><td><code>nbf</code></td><td>Yes</td></tr><tr><td>UnencodedPayloadChecker</td><td><code>b64</code></td><td>No</td></tr><tr><td>CallableChecker</td><td>Generic object that can execute a callable for checking a particular parameter</td><td>No</td></tr><tr><td>IsEqualChecker</td><td>Generic object that can compare a particular parameter to a predefined value</td><td>No</td></tr></tbody></table>

{% hint style="info" %}
For time-based parameter checker classes, a PSR-20 clock object can be used and will be mandatory for 4.0+. This service is required for obtaining the current time or manipulating it in test environments.
{% endhint %}

## Header Checker Manager Factory

The Header Checker Manager Factory will help you to create as many Header Checker Manager as you want to fit on your application requirements.

```php
<?php

use Jose\Component\Checker\HeaderCheckerManagerFactory;
use Jose\Component\Checker\AlgorithmChecker;
use Jose\Component\Encryption\JWETokenSupport;
use Jose\Component\Signature\JWSTokenSupport;

$headerCheckerManagerFactory = new HeaderCheckerManagerFactory();
$headerCheckerManagerFactory->add('signature_alg', new AlgorithmChecker(['HS256']));
$headerCheckerManagerFactory->add('key_encryption_alg', new AlgorithmChecker(['RSA1_5']));
$headerCheckerManagerFactory->addTokenTypeSupport(new JWSTokenSupport());
$headerCheckerManagerFactory->addTokenTypeSupport(new JWETokenSupport());

$headerCheckerManagerForSignatures = $headerCheckerManagerFactory->create(['signature_alg']);
$headerCheckerManagerForEncryption = $headerCheckerManagerFactory->create(['key_encryption_alg']);
```

## Custom Header Checker

With the previous examples, we will only check the `alg` (algorithm) header parameter. But your application may use other header parameters e.g. `cty`, `typ`...

The following header checkers are provided:

* `AlgorithmChecker`: checks the `alg` header parameter.
* `AudienceChecker`: checks the `aud` header parameter. This is a replicated claim as per the [RFC7516 section 5.3](https://tools.ietf.org/html/rfc7519#section-5.3)
* `UnencodedPayloadChecker`: checks the `b64` header parameter. See [unencoded payload](../advanced-topics/signed-tokens-and/unencoded-payload.md) for more information.

If you need, you can create you own header checker. It must implement the interface `Jose\Component\Checker\HeaderChecker`. In the following example, we will check that the protected header parameter `custom` is an array with value `foo` or `bar`.

{% code title="Acme\Checker\CustomChecker.php" %}
```php
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
{% endcode %}
