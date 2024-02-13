# Table of contents

* [Introduction](README.md)

## Introduction

* [Provided Features](introduction/provided-features.md)
* [Pre-requisite](introduction/pre-requisite.md)
* [Continous Integration](introduction/continous-integration.md)
* [Contributing](introduction/contributing.md)

## The Components

* [Algorithm Management (JWA)](the-components/algorithm-management-jwa.md)
* [Key (JWK) and Key Set (JWKSet)](the-components/key-jwk-and-key-set-jwkset/README.md)
  * [Key (JWK)](the-components/key-jwk-and-key-set-jwkset/key-management.md)
  * [Key Set (JWKSet)](the-components/key-jwk-and-key-set-jwkset/key-set-management.md)
* [Header Checker](the-components/header-checker.md)
* [Claim Checker](the-components/claim-checker.md)
* [Signed Tokens (JWS)](the-components/signed-tokens-jws/README.md)
  * [Signature Algorithms](the-components/signed-tokens-jws/signature-algorithms.md)
  * [JWS Creation](the-components/signed-tokens-jws/jws-creation.md)
  * [JWS Loading](the-components/signed-tokens-jws/jws-loading.md)
* [Encrypted Tokens (JWE)](the-components/encrypted-tokens-jwe/README.md)
  * [Encryption Algorithms](the-components/encrypted-tokens-jwe/encryption-algorithms.md)
  * [JWE Creation](the-components/encrypted-tokens-jwe/jwe-creation.md)
  * [JWE Loading](the-components/encrypted-tokens-jwe/jwe-loading.md)

## The Symfony Bundle

* [Symfony Bundle](the-symfony-bundle/symfony-bundle.md)
* [Algorithm Management](the-symfony-bundle/algorithm-management.md)
* [Key and Key Set Management](the-symfony-bundle/key-and-key-set-management/README.md)
  * [Key Management (JWK)](the-symfony-bundle/key-and-key-set-management/key-management-jwk.md)
  * [Key Set Management (JWKSet)](the-symfony-bundle/key-and-key-set-management/key-set-management-jwkset.md)
* [Header and Claim Checker Management](the-symfony-bundle/header-and-claim-checker-management.md)
* [Signed Tokens](the-symfony-bundle/signed-tokens/README.md)
  * [JWS serializers](the-symfony-bundle/signed-tokens/jws-serializers.md)
  * [JWS creation](the-symfony-bundle/signed-tokens/jws-creation.md)
  * [JWS verification](the-symfony-bundle/signed-tokens/jws-verification.md)
* [Encrypted Tokens](the-symfony-bundle/encrypted-tokens/README.md)
  * [JWE serializers](the-symfony-bundle/encrypted-tokens/jwe-serializers.md)
  * [JWE creation](the-symfony-bundle/encrypted-tokens/jwe-creation.md)
  * [JWE decryption](the-symfony-bundle/encrypted-tokens/jwe-decryption.md)
* [Configuration Helper](the-symfony-bundle/configuration-helper.md)
* [Events](the-symfony-bundle/events.md)

## Console Command

* [Console](console-command/console.md)
* [Standalone Application](console-command/standalone.md)
* [PHAR Application](console-command/phar-application.md)
* [Symfony Console](console-command/symfony-console.md)

## Advanced Topics

* [Security Recommendations](advanced-topics/security-recommendations.md)
* [Nested Tokens](advanced-topics/nested-tokens.md)
* [Serialization](advanced-topics/serialization.md)
* [Custom Algorithm](advanced-topics/custom-algorithm.md)
* [Signed tokens and](advanced-topics/signed-tokens-and/README.md)
  * [Unprotected Header](advanced-topics/signed-tokens-and/unprotected-header.md)
  * [Multiple Signatures](advanced-topics/signed-tokens-and/multiple-signatures.md)
  * [Detached Payload](advanced-topics/signed-tokens-and/detached-payload.md)
  * [Unencoded Payload](advanced-topics/signed-tokens-and/unencoded-payload.md)
* [Encrypted tokens and](advanced-topics/encrypted-tokens-and/README.md)
  * [Unprotected Headers](advanced-topics/encrypted-tokens-and/unprotected-headers.md)
  * [Multiple Recipients](advanced-topics/encrypted-tokens-and/multiple-recipients.md)
  * [Additional Authentication Data (AAD)](advanced-topics/encrypted-tokens-and/additional-authentication-data-aad.md)

## Benchmark

* [How To](benchmark/benchmarks.md)
* [Result table](benchmark/result-table.md)

## Migration

* [From v1.x to v2.0](migration/from-v1.x-to-v2.0.md)
* [From v2.x to v3.0](migration/from-v1.x-to-v2.0-1.md)
