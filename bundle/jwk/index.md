Keys And Key Sets Management (JWK and JWKSet)
=============================================

The JWK and JWKSet objects are provided by the `web-token/jwt-core` component.
But it may not be sufficient for your project.

You could need to load your keys and keys sets from an environment variable.
You may also want to use your keys as a container services you inject to other services.

This is the purpose of the `web-token/jwt-key-mgmt-bundle` bundle.
To install it, just execute the following command line:

```sh
composer require web-token/jwt-key-mgmt-bundle
```

If you use Symfony Flex, there is nothing to do. Otherwise please enable `Jose\Bundle\KeyManagement\KeyManagementBundle`.
You have to make sure that the JWT Framework is correctly enabled.

# Keys

The bundle allows you to load your keys from several sources or formats.
All these methods have the following common option:

* `is_public`: set the service public or private.

The key configuration will look like as follow:

```yaml
jose: # Configuration of the JWT Framework
    keys: # Configuration of the keys
        key_name: # Unique key name
            method_name: # Name of the method
                ...
                is_public: true
```

The key will be available as a container service with the ID `jose.key.key_name` where `key_name` is the unique name of your key.
Each key service will be an instance of the `Jose\Component\Core\JWK` class.

## From A JWK Object

This method will directly get a JWK object.

```yaml
jose:
    keys:
        key_name:
            jwk: # Method
                value: '{"kty":"oct","k":"dzI6nbW4OcNF-AtfxGAmuyz7IpHRudBI0WgGjZWgaRJt6prBn3DARXgUR8NVwKhfL43QBIU2Un3AvCGCHRgY4TbEqhOi8-i98xxmCggNjde4oaW6wkJ2NgM3Ss9SOX9zS3lcVzdCMdum-RwVJ301kbin4UtGztuzJBeg5oVN00MGxjC2xWwyI0tgXVs-zJs5WlafCuGfX1HrVkIf5bvpE0MQCSjdJpSeVao6-RSTYDajZf7T88a2eVjeW31mMAg-jzAWfUrii61T_bYPJFOXW8kkRWoa1InLRdG6bKB9wQs9-VdXZP60Q4Yuj_WZ-lO7qV9AEFrUkkjpaDgZT86w2g"}'
```

## From A X509 Certificate File

This method will load a X509 Certificate file.

```yaml
jose:
    keys:
        key_name:
            certificate: # Method
                path: '/path/to/your/X509/certificate'
                additional_values: # Optional values
                    use: 'sig'
                    alg: 'RS256'
```

## From A X509 Certificate

This method will load a key from a X509 Certificate.

```yaml
jose:
    keys:
        key_name:
            x5c: # Method
                value: '-----BEGIN CERTIFICATE----- ....'
                additional_values: # Optional values.
                    use: 'sig'
                    alg: 'RS256'
```

## From A PKCS#1/PKCS#8 Key File

This method will load a key from a PKCS#1 or PKCS#8 key file.

```yaml
jose:
    keys:
        key_name:
            file: # Method
                path: '/path/to/your/key/file'
                password: 'secret' # Optional. Only if the key is encrypted
                additional_values: # Optional values.
                    use: 'sig'
                    alg: 'RS256'
```

## From A Key In A Key Set

This method will retrieve a key from a JWKSet service.

```yaml
jose:
    keys:
        key_name:
            jwkset: # Method
                key_set: 'jose.key_set.my_key_set' # JWKSet service
                index: 0 # Use key at index 0
```

# Key Sets

All these methods have the following common option:

* `is_public`: set the service public or private.

The key set configuration will look like as follow:

```yaml
jose: # Configuration of the JWT Framework
    key_sets: # Configuration of the keys
        keyset_name: # Unique key name
            method_name: # Name of the method
                ...
                is_public: true
```

The key set will be available as a container service with the ID `jose.key_set.keyset_name` where `keyset_name` is the unique name of your key set.
Each key set service will be an instance of the `Jose\Component\Core\JWKSet` class.

## From A JWKSet Object

This method will directly get a JWKSet object.

