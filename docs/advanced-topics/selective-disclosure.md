# Selective Disclosure (SD-JWT)

[RFC 9901](https://www.rfc-editor.org/rfc/rfc9901.html) defines Selective Disclosure for JWTs. The Issuer replaces the claims it wants to make selectively disclosable by salted digests, signs the result and hands the Holder the signed JWT together with the *Disclosures*, the salted claims themselves. The Holder later presents the signed JWT with the Disclosures of the claims it chooses to reveal, optionally bound to its own key by a *Key Binding JWT*. The Verifier checks the signature, recomputes the digests of the presented Disclosures and gets back the claims that were disclosed, and only those.

SD-JWT is the credential format of SD-JWT VC, of the EU Digital Identity Wallet and of OpenID for Verifiable Credentials. This page describes the three roles of the RFC as the `web-token/jwt-selective-disclosure` package implements them, in the `Jose\SelectiveDisclosure` namespace. It is available since 4.3.

The package is not part of `web-token/jwt-library`, on which it depends: SD-JWT is a layer on top of the JWS services, installed when it is needed.

```sh
composer require web-token/jwt-selective-disclosure
```

Both formats of the RFC are supported: the compact format,

```
<Issuer-signed JWT>~<Disclosure 1>~...~<Disclosure N>~[<Key Binding JWT>]
```

and the [JWS JSON serialization](#jws-json-serialization) of section 8.

!!! note

    The profiles built on top of SD-JWT, such as SD-JWT VC (`dc+sd-jwt`, `vct`, status lists) and the OpenID for Verifiable Credentials flows, are left to the application.

## Issuing an SD-JWT

The `SDJWTIssuer` signs the SD-JWT with a `JWSBuilder`, hence with any signature algorithm and any protected header. The claims that are selectively disclosable are wrapped in a `Disclosable`:

```php
<?php

use Jose\Component\Core\AlgorithmManager;
use Jose\SelectiveDisclosure\Disclosable;
use Jose\SelectiveDisclosure\SDJWTIssuer;
use Jose\Component\Signature\Algorithm\ES256;
use Jose\Component\Signature\JWSBuilder;

$issuer = new SDJWTIssuer(new JWSBuilder(new AlgorithmManager([new ES256()])));

$sdJwt = $issuer->issue(
    [
        'iss' => 'https://issuer.example.com',
        'iat' => time(),
        'exp' => time() + 31536000,
        'sub' => 'user_42',
        'given_name' => new Disclosable('John'),                       // A selectively disclosable claim
        'family_name' => new Disclosable('Doe'),
        'address' => [                                                  // An object always disclosed...
            'street_address' => new Disclosable('123 Main St'),        // ...with selectively disclosable members
            'locality' => new Disclosable('Anytown'),
            'country' => 'US',
        ],
        'nationalities' => [new Disclosable('US'), new Disclosable('DE')], // Selectively disclosable array elements
        'cnf' => ['jwk' => $holderPublicKey->all()],                    // The key of the Holder, for Key Binding
    ],
    $issuerPrivateKey,
    ['alg' => 'ES256', 'typ' => 'example+sd-jwt'],
);

$token = $sdJwt->toString(); // The Issuer-signed JWT followed by all the Disclosures, sent to the Holder
```

A `Disclosable` may contain other `Disclosable` values: the claim is then selectively disclosable as a whole, and so are its members. This is the *recursive* disclosure of section 4.2.6 of the RFC:

```php
'address' => new Disclosable([
    'street_address' => new Disclosable('123 Main St'),
    'locality' => new Disclosable('Anytown'),
    'country' => 'US',
]),
```

The payload of the Issuer-signed JWT carries the digests in the `_sd` array of each object, sorted so that the original order of the claims is hidden, and in `{"...": "<digest>"}` elements at the positions of the selectively disclosable array elements. The hash algorithm is written in the `_sd_alg` claim.

### Salts, hash algorithm and decoy digests

Each Disclosure gets a salt of 128 random bits, the minimum the RFC recommends. A salt can be given as the second argument of `Disclosable` instead; it must then be unique and drawn from a cryptographically secure source: this is meant for reproducible tests, not for constant values.

The digests are computed with SHA-256 by default. The hash function is given by its IANA name as the second argument of the constructor: `sha-256`, `sha-384`, `sha-512`, `sha3-224`, `sha3-256`, `sha3-384` or `sha3-512` (`SDJWT::hashAlgorithms()` lists them). The RFC recommends a hash function whose collision resistance matches the one of the signature: SHA-512 with ES512, for instance.

*Decoy digests* hide how many claims an object or an array really has (sections 4.2.5 and 10.4 of the RFC). The last two arguments of the constructor are the minimum and the maximum number of decoys added to each `_sd` array and to each array that has selectively disclosable elements; the number is drawn between the two for each of them:

```php
$issuer = new SDJWTIssuer($jwsBuilder, 'sha-256', 2, 5); // Between 2 and 5 decoy digests in each _sd array
```

The decoy digests have the length of the real ones and are mixed with them by the sort. The objects and arrays without selectively disclosable claims, such as `cnf`, are left untouched.

### What the Issuer refuses

* An `alg` that is not a digital signature algorithm: `none`, but also a MAC such as `HS256`, which a Verifier could not attribute to the Issuer.
* The claim names `_sd`, `...` and `_sd_alg`, which are reserved.
* A selectively disclosable `iss`, `aud`, `exp`, `nbf` or `cnf` at the top level of the claims: the Verifier needs them to evaluate the SD-JWT (section 9.7 of the RFC). The elements of `aud` may be selectively disclosable.
* Two Disclosures with the same salt.

!!! tip

    Section 9.11 of the RFC recommends an explicit type for each kind of SD-JWT, such as `example+sd-jwt`, checked by the Verifiers. Set it in the `typ` header parameter.

## Presenting an SD-JWT

The Holder parses the SD-JWT it received with `SDJWT::fromString()`. Before storing it, it verifies it as a Verifier would, with `SDJWTVerifierInterface::verify()` (see below): the RFC requires the Holder to check the SD-JWT it receives (section 7.2).

### Selecting the Disclosures

`SDJWT::select()` returns the SD-JWT with the Disclosures needed to disclose the given claims. A claim is designated by its *claim path*, a list of segments as in OpenID for Verifiable Presentations:

| Segment              | Designates                                    | Example                         |
| -------------------- | --------------------------------------------- | ------------------------------- |
| a string             | the member of an object                       | `['address', 'locality']`       |
| a non-negative integer | the element of an array at that index       | `['nationalities', 0]`          |
| `null`               | every element of an array                     | `['nationalities', null]`       |

```php
<?php

use Jose\SelectiveDisclosure\SDJWT;

$sdJwt = SDJWT::fromString($token);

$presentation = $sdJwt->select(['given_name'], ['address', 'locality'], ['nationalities', 1]);
```

The Disclosures of a claim come with the Disclosures of the objects that contain it, without which the claim could not be inserted: selecting `['address', 'locality']` of a recursive `address` also selects the Disclosure of `address`. Selecting an object or an array selects everything it contains. A claim that is always disclosed needs no Disclosure. A path that designates no claim is refused, so that a mistyped name does not silently disclose less than intended.

The indexes are those of the arrays once all the Disclosures are applied, as the Holder sees them; the member names are always strings, `['age_equal_or_over', '18']` for instance.

Without Key Binding, `$presentation->toString()` is the presentation.

### Key Binding

When the Verifier requires Key Binding, the Holder adds a Key Binding JWT signed with the private key matching the `cnf` claim of the SD-JWT. The `SDJWTHolder` creates it: the `typ` is `kb+jwt`, `iat` comes from the clock, `aud` and `nonce` are those of the Verifier and `sd_hash` binds the Key Binding JWT to the Issuer-signed JWT and to the exact set of presented Disclosures.

```php
<?php

use Jose\SelectiveDisclosure\SDJWTHolder;

$holder = new SDJWTHolder($jwsBuilder, $clock); // A PSR-20 clock

$presentation = $holder->present(
    $sdJwt->select(['given_name'], ['nationalities', 1]),
    $holderPrivateKey,
    ['alg' => 'ES256'],
    'https://verifier.example.org', // The audience: the identifier of the Verifier
    $nonce                          // The nonce of the transaction, given by the Verifier
);

$token = $presentation->toString(); // ...~<Disclosure N>~<Key Binding JWT>
```

## Verifying a presentation

The `SDJWTVerifier` loads the Issuer-signed JWT with a `JWSLoader`, whose algorithms and header checkers apply, processes the Disclosures as section 7.1 of the RFC describes and checks the claims of the result, the *Processed SD-JWT Payload*. A second `JWSLoader` loads the Key Binding JWTs.

```php
<?php

use Jose\Component\Checker\AlgorithmChecker;
use Jose\Component\Checker\ClaimCheckerManager;
use Jose\Component\Checker\ExpirationTimeChecker;
use Jose\Component\Checker\HeaderCheckerManager;
use Jose\Component\Checker\IssuedAtChecker;
use Jose\Component\Checker\IssuerChecker;
use Jose\Component\Checker\NotBeforeChecker;
use Jose\Component\Checker\TypeChecker;
use Jose\SelectiveDisclosure\SDJWTVerifier;
use Jose\Component\Signature\JWSLoader;
use Jose\Component\Signature\JWSTokenSupport;

$verifier = new SDJWTVerifier(
    issuerSignedJwtLoader: new JWSLoader($serializerManager, $jwsVerifier, new HeaderCheckerManager(
        [new AlgorithmChecker(['ES256']), new TypeChecker(['example+sd-jwt'])],
        [new JWSTokenSupport()]
    )),
    clock: $clock,
    keyBindingJwtLoader: new JWSLoader($serializerManager, $jwsVerifier, null),
    claimCheckerManager: new ClaimCheckerManager([
        new IssuerChecker(['https://issuer.example.com']),
        new ExpirationTimeChecker($clock),
        new IssuedAtChecker($clock),
        new NotBeforeChecker($clock),
    ]),
    mandatoryClaims: ['iss', 'exp'],
    hashAlgorithms: ['sha-256'],    // The accepted values of "_sd_alg". All the supported ones when null
    keyBindingMaxAge: 300,          // How old a Key Binding JWT may be, in seconds
    allowedTimeDrift: 5,            // The drift allowed between the clocks, in seconds
);
```

!!! warning

    The claims that control the validity of the SD-JWT, such as `iss` or `exp`, may be selectively disclosable: they are only present in the Processed SD-JWT Payload when their Disclosure is presented. List them in `mandatoryClaims` so that a presentation without them is rejected (section 9.7 of the RFC).

Whether Key Binding is required is a decision of the Verifier, never of the token (section 7.3 of the RFC). It is made by choosing the method:

```php
// Key Binding not required: an SD-JWT with a Key Binding JWT is rejected
$verified = $verifier->verify($token, $issuerKeySet);

// Key Binding required: an SD-JWT without Key Binding JWT is rejected
$verified = $verifier->verifyWithKeyBinding($token, $issuerKeySet, 'https://verifier.example.org', $nonce);

$claims = $verified->getClaims();          // The Processed SD-JWT Payload
$verified->getIssuerKey();                 // The key that verified the Issuer-signed JWT
$verified->getHolderKey();                 // The key of "cnf" that verified the Key Binding JWT, if any
$verified->getSdJwt()->getDisclosures();   // The presented Disclosures
```

The Holder key is read from the `cnf` claim of the Processed SD-JWT Payload, with the `jwk` confirmation method; the other methods reference a key the application would have to resolve, and are not supported. Every rejection is reported by an `InvalidTokenException`, whose previous exception gives the cause when there is one.

The SD-JWT is rejected when:

* it is in neither format of the RFC, or the Issuer-signed JWT cannot be verified by the loader, or is not signed with a digital signature algorithm;
* `_sd_alg` is not one of the accepted hash algorithms;
* a Disclosure is malformed, has the reserved claim name `_sd` or `...`, is presented twice or is not referenced by any digest of the Issuer-signed JWT or of another presented Disclosure;
* a digest appears twice, whether it matches a Disclosure or not;
* the Disclosure of an array element is referenced from an object, or the other way round, or a disclosed claim already exists in its object;
* the claims of the Processed SD-JWT Payload are rejected by the claim checkers, or a mandatory claim is missing.

The Key Binding JWT is rejected when its signature cannot be verified with the key of `cnf`, its algorithm is not a digital signature algorithm, its `typ` is not `kb+jwt`, its `iat` is in the future or older than the maximum age, its `aud` or `nonce` is not the expected one, its `sd_hash` does not match the presented SD-JWT, or its `exp` or `nbf`, if any, says it is not valid.

## JWS JSON serialization

Section 8 of the RFC defines a second format. The Issuer-signed JWT is a JWS in the [JSON serialization](serialization.md#jws-json-flattened), flattened or general, and the Disclosures and the Key Binding JWT are two parameters of the unprotected header of its first signature, `disclosures` and `kb_jwt`:

```json
{
    "payload": "eyJfc2QiOiBbIjRIQm42YUlZM1d0dUdHV1R4LXFVajZjZGs2V0JwWn...",
    "protected": "eyJhbGciOiAiRVMyNTYiLCAidHlwIjogImV4YW1wbGUrc2Qtand0In0",
    "header": {
        "disclosures": [
            "WyI2SWo3dE0tYTVpVlBHYm9TNXRtdlZBIiwgImZhbWlseV9uYW1lIiwgIkRvZSJd",
            "WyJlbHVWNU9nM2dTTklJOEVZbnN4QV9BIiwgImdpdmVuX25hbWUiLCAiSm9obiJd"
        ],
        "kb_jwt": "eyJhbGciOiAiRVMyNTYiLCAidHlwIjogImtiK2p3dCJ9.eyJub25jZSI6ICIxMjM0NTY3ODkwIiwgImF1ZCI6ICJodHRwczovL3ZlcmlmaWVyLmV4YW1wbGUub3JnIiwgImlhdCI6IDE3NDg1MzcyNDQsICJzZF9oYXNoIjogIlZqdFBzZ1pwUVRSeEtKdkRwU0otblhsWktFOVo5TGdENEZ5Q3d3b05NUncifQ.GrDvJ2jhYNmUvqdwVEIrxeTFEuI5qKSM7I6P95JmA6Wko-FBB5vPGQn0wvmdgjLCE2iDRh1r82zchjmABQ3V8w"
    },
    "signature": "3oOtvPxU3QdDWUmfGexVB5rWyON2f1atg5rL825bvvD1g7ywjKDKy2UHqHoH2QS4FA99JbG5qnlqFaGXFChfjQ"
}
```

The unprotected header is not signed: the Holder removes Disclosures and adds the Key Binding JWT without invalidating the signature of the Issuer, as it removes the `~` segments of the compact format. Each Disclosure stays bound by its digest in the signed payload, and the Key Binding JWT by its own signature and its `sd_hash`. The other parameters of the unprotected header, a `kid` for instance, are not protected.

### Issuing in the JSON serialization

`issueJson()` signs the Issuer-signed JWT once for each `IssuerSignature`, which holds the key, the protected header and the unprotected header of a signature, as `JWSBuilder::addSignature()` takes them. With one signature, the SD-JWT is in the flattened serialization; with several, in the general one, which signs the same payload with several keys, while a key or an algorithm is replaced for instance:

```php
<?php

use Jose\SelectiveDisclosure\IssuerSignature;

$sdJwt = $issuer->issueJson(
    $claims,
    new IssuerSignature($issuerPrivateKey1, ['alg' => 'ES256', 'typ' => 'example+sd-jwt'], ['kid' => 'issuer-key-1']),
    new IssuerSignature($issuerPrivateKey2, ['alg' => 'ES384', 'typ' => 'example+sd-jwt'], ['kid' => 'issuer-key-2']),
);

$sdJwt->getSerialization(); // "jws_json_general"
$token = $sdJwt->toString(); // The JSON object, the Disclosures in the header of the first signature
```

The claims are processed as by `issue()`. The unprotected headers cannot have the `disclosures` and `kb_jwt` parameters, which belong to the SD-JWT.

### Presenting in the JSON serialization

`SDJWT::fromString()` reads a JSON object as the JWS JSON serialization, and any other string as the compact format. `getSerialization()` names the format as the JWS serializers do: `jws_compact`, `jws_json_flattened` or `jws_json_general`.

The SD-JWT keeps its serialization. The Holder selects the Disclosures and adds the Key Binding JWT as with the compact format, and `toString()` writes the SD-JWT back in the JSON serialization, the other signatures and their headers unchanged. In the JSON serialization, `getIssuerSignedJwt()` returns the JWS without the `disclosures` and `kb_jwt` parameters.

The `sd_hash` of the Key Binding JWT is computed over the compact format, made of the protected header, the payload and the signature of the first signature: an SD-JWT has the same `sd_hash` in both formats.

### Verifying in the JSON serialization

The serializers of the loader of the Issuer-signed JWT decide whether the Verifier accepts the JWS JSON serialization: give it the JSON serializers besides the compact one.

```php
<?php

use Jose\Component\Signature\Serializer\CompactSerializer;
use Jose\Component\Signature\Serializer\JSONFlattenedSerializer;
use Jose\Component\Signature\Serializer\JSONGeneralSerializer;
use Jose\Component\Signature\Serializer\JWSSerializerManager;

$serializerManager = new JWSSerializerManager([
    new CompactSerializer(),
    new JSONFlattenedSerializer(),
    new JSONGeneralSerializer(),
]);
```

The Key Binding JWT is always in the compact serialization. In the general serialization, the Issuer-signed JWT is accepted once one of its signatures is verified, as the JWS loader does, and the algorithm of that signature must be a digital signature algorithm. The `sd_hash` is computed over the first signature, whichever one is verified.

## Disclosures

The `Disclosure` class is the building block of the package. It creates the Disclosure of an object property or of an array element, parses one, and computes its digest:

```php
<?php

use Jose\SelectiveDisclosure\Disclosure;

$disclosure = Disclosure::forObjectProperty('family_name', 'Doe');  // A random salt
$disclosure = Disclosure::forArrayElement('FR', 'lklxF5jMYlGTPUovMNIvCA');
$disclosure = Disclosure::fromString('WyJsa2x4RjVqTVlsR1RQVW92TU5JdkNBIiwgIkZSIl0');

$disclosure->getSalt();         // "lklxF5jMYlGTPUovMNIvCA"
$disclosure->getClaimName();    // null, for an array element
$disclosure->getValue();        // "FR"
$disclosure->digest();          // "w0I8EKcdCtUPkGCNUrfwVp2xEgNjtoIDlOxc9-PlOhs" (SHA-256)
$disclosure->digest('sha-512');
```

The JSON arrays are serialized as the examples of the RFC are: elements separated by `", "`, non-ASCII characters escaped. Any JSON is valid and the digest covers the encoded string, so this changes nothing for the other implementations; it is the serialization that reproduces the examples of the RFC from their salts, which the test suite of the library does.

## Symfony bundle

### Configuration

The `selective_disclosure` section of the configuration exists when the `web-token/jwt-selective-disclosure` package is installed; the bundle suggests it but does not require it.

```yaml
jose:
    checkers:
        headers:
            sd_jwt:
                headers: []
                typ: ['example+sd-jwt']       # Registers the "typ.sd_jwt" header checker alias
    selective_disclosure:
        issuers:
            issuer_1:
                signature_algorithms: ['ES256']
                hash_algorithm: 'sha-256'      # Optional, "sha-256" by default
                minimum_decoy_digests: 2       # Optional, 0 by default
                maximum_decoy_digests: 5       # Optional, the minimum by default
                is_public: true
        holders:
            holder_1:
                signature_algorithms: ['ES256'] # For the Key Binding JWTs
                is_public: true
        verifiers:
            verifier_1:
                signature_algorithms: ['ES256'] # For the Issuer-signed JWTs
                header_checkers: ['typ.sd_jwt']
                key_binding_signature_algorithms: ['ES256', 'Ed25519'] # Optional, those of the Issuer-signed JWTs by default
                key_binding_header_checkers: []
                claim_checkers: ['exp', 'iat', 'nbf']
                mandatory_claims: ['iss', 'exp']
                hash_algorithms: ['sha-256']    # Optional, all the supported ones by default
                key_binding_max_age: 300        # Optional, 300 seconds by default
                allowed_time_drift: 0           # Optional, 0 by default
                serializers: ['jws_compact', 'jws_json_flattened', 'jws_json_general'] # Optional, ['jws_compact'] by default
                is_public: true
```

The `serializers` of a verifier are those of its Issuer-signed JWTs: the SD-JWTs in the JWS JSON serialization are only accepted with the JSON serializers.

This configuration creates three services:

* `jose.sd_jwt_issuer.issuer_1`, an `SDJWTIssuer`
* `jose.sd_jwt_holder.holder_1`, an `SDJWTHolder`
* `jose.sd_jwt_verifier.verifier_1`, an `SDJWTVerifier`

The clock is the `Psr\Clock\ClockInterface` service of the application, as for the claim checkers. The services can be autowired by their class or their interface, with an argument named after the service: `SDJWTIssuerInterface $issuer1SdJwtIssuer`, `SDJWTHolderInterface $holder1SdJwtHolder`, `SDJWTVerifierInterface $verifier1SdJwtVerifier`.

The factories `SDJWTIssuerFactory`, `SDJWTHolderFactory` and `SDJWTVerifierFactory` are public services too, for the services created at runtime.
