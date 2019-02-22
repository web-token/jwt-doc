# Nested Tokens

JWT can be signed or encrypted and both. A nested token is a signed token enclosed in an encrypted one. This order is very important: signed then encrypted.

The `NestedTokenLoader` and `NestedTokenBuilder` classes will help you to create nested tokens with ease. They are provided by the `web-token/jwt-encryption` component. However, you must also install the following component to use it:

* `web-token/jwt-checker`
* `web-token/jwt-signature`

## Nested Token Loading

To instantiate the `NestedTokenLoader`, you need a `JWSLoader` and a `JWELoader`.

```php
use Jose\Component\Encryption\NestedTokenLoader;

$nestedTokenLoader = new NestedTokenLoader($jweLoader, $jwsLoader);
```

Its use is very straightforward, you just have to call the method `load` using the token, the encryption and signature key sets.

The last argument \(`$signature` in the following example\) will represents the signature index of the verified signature. This is only useful when multiple signature support is used.

```php
$jws = $nestedTokenLoader->load($token, $encryptionKeySet, $signatureKeySet, $signature);
```

## Nested Token Building

To instantiate the `NestedTokenBuilderder`, you will need the following components:

* a `JWSBuilder`,
* a `JWEBuilder`, 
* a `JWESerializerManager`,
* a `JWSSerializerManager`

```php
use Jose\Component\Encryption\NestedTokenBuilder;

$nestedTokenBuilder = new NestedTokenBuilder($jweLoader, $jweSerializerManager, $jwsLoader, $jwsSerializerManager);
```

Its use is a bit more complicated than the loading as the nested token may be designed for several recipients or may have several signatures.

```php
$token = $builder->create(
    $payload,                                     // The payload to protect
    [[                                            // A list of signatures. 'key' is mandatory and at least one of 'protected_header'/'header' has to be set.
        'key'              => $signature_key,     // The key used to sign. Mandatory.
        'protected_header' => ['alg' => 'PS256'], // The protected header. Optional.
        'header'           => ['foo' => 'bar'],   // The unprotected header. Optional.
    ]],
    'jws_json_flattened',                         // The serialization mode for the JWS
    ['alg' => 'RSA-OAEP', 'enc' => 'A128GCM'],    // The shared protected header. Optional.
    ['foo' => 'bar'],                             // The shared unprotected header. Optional.
    [[                                            // A list of recipients. 'key' is mandatory.
        'key'    => $encryption_key,              // The recipient key.
        'header' => ['bar' => 'foo'],             // The recipient unprotected header.
    ]],
    'jwe_json_flattened'                          // The serialization mode for the JWE.
    '1, 2, 3, 4'                                  // Additional Authenticated Data (AAD). Optional.
);
```

As a reminder, if one of the following parameter is set, the compact serialization mode _cannot_ be used:

* signature unprotected header,
* JWE shared unprotected header,
* recipient unprotected header,
* Additional Authenticated Data.

## Symfony Bundle

### Configuration

Hereafter an example of a Symfony application configuration:

```yaml
jose:
    nested_token:
        loaders:
            loader_1:
                signature_algorithms: ['PS256']
                key_encryption_algorithms: ['RSA-OAEP']
                content_encryption_algorithms: ['A128GCM']
                jws_serializers: ['jws_compact']
                jws_header_checkers: [...]
                jwe_serializers: ['jwe_compact']
                jwe_header_checkers: [...]
                is_public: true
        builders:
            builder_1:
                signature_algorithms: ['PS256']
                key_encryption_algorithms: ['RSA-OAEP']
                content_encryption_algorithms: ['A128GCM']
                jws_serializers: ['jws_compact']
                jwe_serializers: ['jwe_compact']
                is_public: true
```

This configuration will create two public services:

* `jose.nested_token_loader.loader_1`
* `jose.nested_token_builder.builder_1`

These services can be called from the container \(unless private\) or injected in your services.

### Configuration Helper

As any other services, you can create a nested token loader or builder from another bundle extension. The following bundle extension class will create the same configuration and services as above.

```php
class AcmeExtension extends Extension implements PrependExtensionInterface
{
    ...

    public function prepend(ContainerBuilder $container)
    {
        ConfigurationHelper::addNestedTokenLoader($container, 'loader_1', ['jwe_compact'], ['RSA-OAEP'], ['A128GCM'], ['DEF'], [], ['jws_compact'], ['PS256'], [], true, []);
        ConfigurationHelper::addNestedTokenBuilder($container, 'builder_1', ['jwe_compact'], ['RSA-OAEP'], ['A128GCM'], ['DEF'], ['jws_compact'], ['PS256'], true, []);
    }
}
```

