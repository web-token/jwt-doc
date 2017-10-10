Symfony Integration
===================

To enable the commands on a Symfony application, you have to install and add the associated bundle into your kernel:

```sh
composer require web-token/jwt-console-bundle
```

```php
// app/AppKernel.php

class AppKernel extends Kernel
{
    public function registerBundles()
    {
        $bundles = [
            ...
            new Jose\Bundle\Console\ConsoleBundle(),
        ];

        return $bundles;
    }
    ...
}
```

And then execute the following command:

```sh
./bin/console
```
