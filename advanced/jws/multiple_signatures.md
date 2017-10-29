Multiple Signatures
===================

When you need to sign the same payload for several audiences, you may want to do it at once.
The JWS Builder supports multiple signatures.

With the example below, we will create three signatures using three different algorithms (and signature keys):

```php
$jws = $jwsBuilder
    ->create()
    ->withPayload('...')
    ->addSignature($signature_key1, ['alg' => 'HS256'])
    ->addSignature($signature_key2, ['alg' => 'RS384'])
    ->addSignature($signature_key3, ['alg' => 'ES512'])
    ->build();
```

The variable `$jws` will be a valid JWS object with all computed signatures.
Next step is the serialization of these signatures.

```php
use Jose\Component\Core\Converter\JsonConverter;
use Jose\Component\Signature\Serializer;

// The JSON Converter.
$jsonConverter = new JsonConverter();

$manager = Serializer\JWSSerializerManager::create([
    new Serializer\CompactSerializer($jsonConverter),
    new Serializer\JsonFlattenedSerializer($jsonConverter),
    new Serializer\JsonGeneralSerializer($jsonConverter),
]);

$tokenWithAllSignatures = $manager->serialize('jws_json_general', $jws);
$compactTokenWithSignatureAtIndex1 = $manager->serialize('jws_compact', $jws, 1);
$flattenedTokenWithSignatureAtIndex2 = $manager->serialize('jws_json_flattened', $jws, 2);
```
