# From v4.1 to v4.2

This is a minor version upgrade. Most applications should upgrade without any code change.

Two behaviour changes may however affect you: the [disjoint header requirement](#stricter-header-validation-on-decryption) is now enforced when an encrypted token is read, and a key set no longer discards keys sharing the same `kid`. Both are described below.

## New Features

### Brainpool Curves

The `brainpoolP256r1`, `brainpoolP384r1` and `brainpoolP512r1` curves are now supported under the `BP-256`, `BP-384` and `BP-512` identifiers. They can be used for:

* ECDSA signatures, through the `BP256R1`, `BP384R1` and `BP512R1` algorithms,
* `ECDH-ES` and `ECDH-SS` key agreement,
* the PEM/JWK conversions, in both directions.

{% hint style="warning" %}
Neither the curves nor the signature algorithms are registered with IANA. The identifiers follow the convention already adopted by the other implementations (gematik, jwcrypto), which is why the signature algorithms live in the `Jose\Experimental\Signature` namespace, next to `ES256K`.
{% endhint %}

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\Component\KeyManagement\JWKFactory;
use Jose\Experimental\Signature\BP256R1;

$key = JWKFactory::createECKey('BP-256');

$algorithmManager = new AlgorithmManager([
    new BP256R1(),
]);
```

The signature algorithms are provided by the `web-token/jwt-experimental` package. The curves themselves are part of the core library: using them with `ECDH-ES` or `ECDH-SS` does not require the experimental package.

See [Signature Algorithms](../the-components/signed-tokens-jws/signature-algorithms.md) and [Key (JWK)](../the-components/key-jwk-and-key-set-jwkset/key-management.md) for details.

### PKCS#8 Conversion Command

The new `key:convert:pkcs8` command is the counterpart of `key:convert:pkcs1`. It converts a `RSA`, `EC` or `OKP` key into a PKCS#8 key, which is the only private key encoding some libraries are able to import, such as the npm `jose` package.

```bash
./jose.phar key:convert:pkcs8 '{"kty":"EC","crv":"P-256","d":"...","x":"...","y":"..."}'
```

As PKCS#8 only covers private keys, public keys are converted into a `SubjectPublicKeyInfo` structure. This also gives `OKP` keys their first JWK to PEM conversion.

See [Console](../console-command/console.md).

### Already Encoded Payloads

`JWSBuilder::withEncodedPayload()` takes a payload that is already Base64Url encoded, instead of forcing you to decode it just so the builder can encode it back.

```php
$jws = $jwsBuilder
    ->create()
    ->withEncodedPayload($base64UrlEncodedHash)
    ->addSignature($jwk, ['alg' => 'ES256'])
    ->build();
```

GNAP request signing is the case that asked for it: the payload there is the Base64Url encoded SHA-256 hash of the request body. Handing such a string to `withPayload()` encodes it twice and silently produces a token nobody expects.

The value is validated with the same strictness the `CompactSerializer` applies when it loads a token, so padding, characters outside the Base64Url alphabet, impossible lengths and non-canonical trailing bits are all rejected.

See [JWS Creation](../the-components/signed-tokens-jws/jws-creation.md).

### Failure Causes Are Now Chained

The loaders, the verifier, the decrypter and the serializer managers used to swallow the exception explaining why a token could not be used. The caller was left with a bare `Unable to load and verify the token.` and no previous exception.

The last error met along the way is now chained as the previous exception:

```php
try {
    $jws = $jwsLoader->loadAndVerifyWithKeySet($token, $jwkset, $signature);
} catch (Throwable $throwable) {
    // $throwable->getPrevious() now explains what actually went wrong.
}
```

`JWSVerifier` and `JWEDecrypter` cannot throw without changing their return semantics, so their per-key failures are reported through a callable accepted as an additional argument. See [JWS Loading](../the-components/signed-tokens-jws/jws-loading.md) and [JWE Loading](../the-components/encrypted-tokens-jwe/jwe-loading.md).

### brick/math 0.18 and 0.19

The framework now accepts `brick/math` 0.18 and 0.19, in addition to the previously supported versions.

## Behaviour Changes

### Stricter Header Validation On Decryption

[RFC 7516 section 7.2.1](https://datatracker.ietf.org/doc/html/rfc7516#section-7.2.1) requires the header parameter names of the three locations — shared protected header, shared unprotected header and per-recipient header — to be **disjoint**. That requirement was enforced when a token was written, but not when it was read.

`JWEDecrypter` merged the three headers with a last-wins strategy, so an unprotected header parameter was able to override an integrity protected one, `alg` and `enc` included: the `HeaderCheckerManager` validated the protected values while the decryption used the unprotected ones.

From 4.2:

* a token whose header parameter names are not disjoint is rejected,
* the protected header wins over the unprotected ones,
* `alg` and `enc` are no longer read from the shared unprotected header. The RFC puts no location constraint on them, but that header is not covered by the AAD and, unlike the per-recipient header, nothing requires those parameters to be located there.

As a consequence, tokens built like the [RFC 7520](https://datatracker.ietf.org/doc/html/rfc7520) sections 5.11 and 5.12 vectors are still parsed, but are no longer decrypted.

**What to do:** if a token of yours is now rejected, move `alg` and `enc` into the shared protected header — where they belong — and make sure a parameter is never repeated across two header locations.

`JWEBuilder` could itself produce a token violating that requirement: with several recipients, the header parameters computed by the key encryption algorithm were added to the per-recipient header without looking at the shared headers. A `PBES2` token carrying `p2c` in the shared protected header ended up with `p2c` in both places. Those parameters are now filtered, which is what the single recipient path already did.

### Duplicate Key IDs In A Key Set

`JWKSet` indexed its keys by `kid`, so two keys carrying the same one overwrote each other and the second silently won. [RFC 7517 section 4.5](https://datatracker.ietf.org/doc/html/rfc7517#section-4.5) explicitly allows a key set to hold several keys with the same `kid`, typically an RSA key and an EC key considered as equivalent alternatives by the application.

Keys carrying an already used `kid` are now appended to the key set instead of replacing the stored one:

```php
$jwkset = new JWKSet([$rsaKey, $ecKey]); // both with "kid" => "key-1"

count($jwkset);          // 2 in 4.2, was 1 before
$jwkset->get('key-1');   // still returns the first key registered with that ID
```

`get()`, `has()` and `without()` fall back to a scan so the extra keys stay reachable. `without('key-1')` removes **every** key carrying that ID.

**What to do:** nothing, unless your application relied on the deduplication. If you need one key per ID, deduplicate before building the key set. Note that `selectKey()` remains the recommended way to pick a key: it takes the usage and the algorithm into account, which is exactly what tells two same-`kid` keys apart.

## Deprecations

### The Hardcoded RSA1\_5 CEK Size Table

`RSA1_5` needs the size of the key expected by the content encryption algorithm to perform its implicit rejection ([GHSA-5739-39v2-5754](https://github.com/web-token/jwt-framework/security/advisories/GHSA-5739-39v2-5754)). It used to guess that size from a hardcoded table of content encryption algorithm names.

`JWEDecrypter` now passes the expected size — in bits — as an additional argument of `KeyEncryption::decryptKey()` and `KeyWrapping::unwrapKey()`. When the caller does not provide it, `RSA1_5` falls back to its table and triggers a deprecation notice.

That argument is **not** declared in the interfaces yet, as it would be a BC break for every implementation. Implementations that do not expect it simply ignore it, the others read it with `func_num_args()`/`func_get_arg(3)`.

**What to do:** if you maintain a [custom key encryption algorithm](../advanced-topics/custom-algorithm.md), start reading that fourth argument now. It will be added to the interfaces and become required in 5.0.

```php
public function decryptKey(JWK $key, string $encrypted_cek, array $header): string
{
    // The expected CEK size, in bits, or null when the caller does not provide it.
    $encryptionKeyLength = func_num_args() > 3 ? func_get_arg(3) : null;

    // ...
}
```

The value is the one returned by `ContentEncryptionAlgorithm::getCEKSize()`. See [Custom Algorithm](../advanced-topics/custom-algorithm.md#the-expected-cek-size).

## Bug Fixes Worth Knowing

These fixes need no action on your side, but they may explain an error you were seeing:

* **`Foreign payload encoding detected.` on unrelated builds.** `JWSBuilder::addSignature()` is documented as immutable but wrote the payload encoding on `$this` before cloning. As the Symfony Bundle registers the builder as a shared service, the first call using `b64` pinned the mode of that service for the rest of the process.
* **A sender key could not be used with `ECDH-SS`.** `JWEBuilder::withSenderKey()` derived the key management mode and checked the key against it, which failed whatever the call order was. The sender key does not add a recipient: it is now verified by `build()`, once the recipients and the content encryption algorithm are known. `JWEDecrypter::decryptUsingKey()` also passed the sender key as the output key parameter of `decryptUsingKeySet()`, so it never reached the algorithm.
* **Setting a shared header after a recipient raised a fatal `Error`.** `withSharedProtectedHeader()` and `withSharedHeader()` called `getHeader()` on the already registered recipients, but `addRecipient()` stores plain arrays. The duplicated header parameter check now runs as intended.
