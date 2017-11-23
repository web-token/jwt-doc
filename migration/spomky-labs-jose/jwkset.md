Key Set (JWKSet) Migration
==========================

As JWK, the JWKSet object is also part of the core component (`web-token/jwt-core`).
The constructor also changed in favor of a static method.

You can now create a key set using three ways:

* Direct input of values (as before)
* A list of JWK objects
* A Json object string that represents a key set

Other important changes:

* The JWKSet object does not implement `\ArrayAccess` anymore. However, you still can iterate it (e.g. using `foreach`).
* The JWKSet is immutable. When you add a key, you will get a new object.
* The method `prependKey` has been removed.
* You can select a key using parameters (key type, algorithm, key ID...)

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

*About The Key Selector*

The key selector is able to find a key that fits on several requirements:

* First argument: key used either for signature (`sig`) or encryption (`enc`).
* Second argument: algorithm you would like to use. If the key has no `alg` parameter but the key type allowed by the algorithm matches, then the key may be selected.
* Third argument: an associated list of specific requirements. Can be any key parameter (e.g. `kid` or custom parameter).

The method returns the key that matches best otherwise `null`.

Removed Classes
---------------

The following classes have been removed.

* `Jose\Object\JWKSets`
* `Jose\Object\PublicJWKSet`
* `Jose\Object\StorableJWKSet`
* `Jose\Object\RotatableJWKSet`
* `Jose\Object\JKUJWKSet`
* `Jose\Object\X5UJWKSet`

There is no replacement classes. The key set modification, rotation or the loading of distant keys (JKU/X5U) should now be done

* using the `JWKFactory` or `JKUFactory`,
* through the dedicated console application ([see this page](../../console/index.md)),
* using a custom key manager.
