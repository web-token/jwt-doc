Symfony Integration
===================

To enable the commands on a Symfony application, you have to install and add the associated bundle into your kernel:

```sh
composer require web-token/jwt-console-bundle
```

If you use Symfony Flex, you have nothing to do. Otherwise you have to enable to bundle.
You also have to check that the JWT framework Bundle is also enabled

```php
// app/AppKernel.php

class AppKernel extends Kernel
{
    public function registerBundles()
    {
        $bundles = [
            ...
            new Jose\Bundle\JwtFramework\JwtFrameworkBundle(),
            new Jose\Bundle\Console\ConsoleBundle(),
        ];

        return $bundles;
    }
    ...
}
```

Then execute your Symfony Console command to use the command provided by this component:

```sh
./bin/console
```
