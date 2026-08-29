# Key Set (JWKSet)

You can create a JWKSet object using three static methods:

* `new JWKSet(array $keys)`: creates a JWKSet using a list of JWK objects.
* `JWKSet::createFromJson(string $json)`: creates a JWKSet using a JSON object.
* `JWKSet::createFromKeyData(array $values)`: creates a JWKSet using a decoded JSON object.

Below are all methods available for a JWKSet object. The variable `$jwkset` is a valid JWKSet object.

{% hint style="warning" %}
Please note a JWKSet object is an immutable object. When you add keys, you get a new JWKSet object.
{% endhint %}

```php
<?php
// Returns all keys
$jwkset->all();

// Check if the key set has the key with the key ID 'KEY ID'.
$jwkset->has('KEY ID');

// Retrieve the key with the key ID 'KEY ID'.
$jwkset->get('KEY ID');

// Counts the keys in the key set.
$jwkset->count(); // The method count($jwkset) has the same behaviour.

// Adds a key to the key set.
// /!\ As the JWKSet object is immutable, this method will create a new key set. The previous key set is unchanged.
$newJwkset = $jwkset->with($jwk);

// Removes a key from the key set.
// /!\ As the JWKSet object is immutable, this method will create a new key set. The previous key set is unchanged.
$newJwkset = $jwkset->without('KEY ID');

// Selects a key according to the requirements.
// The first argument is the key usage ("sig" or "enc")
// The second argument is the algorithm to be used (optional)
// The third argument is an associative array of constraints (optional)
$key = $jwkset->selectKey('sig', $algorithm, ['kid' => 'KEY ID']);

// You can iterate on a key set
foreach($jwkset as $kid => $jwk) {
    // Action with the key done here
}

// The JWKSet object can be serialized into JSON
json_encode($jwkset);
```

## Duplicate Key IDs

[RFC 7517 section 4.5](https://datatracker.ietf.org/doc/html/rfc7517#section-4.5) explicitly allows a key set to hold several keys sharing the same `kid`, typically an RSA key and an EC key that the application considers as equivalent alternatives.

Such keys are all kept:

```php
<?php

use Jose\Component\Core\JWKSet;

// Both keys carry "kid" => "key-1"
$jwkset = new JWKSet([$rsaKey, $ecKey]);

count($jwkset);        // 2
$jwkset->get('key-1'); // The first key registered with that ID
```

* `get()` and `has()` look the key ID up and return the first key carrying it.
* `without('key-1')` removes **every** key carrying that ID.

{% hint style="info" %}
When several keys share a `kid`, prefer `selectKey()` over `get()`: it also takes the key usage and the algorithm into account, which is precisely what tells those keys apart.
{% endhint %}

{% hint style="warning" %}
Before 4.2, the keys were indexed by `kid` and the last key registered with a given ID silently replaced the previous one. See the [migration guide](../../migration/from-v4.1-to-v4.2.md#duplicate-key-ids-in-a-key-set).
{% endhint %}

## Sealed Helpers

Two methods carried an `@internal` annotation that did not match what they are:

* `sortKeys()` was public only because the comparison was passed to `usort()` as a callable. It is a closure now, nothing in the library calls the method any more, and calling it is deprecated since 4.3.
* `getIterator()` carried the same annotation although it is the `IteratorAggregate` contract, which wrongly told users not to iterate over a key set. Iterating is supported, as the example above shows.

{% hint style="info" %}
`JWK` and `JWKSet` become `final readonly` in 5.0. If you extend either of them, move to composition now.
{% endhint %}
