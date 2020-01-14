# Header and Claim Checker Management

## Checker Manager Factory Services

The Symfony Bundle provides Header and Claim Checker Manager Factory services. These services are available when the `web-token/jwt-checker` component is installed:

```bash
composer require web-token/jwt-checker
```

```php
<?php

use Jose\Component\Checker\HeaderCheckerManagerFactory;
use Jose\Component\Checker\ClaimCheckerManagerFactory;

$headerCheckerManagerFactory = $container->get(HeaderCheckerManagerFactory::class);
$headerCheckerManager = $headerCheckerManagerFactory->create([...]);

$claimCheckerManagerFactory = $container->get(ClaimCheckerManagerFactory::class);
$claimCheckerManager = $claimCheckerManagerFactory->create([...]);
```

## Checker Manager Services

You can create Header and Claim Checker Managers using the bundle configuration.

```yaml
jose:
    checkers:
        claims:
            checker1:
                is_public: true
                claims: [...]
        headers:
            checker1:
                is_public: true
                headers: [...]
```

With the previous configuration, the bundle will create public Header and Claim Checker Managers named `jose.header_checker.checker1` and `jose.claim_checker.checker1` with selected checkers.

## Custom Header Or Claim Checker

Some claim or header checkers are provided by this framework, but it is important to create custom checkers that fit on your application requirements.

In the following example, we will assume that the class exist and implement either `Jose\Component\Checker\HeaderChecker` or `Jose\Component\Checker\ClaimChecker`.

```yaml
services
    Acme\Checker\CustomHeaderChecker:
        public: false
        tags:
            - { name: 'jose.checker.header', alias: 'foo' }
    Acme\Checker\CustomClaimChecker:
        public: false
        tags:
            - { name: 'jose.checker.claim', alias: 'bar' }
```

These checkers will be loaded by the factories and you will be able to create a header or a claim checker manager using the aliases `foo` or `bar`.

## Custom Tags

You can add custom tags and attributes to the header and claim checker managers.

```yaml
jose:
    checkers:
        claims:
            checker1:
                claims: [...]
                tags:
                    tag_name1: ~
                    tag_name2: {attribute1: 'foo'}
```

