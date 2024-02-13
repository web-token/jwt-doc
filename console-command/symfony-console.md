# Symfony Console

To enable the commands on a Symfony application, you have to install and add the associated bundle into your kernel:

```bash
composer require web-token/jwt-console
composer require web-token/jwt-bundle
```

If you use Symfony Flex, you have nothing to do. Otherwise you have to enable to bundle.

```php
// app/AppKernel.php

class AppKernel extends Kernel
{
    public function registerBundles()
    {
        $bundles = [
            ...
            new Jose\Bundle\JwtFramework\JwtFrameworkBundle(),
        ];

        return $bundles;
    }
    ...
}
```

Then execute your Symfony Console command to use the command provided by this component:

```bash
./bin/console
```