```yaml
jose:
    keys:
        key_name:
            jwkset: # Method
                value: '{"keys":[{"kty":"oct","k":"dzI6nbW4OcNF-AtfxGAmuyz7IpHRudBI0WgGjZWgaRJt6prBn3DARXgUR8NVwKhfL43QBIU2Un3AvCGCHRgY4TbEqhOi8-i98xxmCggNjde4oaW6wkJ2NgM3Ss9SOX9zS3lcVzdCMdum-RwVJ301kbin4UtGztuzJBeg5oVN00MGxjC2xWwyI0tgXVs-zJs5WlafCuGfX1HrVkIf5bvpE0MQCSjdJpSeVao6-RSTYDajZf7T88a2eVjeW31mMAg-jzAWfUrii61T_bYPJFOXW8kkRWoa1InLRdG6bKB9wQs9-VdXZP60Q4Yuj_WZ-lO7qV9AEFrUkkjpaDgZT86w2g"},{"kty":"oct","k":"bwIAv5Nn-fo8p4LCEvM4IR9eLXgzJRs8jXCLb3xR0tDJGiZ46KheO4ip6htFKyN2aqJqlNi9-7hB6I1aLLy1IRT9-vcBoCSGu977cNAUuRLkRp7vo8s6MsxhB8WvQBDRZghV7jIYaune-3vbE7iDU2AESr8BUtorckLoO9uW__fIabaa3hJMMQIHCzYQbJKZvlCRCKWMk2H_zuS4JeDFTvyZH1skJYF_TET1DrCZHMPicw-Yk3_m2P-ilC-yidPPoVzeU8Jj3tQ6gtX3975qiQW7pt2qbgjKAuq2wsz_9hxLBtMB5rQPafFoxop7O4BklvZ9-ECcK6dfI2CAx9_tjQ"}]}'
```

## From A JKU (JWK Url)



```yaml
jose:
    keys:
        key_name:
            jku: # Method
                url: ''
```

## From A X5U (X509 Certificates Url)



```yaml
jose:
    keys:
        key_name:
            x5u: # Method
                url: ''
```

# Shared Ket Sets

It can be interesting to share your key sets through an Url.
This can easily achieved 

```yaml
jose:
    keys:
        jwk1:
            jwk:
                value: '{"kty":"oct","k":"dzI6nbW4OcNF-AtfxGAmuyz7IpHRudBI0WgGjZWgaRJt6prBn3DARXgUR8NVwKhfL43QBIU2Un3AvCGCHRgY4TbEqhOi8-i98xxmCggNjde4oaW6wkJ2NgM3Ss9SOX9zS3lcVzdCMdum-RwVJ301kbin4UtGztuzJBeg5oVN00MGxjC2xWwyI0tgXVs-zJs5WlafCuGfX1HrVkIf5bvpE0MQCSjdJpSeVao6-RSTYDajZf7T88a2eVjeW31mMAg-jzAWfUrii61T_bYPJFOXW8kkRWoa1InLRdG6bKB9wQs9-VdXZP60Q4Yuj_WZ-lO7qV9AEFrUkkjpaDgZT86w2g"}'
    key_sets:
        jwkset1:
            jwkset:
                value: '{"keys":[{"kty":"oct","k":"dzI6nbW4OcNF-AtfxGAmuyz7IpHRudBI0WgGjZWgaRJt6prBn3DARXgUR8NVwKhfL43QBIU2Un3AvCGCHRgY4TbEqhOi8-i98xxmCggNjde4oaW6wkJ2NgM3Ss9SOX9zS3lcVzdCMdum-RwVJ301kbin4UtGztuzJBeg5oVN00MGxjC2xWwyI0tgXVs-zJs5WlafCuGfX1HrVkIf5bvpE0MQCSjdJpSeVao6-RSTYDajZf7T88a2eVjeW31mMAg-jzAWfUrii61T_bYPJFOXW8kkRWoa1InLRdG6bKB9wQs9-VdXZP60Q4Yuj_WZ-lO7qV9AEFrUkkjpaDgZT86w2g"},{"kty":"oct","k":"bwIAv5Nn-fo8p4LCEvM4IR9eLXgzJRs8jXCLb3xR0tDJGiZ46KheO4ip6htFKyN2aqJqlNi9-7hB6I1aLLy1IRT9-vcBoCSGu977cNAUuRLkRp7vo8s6MsxhB8WvQBDRZghV7jIYaune-3vbE7iDU2AESr8BUtorckLoO9uW__fIabaa3hJMMQIHCzYQbJKZvlCRCKWMk2H_zuS4JeDFTvyZH1skJYF_TET1DrCZHMPicw-Yk3_m2P-ilC-yidPPoVzeU8Jj3tQ6gtX3975qiQW7pt2qbgjKAuq2wsz_9hxLBtMB5rQPafFoxop7O4BklvZ9-ECcK6dfI2CAx9_tjQ"}]}'
    jwk_uris:
        jwkset1:
            id: 'jose.key_set.jwkset1'
            path: '/1.jwkset'
            max_age: 100

httplug:
    clients:
        jose:
            factory: 'httplug.factory.guzzle6'
            config:
                verify: false
                timeout: 2
```