# Claim Checker

## Claim Checker

JSON Web Tokens can be used to treansport any kind of data. They are mainly used to transport claims. When you receive a tokens that contains claims, it is important to check the values of these claims.

The Claim Checker Manager is responsible of this task. To use it, install the corresponding component:

```bash
composer require web-token/jwt-checker
```

## Claim Checker Manager

In the following example, we will create a manager able to check the `aud` \(Audience\), `iat` \(Issued At\), `nbf` \(Not Before\) and `exp` \(Expiration\) claims.

```php
<?php

use Jose\Component\Checker\ClaimCheckerManager;
use Jose\Component\Checker;

$claimCheckerManager = ClaimCheckerManager::create(
    [
        new Checker\IssuedAtChecker(),
        new Checker\NotBeforeChecker(),
        new Checker\ExpirationTimeChecker(),
        new Checker\AudienceChecker('Audience'),
    ]
);
```

When instantiated, call the method `check` to check the claims of a JWT object. This method only accept an array. You have to retrieve this array by converting the JWT payload.

```php
use Jose\Component\Core\Converter\StandardConverter;

$jsonConverter = new StandardConverter();

$claims = $jsonConverter->decode($jwt->getPayload());
$claimCheckerManager->check($claims);
```

In some cases, it could be interesting to reject tokens that do not contain some mandatory claims. A list of mandatory claims can be set as second argument. If one of those claims is missing an exception is thrown, even if the claim have not been checked.

In the following example, an exception will be thrown if the `iss`, `sub` or `aud` claim is missing.

```php
$claimCheckerManager->check($claims, ['iss', 'sub', 'aud']);
```

## Custom Claim Checker

Your application may use other claims that you will have to check therefore custom claim checkers have to be created.

In this example, we will create a class that will check the claim `foo`. The claim accept only a string with the value `bar` or `bat`. All claim checker have to implement the interface `Jose\Component\Checker\ClaimChecker`;

```php
<?php

declare(strict_types=1);

namespace Acme\Checker;

use Jose\Component\Checker\ClaimChecker;
use Jose\Component\Checker\InvalidClaimException;

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
            throw new InvalidClaimException('The claim "foo" must be a string.', 'foo', $value);
        }
        if (!in_array($value, ['bar', 'bat'])) { // Check if the value is allowed
            throw new InvalidClaimException('The claim "foo" must be "bar" or "bat".', 'foo', $value);
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

## Replicating Claims as Header Parameters

The [RFC7516 section 5.3](https://tools.ietf.org/html/rfc7519#section-5.3) allows to replicate some claims in the header. This behaviour is very useful with encrypted tokens as it helps to reject invalid tokens without decryption of the payload.

The Claim Checker Manager cannot check those replicated claims, you have to create a [custom header checker](header-checker.md). However, to avoid duplicated classes, your claim checker can implement the `Jose\Component\Checker\HeaderChecker` interface.

Have a look at the `IssuedAtChecker` or the `NotBeforeChecker` classes. These checkers can be used for claim and header checks.

## Claim Checker Manager Factory

Your application may use JSON Web Tokens in different contexts and thus the meaning of a claim may be different. You will need several Claim Checker Managers with dedicated claim checkers.

This framework provides an Claim Checker Manager Factory. This factory is able to accept as many claim checkers as you need. Each claim checker you add to this factory is associated to an alias. You will then be able to create a claim checker manager using those aliases.

```php
<?php

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

