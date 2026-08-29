# From v4.2 to v4.3

This is a minor version upgrade: **your code keeps working**. Version 4.3 introduces no breaking change, but it is the version where 5.0 is prepared, so it carries a lot of deprecations. Each of them names its replacement, and the [summary table](#deprecation-summary) at the end lists them all.

Two algorithms move to their own packages. If your application enables `none` or `RSA1_5`, this is the only change that needs an entry in your `composer.json` — see [Dangerous algorithms](#dangerous-algorithms-move-to-their-own-packages).

Coming from an earlier version, read the previous guides first: [From v4.1 to v4.2](from-v4.1-to-v4.2.md), then [From v4.0 to v4.1](from-v4.0-to-v4.1.md).

## New Features

### Every Service Has An Interface

None of the main services was final and none of them had an interface: they could neither be relied upon as closed, nor be decorated.

Every service now implements an interface — `JWSBuilderInterface`, `JWSVerifierInterface`, `JWSLoaderInterface`, `JWEBuilderInterface`, `JWEDecrypterInterface`, `JWELoaderInterface`, `NestedTokenBuilderInterface`, `NestedTokenLoaderInterface`, `ClaimCheckerManagerInterface` and `HeaderCheckerManagerInterface` — and the library type-hints those interfaces internally, so a decorator can be injected anywhere a service is expected.

```php
<?php

use Jose\Component\Signature\JWSLoaderInterface;

final readonly class MyTokenReader
{
    public function __construct(
        private JWSLoaderInterface $jwsLoader, // Instead of the concrete JWSLoader
    ) {
    }
}
```

In the Symfony Bundle, each service is now aliased with its interface too, so `JWSBuilderInterface $myJwsBuilder` is autowired exactly as `JWSBuilder $myJwsBuilder` already was.

**Extending the concrete classes is deprecated.** They carry the `@final` annotation and their constructor raises a deprecation notice. Implement the interface or decorate the service instead.

### Result Objects Instead Of Output Parameters

The verifiers, the decrypters, the loaders and the serializer managers used to write their secondary results — the key that verified a signature, the index of the recipient that could be decrypted, the name of the serializer — into variables of the caller. Such methods cannot be called with named arguments, cannot be composed and are hard to type for static analysers.

Readonly result objects carry those values now:

| New method | Returns |
| ---------- | ------- |
| `JWSVerifier::verify()` | `VerificationResult` — `isVerified()`, `getSignatureIndex()`, `getKey()` |
| `JWEDecrypter::decrypt()` | `DecryptionResult` — `isDecrypted()`, `getJwe()`, `getRecipientIndex()`, `getKey()` |
| `JWSLoader::loadAndVerify()` | `LoadingResult` — `getJws()`, `getSignatureIndex()`, `getKey()` |
| `JWELoader::loadAndDecrypt()` | `LoadingResult` — `getJwe()`, `getRecipientIndex()`, `getKey()` |
| `NestedTokenLoader::loadAndVerify()` | `LoadingResult` |
| `JWSSerializerManager::unserializeToken()` | `UnserializationResult` — `getJws()`, `getSerializerName()` |
| `JWESerializerManager::unserializeToken()` | `UnserializationResult` — `getJwe()`, `getSerializerName()` |

**Before:**

```php
$jws = $jwsLoader->loadAndVerifyWithKeySet($token, $jwkset, $signature);
// $signature has been written into by the loader
```

**After:**

```php
$result = $jwsLoader->loadAndVerify($token, $jwkset);

$jws       = $result->getJws();
$signature = $result->getSignatureIndex();
$key       = $result->getKey();       // The key that verified the signature
```

The new methods accept a `JWK` **or** a `JWKSet`, so the `*WithKey()`/`*WithKeySet()` pairs collapse into one method. The callable that observes the keys discarded along the way — introduced in 4.2 and read with `func_get_arg()` until now — is a declared argument:

```php
$result = $jwsVerifier->verify($jws, $jwkset, 0, null, static function (Throwable $e): void {
    // Called for each key that could not verify the signature
});
```

`JWEDecrypter::decrypt()` also fixes a long standing oddity: it leaves the JWE it is given untouched and carries the decrypted one in the result, instead of writing the payload into the object by reference.

```php
$result = $jweDecrypter->decrypt($jwe, $jwkset, 0);

if ($result->isDecrypted()) {
    $payload = $result->getJwe()->getPayload(); // $jwe itself is unchanged
}
```

{% hint style="info" %}
The algorithm interfaces cannot change without breaking every third-party implementation, so 4.3 only documents the signature they will have in 5.0 and ships the objects they will return: `EncryptedContent` and `WrappedKey`.
{% endhint %}

### The Builders Are Really Immutable

The builders advertised an immutable `with*()` API they did not honour: they accumulated state on the receiver, which is why `create()` existed — not as a named constructor, but as a reset.

Every accumulation method now clones first and never touches the receiver, and every check spanning several calls is performed by `build()`, **so the order of the calls no longer matters**:

* `JWSBuilder::addSignature()` no longer pins the payload encoding on the receiver. The `b64` consistency checks are read from the signatures by `build()`.
* `JWEBuilder::addRecipient()` no longer resolves the key and content encryption algorithms. They are read from the complete header of each recipient by `build()`, so a recipient can be added *before* the shared headers carrying its `alg` and `enc`.
* The [disjoint header requirement](from-v4.1-to-v4.2.md#stricter-header-validation-on-decryption) of RFC 7516 is verified for the three headers by `build()`, whatever the order in which they were set.

As a consequence, a builder can be reused safely:

```php
$base = (new JWSBuilder($algorithmManager))->withPayload($payload);

$first  = $base->addSignature($key1, ['alg' => 'HS256'])->build();
$second = $base->addSignature($key2, ['alg' => 'RS256'])->build(); // $base is untouched
```

`create()` is deprecated: there is no state to reset any more. Remove the call.

### Immutable Managers

A manager expresses a policy — *these algorithms and no others* — so a consumer must not be able to widen it. `AlgorithmManager::add()` mutated a service that is usually shared; it is deprecated in favour of `with()`, which returns a new manager and leaves the current one untouched:

```php
$restricted = $algorithmManager->with(new ES256(), new ES384());
```

The state of the checker and serializer managers is now `readonly`, and both serializer managers are `readonly` classes.

### Typed Accessors On The JWK

Reading a parameter meant writing the same three steps every time: `has()`, then `get()`, then a type assertion, because `get()` returns an undeclared `mixed` and throws when the parameter is absent.

```php
$jwk->kty();             // string — always present
$jwk->alg();             // ?string — null when the key is not restricted to an algorithm
$jwk->use();             // ?string — null when the key is not restricted to a usage
$jwk->getString('kid');  // string — asserts the parameter is a string
$jwk->find('kid');       // mixed — null instead of throwing when absent
```

`JWK` and `JWKSet` announce that they become `final readonly` in 5.0. `JWKSet::sortKeys()` was public only because the comparison was passed to `usort()` as a callable; it is a closure now and calling the method is deprecated. Conversely, `getIterator()` lost the `@internal` annotation that wrongly told users not to iterate over a key set.

### The Key Factory Is An Injectable Service

`JWKFactory` was a bag of sixteen static methods, half of which reach for OpenSSL, for sodium or for the filesystem. Application code generating or loading keys could not be unit tested without any of them, and the factory could not be decorated to audit, cache or delegate the generation to a hardware backed implementation.

The behaviour now lives in instance methods behind `JWKFactoryInterface`. The names lose the `create` prefix, which was only there because the methods were static:

| Static method (deprecated) | Instance method |
| -------------------------- | --------------- |
| `JWKFactory::createRSAKey()` | `rsa()` |
| `JWKFactory::createECKey()` | `ec()` |
| `JWKFactory::createOctKey()` | `oct()` |
| `JWKFactory::createOKPKey()` | `okp()` |
| `JWKFactory::createNoneKey()` | `none()` |
| `JWKFactory::createFromJsonObject()` | `fromJsonObject()` |
| `JWKFactory::createFromValues()` | `fromValues()` |
| `JWKFactory::createFromSecret()` | `fromSecret()` |
| `JWKFactory::createFromCertificateFile()` | `fromCertificateFile()` |
| `JWKFactory::createFromCertificate()` | `fromCertificate()` |
| `JWKFactory::createFromX509Resource()` | `fromX509Resource()` |
| `JWKFactory::createFromX5C()` | `fromX5C()` |
| `JWKFactory::createFromKeyFile()` | `fromKeyFile()` |
| `JWKFactory::createFromKey()` | `fromKey()` |
| `JWKFactory::createFromPKCS12CertificateFile()` | `fromPKCS12CertificateFile()` |
| `JWKFactory::createFromKeySet()` | `fromKeySet()` |

```php
<?php

use Jose\Component\KeyManagement\JWKFactoryInterface;

final readonly class MyKeyProvider
{
    public function __construct(
        private JWKFactoryInterface $jwkFactory,
    ) {
    }

    public function newSigningKey(): JWK
    {
        return $this->jwkFactory->ec('P-256', ['use' => 'sig', 'alg' => 'ES256']);
    }
}
```

The bundle registers `JWKFactory` — it already did — and now aliases it with its interface, so `JWKFactoryInterface $factory` is autowired. The static methods keep working and delegate to a default instance.

### A JOSE Exception Hierarchy

Every exception thrown by the library implements the `Jose\Component\Core\Exception\JoseException` marker interface, so a single catch block handles any failure reported by the framework:

```php
<?php

use Jose\Component\Core\Exception\JoseException;

try {
    $result = $jwsLoader->loadAndVerify($token, $jwkset);
} catch (JoseException $throwable) {
    // The cause, when there is one, is available through $throwable->getPrevious()
}
```

**Each new exception extends the SPL class that was thrown at that place before**, hence the existing catch blocks keep matching. The Checker exceptions join the hierarchy as well.

Two failures gained a precise type: both loaders report a token that cannot be loaded with `InvalidTokenException`, where the JWS loader used to throw a bare `Exception` and the JWE loader a `RuntimeException`.

### Sealed Internal Mutators

`JWS::addSignature()` and `JWE::withPayload()` were public only because the objects are not built in one go — the first is what the builder and the serializers use to append a signature, the second is how the decrypter injects the plaintext it just authenticated. Both were reachable by anybody holding a token, so a JWS returned by a loader could gain a signature that was never verified, and the payload of a decrypted JWE could be replaced by an arbitrary value.

Calling either method from outside the library now raises a deprecation notice; they are removed in 5.0, where the objects are built by their constructor. A custom JWS serializer is a supported extension point and keeps working.

### JKUFactory And X5UFactory Stand On Their Own

`UrlKeySetFactory` is announced for removal in 5.0, yet `JKUFactory` and `X5UFactory` — the documented way to load a `jku` or a `x5u` key set, and not deprecated themselves — extended it.

The fetching code moved to an internal trait the two factories use, so **they no longer inherit anything from the deprecated class** and neither of them emits a deprecation. `UrlKeySetFactory` now says what is deprecated — itself, as a public extension point — and extending it raises a notice.

`enabledCache()`, deprecated by annotation since 4.1, raises the notice now and states its replacement: an HTTP client that caches the responses, which honours the cache directives of the endpoint where the fixed lifetime of a cache pool ignores them.

## Behaviour Changes

Nothing that requires a change in your code. Two points are worth knowing:

* **`JWEDecrypter::decrypt()` does not modify the JWE it receives.** The deprecated `decryptUsingKey()`/`decryptUsingKeySet()` still write the payload into the object passed by reference, so both behaviours coexist until 5.0.
* **The builders no longer depend on the order of the calls.** Sequences that used to fail — adding a recipient before the shared protected header carrying its `alg`, or reusing a shared builder service after a `b64` build — now succeed. Nothing that worked before stops working.

An unrelated misconfiguration is now reported early: passing an algorithm that is neither a key encryption nor a content encryption algorithm to `JWEBuilder` or `JWEDecrypter` is deprecated, where it used to turn into a much later *algorithm not supported* error.

## Dangerous Algorithms Move To Their Own Packages

The `none` signature algorithm and the `RSA1_5` key encryption algorithm are standard but dangerous: the first disables signature verification altogether, the second uses a padding vulnerable to the Bleichenbacher adaptive chosen-ciphertext attack. Both were shipped in the main library and were as easy to enable as any other algorithm.

They now live in two dedicated packages, so that using them is an explicit and auditable decision:

| Algorithm | Package | Class |
| --------- | ------- | ----- |
| `none` | `web-token/jwt-unsecured` | `Jose\Unsecured\Signature\None` |
| `RSA1_5` | `web-token/jwt-rsa15` | `Jose\Rsa15\KeyEncryption\RSA15` |

They are deliberately **not** moved to `web-token/jwt-experimental`: they are perfectly standard, and an application asking for `Blake2b` should not get `none` in the bargain.

The classes of the library are kept until 5.0 as empty deprecated subclasses of the new ones, so the migration is a `composer require` and a change of `use` statement:

```bash
composer require web-token/jwt-unsecured   # only if you use "none"
composer require web-token/jwt-rsa15       # only if you use "RSA1_5"
```

```diff
-use Jose\Component\Signature\Algorithm\None;
+use Jose\Unsecured\Signature\None;

-use Jose\Component\Encryption\Algorithm\KeyEncryption\RSA15;
+use Jose\Rsa15\KeyEncryption\RSA15;
```

The Symfony Bundle registers the classes of the new packages, so applications that never enable those algorithms are not flooded with a deprecation they cannot act on. The configuration aliases are unchanged: `none` and `RSA1_5` still name them.

{% hint style="warning" %}
If you are still using one of these two algorithms, take the opportunity to reconsider. See [Security Recommendations](../introduction/security-recommendations.md#avoid-weak-algorithms).
{% endhint %}

## Deprecation Summary

Everything below still works in 4.3 and is removed in 5.0.

### Services

| Deprecated | Replacement |
| ---------- | ----------- |
| `JWSBuilder::create()`, `JWEBuilder::create()` | Remove the call — the builders are immutable |
| Extending `JWSBuilder`, `JWSVerifier`, `JWSLoader`, `JWEBuilder`, `JWEDecrypter`, `JWELoader`, `NestedTokenBuilder`, `NestedTokenLoader`, `ClaimCheckerManager`, `HeaderCheckerManager` | Implement the matching interface, or decorate the service |
| `JWSVerifier::verifyWithKeySet()` | `verify()` |
| `JWEDecrypter::decryptUsingKey()`, `decryptUsingKeySet()` | `decrypt()` |
| `JWSLoader::loadAndVerifyWithKey()`, `loadAndVerifyWithKeySet()` | `loadAndVerify()` |
| `JWELoader::loadAndDecryptWithKey()`, `loadAndDecryptWithKeySet()` | `loadAndDecrypt()` |
| The `$signature` argument of `NestedTokenLoader::load()` | `loadAndVerify()` |
| The `$name` argument of `JWSSerializerManager::unserialize()` and `JWESerializerManager::unserialize()` | `unserializeToken()` |

`JWSVerifier::verifyWithKey()` is **not** deprecated: it takes a single key and returns a boolean, with no output parameter.

### Managers And Factories

| Deprecated | Replacement |
| ---------- | ----------- |
| `AlgorithmManager::add()` | `with()` |
| `JWSSerializerManagerFactory::names()`, `JWESerializerManagerFactory::names()` | `aliases()` |
| Passing a non-encryption algorithm to `JWEBuilder` or `JWEDecrypter` | Remove it from the algorithm manager |

### Keys

| Deprecated | Replacement |
| ---------- | ----------- |
| The sixteen static `JWKFactory::createXxx()` methods | Inject `JWKFactoryInterface` — see [the table above](#the-key-factory-is-an-injectable-service) |
| `JWKSet::sortKeys()` | None — it is an implementation detail of `selectKey()` |
| `UrlKeySetFactory::enabledCache()` | An HTTP client that caches the responses |
| Extending `UrlKeySetFactory` | `JKUFactory`, `X5UFactory`, or your own implementation |

### Tokens

| Deprecated | Replacement |
| ---------- | ----------- |
| `JWS::addSignature()` called from outside the library | `JWSBuilder` |
| `JWE::withPayload()` called from outside the library | `JWEDecrypter` |
| `new Signature($sig, $decodedProtectedHeader, null, ...)` | Pass the encoded protected header — the decoded one is silently discarded without it, and this throws in 5.0 |

### Algorithms

| Deprecated | Replacement |
| ---------- | ----------- |
| `Jose\Component\Signature\Algorithm\None` | `Jose\Unsecured\Signature\None` (`web-token/jwt-unsecured`) |
| `Jose\Component\Encryption\Algorithm\KeyEncryption\RSA15` | `Jose\Rsa15\KeyEncryption\RSA15` (`web-token/jwt-rsa15`) |
| The hardcoded `RSA1_5` CEK size table | Read the [expected CEK size](../advanced-topics/custom-algorithm.md#the-expected-cek-size) argument |

### Symfony Bundle

| Deprecated | Replacement |
| ---------- | ----------- |
| The inheritance based event dispatching services | The decorators registered under the same service ids — no configuration change needed |

The event dispatching verifier and decrypter of the bundle used to drop the callable the loaders pass to observe the discarded keys, so the reason of a failure was lost as soon as the bundle services were used. They forward it now, as the new decorators do.
