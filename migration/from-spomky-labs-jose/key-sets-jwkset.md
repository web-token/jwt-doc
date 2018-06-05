# Key Sets \(JWKSet\)

As JWK, the JWKSet object is also part of the core component \(`web-token/jwt-core`\). The constructor also changed in favor of a static method.

You can now create a key set using three ways:

* Direct input of values \(as before\)
* A list of JWK objects
* A Json object string that represents a key set

Other important changes:

* The JWKSet object does not implement `\ArrayAccess` anymore. However, you still can iterate it \(e.g. using `foreach`\).
* The JWKSet is immutable. When you add a key, you will get a new object.
* The method `prependKey` has been removed.
* You can select a key using parameters \(key type, algorithm, key ID...\)

**Before**

```php
<?php

use Jose\Object\JWKSet;

$keyset = new JWKSet(['keys' => [
    '71ee230371d19630bc17fb90ccf20ae632ad8cf8' => [
        'kid' => '71ee230371d19630bc17fb90ccf20ae632ad8cf8',
        'kty' => 'RSA',
        'alg' => 'RS256',
        'use' => 'sig',
        'n' => 'vnMTRCMvsS04M1yaKR112aB8RxOkWHFixZO68wCRlVLxK4ugckXVD_Ebcq-kms1T2XpoWntVfBuX40r2GvcD9UsTFt_MZlgd1xyGwGV6U_tfQUll5mKxCPjr60h83LXKJ_zmLXIqkV8tAoIg78a5VRWoms_0Bn09DKT3-RBWFjk=',
        'e' => 'AQAB',
]]]);

json_encode($keyset); // The key as a Json object
$keyset->addKey(new JWK(['kty' => 'none'])); // Add a key
$keyset->removeKey(1); // Remove a key
$keyset->prependKey(new JWK(['kty' => 'none'])); // Prepend a key
$keyset[0]; // Access keys like arrays do
foreach ($keyset as $key) { // Iterate on a key set
    ...
}
```

**After**

```php
<?php

use Jose\Component\Core\JWKSet;

// Create using direct values
$keyset = JWKSet::createFromKeyData(['keys' => [
    '71ee230371d19630bc17fb90ccf20ae632ad8cf8' => [
        'kid' => '71ee230371d19630bc17fb90ccf20ae632ad8cf8',
        'kty' => 'RSA',
        'alg' => 'RS256',
        'use' => 'sig',
        'n' => 'vnMTRCMvsS04M1yaKR112aB8RxOkWHFixZO68wCRlVLxK4ugckXVD_Ebcq-kms1T2XpoWntVfBuX40r2GvcD9UsTFt_MZlgd1xyGwGV6U_tfQUll5mKxCPjr60h83LXKJ_zmLXIqkV8tAoIg78a5VRWoms_0Bn09DKT3-RBWFjk=',
        'e' => 'AQAB',
]]]);

// Create using a list of JWK objects
$keyset = JWKSet::createFromKeys([
    JWK::create(['kty' => 'none']),
]);

// Create from a JWKSet as a Json object
$keyset = JWKSet::createFromJson('{"keys":{"71ee230371d19630bc17fb90ccf20ae632ad8cf8":{"kid":"71ee230371d19630bc17fb90ccf20ae632ad8cf8","kty":"RSA","alg":"RS256","use":"sig","n":"vnMTRCMvsS04M1yaKR112aB8RxOkW...9DKT3-RBWFjk=","e":"AQAB"}}}');
$keyset->has('71ee230371d19630bc17fb90ccf20ae632ad8cf8'); // Indicates if a key with a key ID (string) or index (integer) is in the key set.
$keyset->get('71ee230371d19630bc17fb90ccf20ae632ad8cf8'); // Retrieve a key with a key ID (string) or index (integer).
$keyset->count(); // Number of keys in the key set.
count($keyset); // Number of keys in the key set.
$keyset->all(); // An array of keys.
$newKeyset = $keyset->with(JWK::create(['kty' => 'none'])); // Adds a key in the key set. The returned key set is a new object (immutability).
$newKeyset = $keyset->without(0); // Removes a key from the key set. The returned key set is a new object (immutability).
$keyset->selectKey('sig', new RS256(), ['kid' => '71ee230371d19630bc17fb90ccf20ae632ad8cf8']);
```

_About The Key Selector_

The key selector is able to find a key that fits on several requirements:

* First argument: key used either for signature \(`sig`\) or encryption \(`enc`\).
* Second argument: algorithm you would like to use. If the key has no `alg` parameter but the key type allowed by the algorithm matches, then the key may be selected.
* Third argument: an associated list of specific requirements. Can be any key parameter \(e.g. `kid` or custom parameter\).

The method returns the key that matches best otherwise `null`.

### Removed Classes

The following classes have been removed.

