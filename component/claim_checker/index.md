Claim Checker
=============

JSON Web Tokens are mainly used to transport claims.
When you receive a JWT, it is important to check the values of these claims.

The Claim Checker Manager is responsible of this task.

# Claim Checker Manager

In the following example, we will create a manager able to check the `aud` (Audience), `iat` (Issued At), `nbf` (Not Before) and `exp` (Expiration) claims.

```php
<?php

require_once 'vendor/autoload.php';

use Jose\Component\Checker\ClaimCheckerManager;
use Jose\Component\Core\Converter\JsonConverter;
use Jose\Component\Checker;

$jsonConverter = new JsonConverter();
$claimCheckerManager = ClaimCheckerManager::create(
    [
        new Checker\IssuedAtChecker(),
        new Checker\NotBeforeChecker(),
        new Checker\ExpirationTimeChecker(),
        new Checker\AudienceChecker('Audience'),
    ]
);
```

When instantiated, call the method `check` to check the claims of a JWT object.
This method only accept an array. You have to retrieve this array by converting the JWT payload.

```php
$claims = json_decode($jwt->getPayload, true);
$claimCheckerManager->check($claims);
```

# Custom Claim Checker

Your application may use other claims that you will have to check therefore custom claim checkers have to be created.

In this example, we will create a class that will check the claim `foo`.
The claim accept only a string with the value `bar` or `bat`.
All claim checker have to implement the interface `Jose\Component\Checker\ClaimCheckerInterface`;

```php
<?php

declare(strict_types=1);

namespace Acme\Checker;

use Jose\Component\Checker\ClaimCheckerInterface;

/**
 * Class FooChecker.
 */
final class FooChecker implements ClaimCheckerInterface
{
    /**
     * {@inheritdoc}
     */
    public function checkClaim($value)
    {
        if (!is_string($value)) { // If the value is not a string, then we throw an exception
            throw new \InvalidArgumentException('The claim "foo" must be a string.');
        }
        if (!in_array($value, ['bar', 'bat'])) { // Check if the value is allowed
            throw new \InvalidArgumentException('The claim "foo" must be "bar" or "bat".');
        }
    }

    /**
     * {@inheritdoc}
     */
    public function supportedClaim(): string
    {
        return 'foo'; //The claim to check.
    }
}
```

All done! Now you can instantiate your class and add it to your Claim Checker Manager.

# Replicating Claims as Header Parameters

The [RFC7516 section 5.3](https://tools.ietf.org/html/rfc7519#section-5.3) allows to replicate some claims in the header.
This behaviour is very useful with encrypted tokens as it helps to reject invalid tokens without decryption of the payload.

The Claim Checker Manager cannot check those replicated claims, you have to create a [custom header checker](../header_checker/index.md).
However, to avoid duplicated classes, your claim checker can implement the `Jose\Component\Checker\HeaderCheckerInterface` interface.

Have a look at the `IssuedAtChecker` or the `NotBeforeChecker` classes.
These checkers can be used for claim and header checks.

# Claim Checker Manager Factory

Your application may use JSON Web Tokens in different contexts and thus the meaning of a claim may be different.
You will need several Claim Checker Managers with dedicated claim checkers.

This framework provides an Claim Checker Manager Factory. This factory is able to accept as many claim checkers as you need.
Each claim checker you add to this factory is associated to an alias. You will then be able to create a claim checker manager using those aliases.

```php
<?php

require_once 'vendor/autoload.php';

use Jose\Component\Checker\ClaimCheckerManagerFactory;
use Jose\Component\Checker;

$claimCheckerManagerFactory = new ClaimCheckerManagerFactory();
$claimCheckerManagerFactory
    ->add('iat', new Checker\IssuedAtChecker())
    ->add('nbf', new Checker\NotBeforeChecker())
    ->add('exp', new Checker\ExpirationTimeChecker())
    ->add('aud1', new Checker\AudienceChecker('Audience for service #1'))
    ->add('aud2', new Checker\AudienceChecker('Audience for service #2'));

$claimCheckerManager1 = $claimCheckerManagerFactory->create(['iat', 'exp', 'aud2']);
$claimCheckerManager2 = $claimCheckerManagerFactory->create(['aud1', 'exp']);
```
