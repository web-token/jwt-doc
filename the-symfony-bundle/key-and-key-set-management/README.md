# Key and Key Set Management

We recommend you to load these objects through environment variables. With Symfony, an environment variables processor is provided:

```yaml
parameters:
    my_private_key: '%env(jwk:MY_PRIVATE_KEY)%'
    my_public_keyset: '%env(jwkset:MY_PUBLIC_KEYSET)%'
```

With the previous configuration, the environment variables `MY_PRIVATE_KEY` and `MY_PUBLIC_KEYSET` will be processed by Symfony and the container will contain the `my_private_key` and `my_public_keyset` with JWK and JWKSet objects respectively.

But it may not be sufficient for your project. You may need to load keys or key sets from other sources (e.g. key file) You may also want to use your keys as a container services you inject to other services.

* [Key Management (JWK)](key-management-jwk.md)
* [Key Set Management (JWKSet)](key-set-management-jwkset.md)
