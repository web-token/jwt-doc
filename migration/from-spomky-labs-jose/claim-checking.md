# Claim Checking

The claim checker manager is part of the checker component \(`web-token/jwt-checker`\).

`spomky-labs/jose` and this framework works a similar way thus migration is very easy. The main differences are:

* There are two managers: one for the claims, one for the headers.
* The manager only accepts an associative array. Conversion from a string to that array have to be done.

Checkers must implement the `Jose\Component\Checker\ClaimChecker` interface.

**Before**

```php
<?php

use Jose\Checker\CheckerManager;
use Jose\Checker\ExpirationTimeChecker;
use Jose\Checker\IssuedAtChecker;
use Jose\Checker\NotBeforeChecker;

$checkerManager = new CheckerManager();
$checkerManager->addClaimChecker(new ExpirationTimeChecker());
$checkerManager->addClaimChecker(new IssuedAtChecker());
$checkerManager->addClaimChecker(new NotBeforeChecker());

$checkerManager->checkJWS($jws, $signature_index);
```

**After**

```php
<?php

use Jose\Component\Checker\ClaimCheckerManager;
use Jose\Component\Checker\ExpirationTimeChecker;
use Jose\Component\Checker\IssuedAtChecker;
use Jose\Component\Checker\NotBeforeChecker;

$claimCheckerManager = new ClaimCheckerManager();
$claimCheckerManager->add(new ExpirationTimeChecker());
$claimCheckerManager->add(new IssuedAtChecker());
$claimCheckerManager->add(new NotBeforeChecker());

$claimCheckerManager->check($claims);
```

