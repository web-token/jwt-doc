Key Set Management (JWKSet)
===========================

# Key Sets As Services

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

As any other configuration values, you can use environment variables.

## From A JWKSet Object

This method will directly get a JWKSet object.

```yaml
jose:
    keys:
        key_name:
            jwkset: # Method
                value: '{"keys":[{"kty":"oct","k":"dzI6nbW4OcNF-AtfxGAmuyz7IpHRudBI0WgGjZWgaRJt6prBn3DARXgUR8NVwKhfL43QBIU2Un3AvCGCHRgY4TbEqhOi8-i98xxmCggNjde4oaW6wkJ2NgM3Ss9SOX9zS3lcVzdCMdum-RwVJ301kbin4UtGztuzJBeg5oVN00MGxjC2xWwyI0tgXVs-zJs5WlafCuGfX1HrVkIf5bvpE0MQCSjdJpSeVao6-RSTYDajZf7T88a2eVjeW31mMAg-jzAWfUrii61T_bYPJFOXW8kkRWoa1InLRdG6bKB9wQs9-VdXZP60Q4Yuj_WZ-lO7qV9AEFrUkkjpaDgZT86w2g"},{"kty":"oct","k":"bwIAv5Nn-fo8p4LCEvM4IR9eLXgzJRs8jXCLb3xR0tDJGiZ46KheO4ip6htFKyN2aqJqlNi9-7hB6I1aLLy1IRT9-vcBoCSGu977cNAUuRLkRp7vo8s6MsxhB8WvQBDRZghV7jIYaune-3vbE7iDU2AESr8BUtorckLoO9uW__fIabaa3hJMMQIHCzYQbJKZvlCRCKWMk2H_zuS4JeDFTvyZH1skJYF_TET1DrCZHMPicw-Yk3_m2P-ilC-yidPPoVzeU8Jj3tQ6gtX3975qiQW7pt2qbgjKAuq2wsz_9hxLBtMB5rQPafFoxop7O4BklvZ9-ECcK6dfI2CAx9_tjQ"}]}'
```

## Distant Key Sets

You can load key sets shared by a distant service (e.g. Google, Microsoft, Okta...).
You must install and enable the [Httplug Bundle](http://docs.php-http.org/en/latest/integrations/symfony-bundle.html).

When done, you have to create a client and enable the JKU Factory service by indicating the request factory service to use:

```yaml
httplug: # Example of client configuration
    clients:
        acme:
            factory: 'httplug.factory.guzzle6'
            
jose:
    jku_factory:
        enabled: true
        client: 'httplug.client.acme' # The Httplug client
        request_factory: 'httplug.message_factory' # In general, you will use the same message factory as the one used by Httplug
```

**Important recommendations:**

* It is **highly recommended** to use a cache plugin for your HTTP client and thus avoid unnecessary calls to the key set endpoint.
* The **connection must be secured** and certificate verification should not be disabled.

### From A JKU (JWK Url)

The following example will allow you tu load a key set from a distant URI.
The key set must be a JWKSet object.

```yaml
jose:
    keys:
        key_name:
            jku: # Method
                url: 'https://login.microsoftonline.com/common/discovery/keys'
```

### From A X5U (X509 Certificates Url)

The following example will allow you tu load a key set from a distant URI.
The key set must be a list of X509 certificates.

```yaml
jose:
    keys:
        key_name:
            x5u: # Method
                url: 'https://www.googleapis.com/oauth2/v1/certs'
```

# Shared Ket Sets

It can be interesting to share your key sets through an Url.
This can easily achieved by adding a dedicated controller. This controller is automatically created by the bundle.

You must add the following configuration to your routing file.

```yaml
jwkset_endpoints:
    resource: "@JoseFrameworkBundle/Resources/config/routing/jwkset_controller.yml"
```

Then you can share your key set.

```yaml
jose:
    key_sets:
        public_keyset: # The key set we want to share
            jwkset:
                value: '{"keys":[{"kty":"OKP","crv":"X25519","x":"ovuZiVcMXBN4r0VgCvJy_ChAsBv4YPJGC5w56PzndXY"},{"kty":"OKP","crv":"X25519","x":"4qyOJ4T9RkdciIn6LDxb2LdM1Ov-dtBSuj0jh6nCuyc"}]}'
    jwk_uris:
        shared_keyset:
            id: 'jose.key_set.public_keyset' # The key set service to share
            path: '/certs' # Path of the key set. Final path is hostname/route_prefix/path: https://www.foo.com/keys/certs
            max_age: 1000 # Set the max age of this key set
```

Now went you go to the URL `http://128.0.0.1:8000/certs`, you will get your key set.

# Custom Tags

> This feature was introduced in version 1.1.

You can add custom tags and attributes to the services you create.

```yaml
jose:
    jwe:
        key_name:
            jku: # Method
                url: 'https://login.microsoftonline.com/common/discovery/keys'
                tags:
                    tag_name1: ~
                    tag_name2: {attribute1: 'foo'}
```
