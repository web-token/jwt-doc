# From v4.2 to v4.3

{% hint style="info" %}
Version 4.3 is under development. This page is filled in as the changes land; it lists nothing yet because the branch currently carries no user-facing change over 4.2.
{% endhint %}

This is a minor version upgrade. As for every 4.x release, it follows [semantic versioning](https://semver.org/): your code keeps working, and anything scheduled for removal is deprecated here before it disappears in 5.0.

If you are coming from an earlier version, read the previous guides first:

* [From v4.1 to v4.2](from-v4.1-to-v4.2.md) — the Brainpool curves, `withEncodedPayload()`, the RFC 7516 disjoint header requirement enforced on decryption, and key sets keeping every key sharing the same `kid`.
* [From v4.0 to v4.1](from-v4.0-to-v4.1.md) — Symfony 8.0 support and the deprecation of `UrlKeySetFactory::enabledCache()`.

## New Features

_Nothing yet._

## Behaviour Changes

_Nothing yet._

## Deprecations

The deprecations introduced in 4.1 and 4.2 are still in place and will be removed in 5.0:

* [`UrlKeySetFactory::enabledCache()`](from-v4.0-to-v4.1.md#urlkeysetfactoryenabledcache) — configure caching at the HTTP client level instead.
* [The hardcoded `RSA1_5` CEK size table](from-v4.1-to-v4.2.md#the-hardcoded-rsa15-cek-size-table) — custom key encryption algorithms should read the [expected CEK size](../advanced-topics/custom-algorithm.md#the-expected-cek-size) passed as an additional argument.
