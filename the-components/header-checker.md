# Header Checker

When you receive a JWT \(JWS or JWE\), it is important to check its headers before any other action. In case something went wrong, the token has to be rejected.

To use the header checker, install the corresponding component:

```bash
composer require web-token/jwt-checker
```

The header parameters are checked by a Header Checker Manager. This manager can contain several header checkers.

Please note that:

* the header parameter `crit` \(critical\) is always checked.
* even if the JWS and JWE Loaders will check the `alg`/`enc` header parameters, it is interesting to check them through this manager. 

## Header Checker Manager

To create a header checker manager, you will need to add header checkers and at least one token type. You will find token type classes for the JWS and JWE tokens in the `web-token/jwt-signature` and `web-token/jwt-encryption` components respectively.

In the following example, we want to check the `alg` header parameter for the signed tokens \(JWS\) received by our application.

```php
<?php

use Jose\Component\Checker\HeaderCheckerManager;
use Jose\Component\Checker\AlgorithmChecker;
use Jose\Component\Signature\JWSTokenSupport;

$headerCheckerManager = new HeaderCheckerManager(
    [
        new AlgorithmChecker(['HS256']), // We check the header "alg" (algorithm)
    ],
    [
        new JWSTokenSupport(), // Adds JWS token type support
    ]
);
```

The usage of this class is pretty easy you just have to call the `check` method. The first parameter is the JWT to check, the second one is the index of the signature/recipient.

```php
$headerCheckerManager->check($jwt, 0);
```

In some cases, it could be interesting to reject tokens that do not contain some mandatory header parameters. A list of mandatory parameters can be set as third argument. If one of those parameters is missing an exception is thrown, even if that header parameter have not been checked.

In the following example, an exception will be thrown if the `alg`, `enc` or `crit` parameters is missing.

```php
$headerCheckerManager->check($jwt, 0, ['alg', 'enc', 'crit']);
```

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

with the previous examples, we will only check the `alg` \(algorithm\) header parameter. But your application may use other header parameters e.g. `cty`, `typ`...

The following header checkers are provided:

* `AlgorithmChecker`: checks the `alg` header parameter.
* `AudienceChecker`: checks the `aud` header parameter. This is a replicated claim as per the [RFC7516 section 5.3](https://tools.ietf.org/html/rfc7519#section-5.3)
* `UnencodedPayloadChecker`: checks the `b64` header parameter. See [unencoded payload](../advanced-topics-1/signed-tokens-and/unencoded-payload.md) for more information.

If you need, you can create you own header checker. It must implement the interface `Jose\Component\Checker\HeaderChecker`. In the following example, we will check that the protected header parameter `custom` is an array with value `foo` or `bar`.

{% code title="Acme\\Checker\\CustomChecker.php" %}
```php
<?php

namespace Acme\Checker;

use Jose\Component\Checker\HeaderChecker;
use Jose\Component\Checker\InvalidHeaderException;

final class CustomChecker implements HeaderChecker
{
    public function checkHeader($value)
    {
        if (!is_array($value) || !in_array($value, ['foo', 'bar'])) {
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

