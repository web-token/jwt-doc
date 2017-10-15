Key Sets Management (JWKSet)
============================

A JWKSet object represents a key set. It can contain several keys.

```php
<?php
use Jose\Component\Core\JWKSet;

$jwkset = JWKSet::createFromKeys([
    $jwk1,
    $jwk2,
    $jwk3,
]);
```

*We recommend you to avoid mixing public, private or shared keys in the same key set*.

In the following examples, we have a `$jwkset` variable that is a valid key set. Available methods:

```php
<?php
// Returns all keys
$jwkset->all();

// Check if the key set has the key with the key ID 'KEY ID'.
$jwkset->has('KEY ID');

// Retreive the key with the key ID 'KEY ID'.
$jwkset->get('KEY ID');

// Counts the keys in the key set.
$jwkset->count();

// Adds a key to the key set.
// /!\ This method will create a new key set. The previous key set is unchanged.
$new_jwkset = $jwkset->with($jwk);

// Removes a key to the key set.
// /!\ This method will create a new key set. The previous key set is unchanged.
$new_jwkset = $jwkset->without('KEY ID');

// Selects a key according to the requirements.
// The first argument is the key usage ("sig" of "enc")
// The second argument is the algorithm to be used (optional)
// The third argument is an associative array this constraints (optional)
$key = $jwkset->selectKey('sig', $algorithm, ['kid' => 'KEY ID']);
```
