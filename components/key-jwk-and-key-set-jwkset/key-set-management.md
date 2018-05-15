# Key Set Management

A JWKSet object represents a key set. It can contain several keys. This object is provided by the `web-token/jwt-core` component.

You can create a JWKSet object using three static methods:

* `JWKSet::createFromKeys(array $keys)`: creates a JWKSet using a list of JWK objects.
* `JWKSet::createFromJson(string $json)`: creates a JWKSet using a JSON object.
* `JWKSet::createFromKeyData(array $values)`: creates a JWKSet using a decoded JSON object.

Hereafter all methods available for a JWKSet object. The variable `$jwkset` is a valid JWKSet object.

**Please note a JWKSet object is an immutable object**

```php
<?php
// Returns all keys
$jwkset->all();

// Check if the key set has the key with the key ID 'KEY ID'.
$jwkset->has('KEY ID');

// Retreive the key with the key ID 'KEY ID'.
$jwkset->get('KEY ID');

// Counts the keys in the key set.
$jwkset->count(); // The method count($jwkset) has the same behaviour.

// Adds a key to the key set.
// /!\ As the JWKSet object is immutable, this method will create a new key set. The previous key set is unchanged.
$new_jwkset = $jwkset->with($jwk);

// Removes a key to the key set.
// /!\ As the JWKSet object is immutable, this method will create a new key set. The previous key set is unchanged.
$new_jwkset = $jwkset->without('KEY ID');

// Selects a key according to the requirements.
// The first argument is the key usage ("sig" of "enc")
// The second argument is the algorithm to be used (optional)
// The third argument is an associative array this constraints (optional)
$key = $jwkset->selectKey('sig', $algorithm, ['kid' => 'KEY ID']);

// You can iterate on a key set
foreach($jwkset as $kid => $jwk) {
    // Action with the key done here
}

// The JWKSet object can be serialized into JSON
json_encode($jwkset);
```

_We recommend you to avoid mixing public, private or shared keys in the same key set_.

