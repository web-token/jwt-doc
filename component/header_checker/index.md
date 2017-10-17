Header Checker
==============

When you receive a JWT (JWS or JWE), the loader will check the header of the token.
In case something when wrong, the token is rejected.

To use this component, install the corresponding component:

```sh
composer require web-token/jwt-checker
```

The header parameters are checked by a Header Checker Manager.
This manager can contain several header checkers.

Please note that:

* the header parameter `crit` (critical) is always checked.
* even if the JWS and JWE Loaders wil check the `alg`/`enc` header parameters, it is interesting to check them through this manager. 
* you are not suppose to use this component directly. The JWS and JWE Loaders will do the job for you.

# Header Checker Manager

To create a header checker manager, you will need to add header checkers and at least one token type.
You will find token type classes for the  JWS and JWE tokens in the `web-token/jwt-signature` and `web-token/jwt-encryption` components respectively.

```php
<?php

require_once 'vendor/autoload.php';

use Jose\Component\Checker\HeaderCheckerManager;
use Jose\Component\Checker\AlgorithmChecker;
use Jose\Component\Encryption\JWETokenSupport;
use Jose\Component\Signature\JWSTokenSupport;

$headerCheckerManager = HeaderCheckerManager::create(
    [
        new AlgorithmChecker(['HS256']), // We check the header "alg" (algorithm)
    ],
    [
        new JWSTokenSupport(), // Adds JWS token type support
        new JWETokenSupport(), // Adds JWE token type support
    ]
);
```

# Header Checker Manager Factory

The Header Checker Manager Factory will help you to create as many Header Checker Manager as you want to fit on your application requirements.

```php
<?php

require_once 'vendor/autoload.php';

use Jose\Component\Checker\HeaderCheckerManagerFactory;
use Jose\Component\Checker\AlgorithmChecker;
use Jose\Component\Encryption\JWETokenSupport;
use Jose\Component\Signature\JWSTokenSupport;

$headerCheckerManagerFactory = new HeaderCheckerManagerFactory();
$headerCheckerManagerFactory
    ->add('signature_alg', new AlgorithmChecker(['HS256']))
    ->add('key_encryption_alg', new AlgorithmChecker(['RSA1_5']))
    ->addTokenTypeSupport(new JWSTokenSupport())
    ->addTokenTypeSupport(new JWETokenSupport());

$headerCheckerManagerForSignatures = $headerCheckerManagerFactory->create(['signature_alg']);
$headerCheckerManagerForEncryption = $headerCheckerManagerFactory->create(['key_encryption_alg']);
```

# Custom Header Checker

with the previous examples, we will only check the `alg` (algorithm) header parameter.
But your application may use other header parameters.

The following header checkers are provided:

* `AlgorithmChecker`: you already know it
* `AudienceChecker`: checks the `aud` header parameter. This is a replicated claim as per the [RFC7516 section 5.3](https://tools.ietf.org/html/rfc7519#section-5.3)
* `UnencodedPayloadChecker`: checks the `b64` hheader parameter. See [unencoded payload](../../advanced/jws/unencoded_payload.md) for more information.

If you need, you can create you own header checker. It must implement the interface `Jose\Component\Checker\HeaderCheckerInterface`.
In the following example, we will check that the protected header parameter `custom` is an array with value `foo` or `bar`.

```php
<?php

namespace Acme\Checker;

use Jose\Component\Checker\HeaderCheckerInterface;

/**
 * Class CustomChecker.
 */
final class CustomChecker implements HeaderCheckerInterface
{
    public function checkHeader($value)
    {
        if (!is_array($value) || !in_array($value, ['foo', 'baar'])) {
            throw new \InvalidArgumentException('Invalid header "custom".');
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
