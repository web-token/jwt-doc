Configuration Helper
====================

When you want to create keys/key sets, JWS loader/verifier... services, you have to create a dedicated `jose` section in your configuration.
It may confuse your users to configure your bundle and the Jose Framework bundle.
Sometimes, you may also want to be sure that the configuration is correctly defined.
Lastly, the configuration size increases with numerous details, options or service IDs and it becomes difficult to read or modify.

Hopefully, the Symfony bundle provide a configuration helper: `Jose\Bundle\JoseFramework\Helper\ConfigurationHelper`. This helper will configure the `jose` section for you.
This helper has to be called in your bundle extension during the `prepend` step (your extension has to implement `Symfony\Component\DependencyInjection\Extension\PrependExtensionInterface`).

```php
<?php

declare(strict_types=1);

namespace AcmeBundle\DependencyInjection;

use Jose\Bundle\JoseFramework\Helper\ConfigurationHelper;
use Symfony\Component\DependencyInjection\ContainerBuilder;
use Symfony\Component\DependencyInjection\Extension\PrependExtensionInterface;
use Symfony\Component\HttpKernel\DependencyInjection\Extension;

final class AcmeExtension extends Extension implements PrependExtensionInterface
{
    ...

    /**
     * {@inheritdoc}
     */
    public function prepend(ContainerBuilder $container)
    {
        ... // The Helper will be called here
    }
}
```

Let say you want to create a JWK as a service:

```php
ConfigurationHelper::addKey(
    $container,
    'acme_my_key',
    'jwk', [
        'value' => '{"kty":"oct","k":"dzI6nbW4OcNF-AtfxGAmuyz7IpHRudBI0WgGjZWgaRJt6prBn3DARXgUR8NVwKhfL43QBIU2Un3AvCGCHRgY4TbEqhOi8-i98xxmCggNjde4oaW6wkJ2NgM3Ss9SOX9zS3lcVzdCMdum-RwVJ301kbin4UtGztuzJBeg5oVN00MGxjC2xWwyI0tgXVs-zJs5WlafCuGfX1HrVkIf5bvpE0MQCSjdJpSeVao6-RSTYDajZf7T88a2eVjeW31mMAg-jzAWfUrii61T_bYPJFOXW8kkRWoa1InLRdG6bKB9wQs9-VdXZP60Q4Yuj_WZ-lO7qV9AEFrUkkjpaDgZT86w2g"}',
        'is_public' => true,
    ],
    [
        'tag_name1' => [],
        'tag_name2' => ['attribute1' => 'foo'],
    ]
);
```

For the key configuration, the arguments are:

* The container
* The name of the service (`acme_my_key`)
* The key type (`jwk`)
* An array with the expected values
* An array with the custom tags (optional)

Now a key service named `jose.key.acme_my_key` will be created. This service is public so you will be able to get it from your container
or inject it to your services.

This is exactly the same configuration as the following one:

```yaml
jose:
    keys:
        acme_my_key:
            jwk:
                value: '{"kty":"oct","k":"dzI6nbW4OcNF-AtfxGAmuyz7IpHRudBI0WgGjZWgaRJt6prBn3DARXgUR8NVwKhfL43QBIU2Un3AvCGCHRgY4TbEqhOi8-i98xxmCggNjde4oaW6wkJ2NgM3Ss9SOX9zS3lcVzdCMdum-RwVJ301kbin4UtGztuzJBeg5oVN00MGxjC2xWwyI0tgXVs-zJs5WlafCuGfX1HrVkIf5bvpE0MQCSjdJpSeVao6-RSTYDajZf7T88a2eVjeW31mMAg-jzAWfUrii61T_bYPJFOXW8kkRWoa1InLRdG6bKB9wQs9-VdXZP60Q4Yuj_WZ-lO7qV9AEFrUkkjpaDgZT86w2g"}'
                is_public: true
                tags:
                    tag_name1: ~
                    tag_name2: {attribute1: 'foo'}
```

Other methods are:

* For the `jws` section:
    * `public static function addJWSBuilder(ContainerBuilder $container, string $name, array $signatureAlgorithms, bool $is_public = true, array $tags = [])`
    * `public static function addJWSVerifier(ContainerBuilder $container, string $name, array $signatureAlgorithms, bool $is_public = true, array $tags = [])`
    * `public static function addJWSSerializer(ContainerBuilder $container, string $name, array $serializers, bool $is_public = true, array $tags = [])`
* For the `jwe` section:
    * `public static function addJWEBuilder(ContainerBuilder $container, string $name, array $keyEncryptionAlgorithm, array $contentEncryptionAlgorithms, array $compressionMethods = ['DEF'], bool $is_public = true, array $tags = [])`
    * `public static function addJWEDecrypter(ContainerBuilder $container, string $name, array $keyEncryptionAlgorithm, array $contentEncryptionAlgorithms, array $compressionMethods = ['DEF'], bool $is_public = true, array $tags = [])`
    * `public static function addJWESerializer(ContainerBuilder $container, string $name, array $serializers, bool $is_public = true, array $tags = [])`
* For the `checker` section:
    * `public static function addClaimChecker(ContainerBuilder $container, string $name, array  $claimCheckers, bool $is_public = true, array $tags = [])`
    * `public static function addHeaderChecker(ContainerBuilder $container, string $name, array  $headerCheckers, bool $is_public = true, array $tags = [])`
* For the `keys` section:
    * `public static function addKey(ContainerBuilder $container, string $name, string $type, array  $parameters, array $tags = [])`
* For the `key_sets` section:
    * `public static function addKeyset(ContainerBuilder $container, string $name, string $type, array  $parameters, array $tags = [])`
* For the `jwk_uris` section:
    * `public static function addKeyUri(ContainerBuilder $container, string $name, array $parameters, array $tags = [])`

Have a look at [the `spomky-labs/lexik-jose-bridge` extension](https://github.com/Spomky-Labs/lexik-jose-bridge/blob/v2.0/DependencyInjection/SpomkyLabsLexikJoseExtension.php#L78) to see how we configure the Jose Bundle without dedicated configuration
