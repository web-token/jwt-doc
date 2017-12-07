Key Management (JWK)
====================

# Keys As Services

When the component is installed, you will be able to define your keys in your application configuration and load your keys from several sources or formats.
All these methods have the following option:

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

As any other configuration values, you can use environment variables.

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
