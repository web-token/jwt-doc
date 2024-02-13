# Algorithm Management (JWA)

For each cryptographic operation, you will need at least one algorithm and one key.

The algorithm list depends on the cypher operation to be performed (signature or encryption).

These algorithms are managed by an **Algorithm Manager**. In the following example, we will create an algorithm manager that will handle two algorithms: `PS256` and `ES512`.

The algorithm management is part of the `web-token/jwt-core` component. **The signature algorithms are available in dedicated packages**. See [signature](signed-tokens-jws/signature-algorithms.md) or [encryption](encrypted-tokens-jwe/encryption-algorithms.md) algorithm pages for more information.

```bash
composer require web-token/jwt-core
```

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\Signature\Algorithm\PS256;
use Jose\Component\Signature\Algorithm\ES512;

$algorithmManager = new AlgorithmManager([
    new PS256(),
    new ES512(),
]);
```

{% hint style="warning" %}
It is not possible to set the same algorithm twice in the same algorithm manager.
{% endhint %}

## Algorithm Manager Factory

Your application may need several algorithm managers for several use cases. For example you application may use JWT for:

* signed events,
* authentication tokens.

To avoid mixing algorithms in one algorithm manager or instantiate several times the same algorithms, this framework provides an **Algorithm Manager Factory**.

This factory will create algorithm managers on demand. It allows the same algorithm to be instantiated multiple times but with different configuration options.

Each algorithm is identified using an alias.

```php
<?php

use Jose\Component\Core\AlgorithmManagerFactory;
use Jose\Component\Signature\Algorithm\PS256;
use Jose\Component\Encryption\Algorithm\KeyEncryption\PBES2HS512A256KW;
use Jose\Component\Encryption\Algorithm\ContentEncryption\A128CBCHS256;

$algorithmManagerFactory = new AlgorithmManagerFactory();
$algorithmManagerFactory 
    ->add('PS256', new PS256())
    ->add('A128CBC-HS256', new A128CBCHS256())
    ->add('PBES2-HS512+A256KW', new PBES2HS512A256KW())
    ->add('PBES2-HS512+A256KW with custom configuration', new PBES2HS512A256KW(128, 8192))
;
```

The first argument of the method `add` is the alias for the algorithm. **It must be unique**. In general, this alias corresponds to the algorithm name.

As you can see in the example, we added the algorithm `PBES2-HS512+A256KW` twice:

* with the default configuration,
* &#x20;with custom arguments.

Now our algorithm manager factory is ready. We can create several algorithm managers by passing a list of aliases to the method `create`:

```php
<?php

$signatureAlgorithmManager = $algorithmManagerFactory ->create(['PS256']);
$encryptionAlgorithmManager = $algorithmManagerFactory ->create(['A128CBC-HS256', 'PBES2-HS512+A256KW']);
$encryptionAlgorithmManagerForParanoid = $algorithmManagerFactory ->create(['A128CBC-HS256', 'PBES2-HS512+A256KW with custom configuration']);
```

