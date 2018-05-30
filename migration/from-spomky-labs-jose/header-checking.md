# Header Checking

The header checker manager is part of the checker component \(`web-token/jwt-checker`\).

`spomky-labs/jose` and this framework works a similar way thus migration is very easy. The main differences are:

* There are two managers: one for the claims, one for the headers.
* The manager needs at least one Token Support handler.

You will find `JWS` and `JWE` Token Supports in the `web-token/jwt-signature` and `web-token/jwt-encryption` components respectively.

Checkers must implement the `Jose\Component\Checker\HeaderChecker` interface.

**Before**

```php
<?php

use Jose\Checker\CheckerManager;
use Jose\Checker\AudienceChecker;
use Jose\Checker\CriticalHeaderChecker;

$checkerManager = new CheckerManager();
$checkerManager->addHeaderChecker(new AudienceChecker('My Server'));
$checkerManager->addHeaderChecker(new CriticalHeaderChecker());

$checkerManager->checkJWS($jws, $signature_index);
```

**After**

```php
<?php

use Jose\Component\Checker\AudienceChecker;
use Jose\Component\Checker\HeaderCheckerManager;
use Jose\Component\Signature\JWSTokenSupport;

$checkerManager = new HeaderCheckerManager();
$checkerManager->add(new AudienceChecker('My Service'));
$checkerManager->addTokenTypeSupport(new TokenSupport());
```

_Please note that the header_ `crit` _is always checked._

