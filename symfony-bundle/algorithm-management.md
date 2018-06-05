# Algorithm Management

## Algorithm Manager Factory Service

The Symfony Bundle provides an Algorithm Manager Factory service. The available algorithms depends on the components installed on your application.

```php
<?php

use Jose\Component\Core\AlgorithmManagerFactory;

$algorithmManagerFactory = $container->get(AlgorithmManagerFactory::class);
$algorithmManager = $algorithmManagerFactory->create(['RS256', 'HS512']);
```

## Custom Algorithm

This factory handles all algorithms services tagged with `jose.algorithm`.

Example:

```yaml
services:
    Acme\Bundle\Algorithm\FooAlgorihtm:
        tags:
            - {'name': 'jose.algorithm', 'alias': 'FOO'}
```

Your algorithm will be available through the algorithm manager factory service and the alias `FOO`.

## PBES2-\* Algorithms

When installed, the `PBES2-*` algorithms available throught the algorithm manager factory. They have the default configuration i.e. salt size = 62 bits and count = 4096. If these values does not fit on your needs, you can create a new algorithm service with your own values:

```yaml
services:
    Jose\Component\Encryption\Algorithm\KeyEncryption\PBES2HS256A128KW:
        arguments:
            - 128   # salt size
            - 10240 # counts
        tags:
            - {'name': 'jose.algorithm', 'alias': 'Ultra-Secured PBES2-HS256+A128KW'}
```

You can now use your custom alias:

```php
$algorithmManager = $algorithmManagerFactory->create(['Ultra-Secured PBES2-HS256+A128KW']);
```