* `Jose\Object\JWKSets`
* `Jose\Object\PublicJWKSet`
* `Jose\Object\StorableJWKSet`
* `Jose\Object\RotatableJWKSet`
* `Jose\Object\JKUJWKSet`
* `Jose\Object\X5UJWKSet`

There is no replacement classes. The key set modification, rotation or the loading of distant keys \(JKU/X5U\) should now be done

* through the dedicated console/standalone application \([see this page](../../console/)\),
* using the `JWKFactory` or `JKUFactory`,
* using a custom key manager.

## Keys/Key Sets And The Symfony Bundle

### Env Var Processor

If you use Symfony 3.4+, you will be able to load a keys and key sets using an environment variable and process it:

```yaml
parameters:
    private_key_set: '%env(jwkset:PRIVATE_KEY_SET)'
    signature_key: '%env(jwk:SIGNATURE_KEY)'
```

It the environment variables are valid keys and key sets, the associated parameters will converted as a `JWK` or a `JWKSet` object.

```php
$container->getParameter('private_key_set'); // Will return a JWKSet object
```

These parameters can be injected a usual:

```php
<?php

declare(strict_types=1);

namespace AppBundle\Service;

use Jose\Component\Core\JWKSet;

final class Foo
{
    public function __construct(JWKSet $jwkset)
    {
        ...
    }
}
```

Associated service configuration:

```yaml
services:
    AppBundle\Service\Foo:
        arguments:
            - '%private_key_set%'
```

**Please note that, contrary to the keys and key sets loaded through the configuration or the Configuration Helper, the one loaded through an environment variable are not listed in the Symfony Debug Toolbar.**

### JKUFactory / X5UFactory

**Before**

```php
<?php

use Jose\Factory\JWKFactory;

$jwkset = JWKFactory::createFromJKU('https://www.googleapis.com/oauth2/v3/certs');
```

**After**

The use of this feature is drastically different. JKUFactory and X5UFactory are now services that relies on [HttPlug](http://docs.php-http.org/en/latest/) to get the key sets.

* Make sure the following dependencies are installed:
  * \(`web-token/jwt-bundle` and `web-token/jwt-key-mgmt`\) or `web-token/jwt-framework`
  * `php-http/httplug-bundle` and [at least one adapter](http://docs.php-http.org/en/latest/clients.html#clients-adapters) \(I will use `php-http/guzzle6-adapter` here\)

Do not forget to enable the associated bundles:

```php
new Http\HttplugBundle\HttplugBundle(),
new Jose\Bundle\JoseFramework\JoseFrameworkBundle(),
```

* Create a request factory service

```php
<?php
# app/AppBundle/Service/RequestFactory.php

namespace AppBundle\Service;

use GuzzleHttp\Psr7\Request;
use Http\Message\RequestFactory as Psr7RequestFactory;

final class RequestFactory implements Psr7RequestFactory
{
    /**
     * {@inheritdoc}
     */
    public function createRequest($method, $uri, array $headers = [], $body = null, $protocolVersion = '1.1')
    {
        return new Request($method, $uri, $headers, $body, $protocolVersion);
    }
}
```

```yaml
services:
    AppBundle\Service\RequestFactory: ~
```

* Configure the bundles:

```yaml
jose:
    jku_factory:
        enabled: true # We enable the JKU factory
        client: 'httplug.client.my_client' # We indicate the Httplug client to use
        request_factory: 'AppBundle\Service\RequestFactory' # See hereafter the corresponding class

httplug:
    plugins:
        cache: # We use the cache plugin
            cache_pool: 'cache.app' # We use the PSR-6 Cache service of the application
            config:
                default_ttl: 1800 # TTL set to 30 min
    clients:
        my_client: # Our client based on Guzzle 6. The corresponding service will be `httplug.client.my_client`
            factory: 'httplug.factory.guzzle6'
            plugins: ['httplug.plugin.cache'] # We enable the cache plugin for that client
```

When done, there are two possibilities to load JKU/X5U key sets:

* Inject the `Jose\Component\KeyManagement\JKUFactory` or `Jose\Component\KeyManagement\X5UFactory` and call the `loadFromUrl` method:

```php
use Jose\Component\Core\JWKSet;
use Jose\Component\KeyManagement\JKUFactory;

class MyClass
{
    private $jkuFactory;

    public function __construct(JKUFactory $jkuFactory)
    {
        $this->client = $client;
        $this->jkuFactory= $jkuFactory;
    }

    public function getKeySet(): JWKSet
    {
        return $this->jkuFactory->loadFromUrl($url);
    }
}
```

* Configure a key set in the bundle configuration

```yaml
jose:
    keys:
        microsoft_keys:
            jku:
                url: 'https://login.microsoftonline.com/common/discovery/keys'
```

The associated service will be `jose.key_set.microsoft_keys`.

