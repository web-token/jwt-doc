# Serialization

The [RFC7515](https://tools.ietf.org/html/rfc7515) \(JWS\) and [RFC7516](https://tools.ietf.org/html/rfc7516) \(JWE\) introduce several serialization modes.

* Compact
* JSON Flattened
* JSON General

The _Compact_ mode is most know and commonly used as it is compact and URL safe i.e. it is designed for web context. JSON Flattened and General are not URL safe, but provides features that may fit on your application context.

## JWS Serialization

To use the JWS serializers, you have to install the `jwt-signature` component.

```bash
composer require web-token/jwt-signature
```

### JWS Compact

This serialization mode is probably the one you know the most. It it a string composed of three parts encoded in Base64 Url Safe and separated by a dot \(`.`\).

The serializer class is `Jose\Component\Signature\Serializer\CompactSerializer`. The associated name is `jws_compact`.

Example:

```text
eyJhbGciOiJFUzUxMiJ9.UGF5bG9hZA.AdwMgeerwtHoh-l192l60hp9wAHZFVJbLfD_UxMi70cwnZOYaRI1bKPWROc-mZZqwqT2SI-KGDKB34XO0aw_7XdtAG8GaSwFKdCAPZgoXD2YBJZCPEX3xKpRwcdOO8KpEHwJjyqOgzDO7iKvU8vcnwNrmxYbSW9ERBXukOXolLzeO_Jn
```

There are some limitations when you use this serialization mode:

* Unprotected header not supported.
* Unencoded payload must contain characters within the following range of ASCII characters: 0x20-0x2d and 0x2f-0x7e

### JWS JSON Flattened

This serialization mode is useful when you need to use the unprotected header. It it a simple JSON object.

The serializer class is `Jose\Component\Signature\Serializer\JSONFlattenedSerializer`. The associated name is `jws_json_flattened`.

Example:

```javascript
{
  "payload": "SW4gb3VyIHZpbGxhZ2UsIGZvbGtzIHNheSBHb2QgY3J1bWJsZXMgdXAgdGhlIG9sZCBtb29uIGludG8gc3RhcnMu",
  "protected": "eyJhbGciOiJFUzI1NiJ9",
  "header": {
    "kid": "myEcKey"
  },
  "signature": "b7V2UpDPytr-kMnM_YjiQ3E0J2ucOI9LYA7mt57vccrK1rb84j9areqgQcJwOA00aWGoz4hf6sMTBfobdcJEGg"
}
```

### JWS JSON General

This serialization mode is similar to the JWS JSON Flattened, but may contain more than one signature. It it a JSON object.

The serializer class is `Jose\Component\Signature\Serializer\JSONGeneralSerializer`. The associated name is `jws_json_general`.

Example:

```javascript
{
  "payload": "SW4gb3VyIHZpbGxhZ2UsIGZvbGtzIHNheSBHb2QgY3J1bWJsZXMgdXAgdGhlIG9sZCBtb29uIGludG8gc3RhcnMu",
  "signatures": [
    {
      "protected": "eyJhbGciOiJSUzI1NiJ9",
      "header": {
        "kid": "myRsaKey"
      },
      "signature": "B04c24gSnpVm1Z-_bemfyNMCpZm6Knj1yB-yzaIOvijsWfDgoF_mSJccTIbzapNgwJudnobr5iDOfZWiRR9iqCyDJLe5M1S40vFF7MFEI3JecYRgrRc6n1lTkYLMRyVq48BwbQlmKgPqmK9drun3agklsr0FmgNx65pfmcnlYdXsgwxf8WbgppefrlrMImp-98-dNtBcUL8ce1aOjbcyVFjGMCzpm3JerQqIzWQvEwBstnMEQle73KHcyx_nsTmlzY70CaydbRTsciOATL7WfiMwuX1q9Y2NIpTg3CbOTWKdwjh7iyfiAKQxNBaF2mApnqj9hjpf8GwR-CfxAzJtPg"
    },
    {
      "protected": "eyJhbGciOiJFUzI1NiJ9",
      "header": {
        "kid": "myEcKey"
      },
      "signature": "2cbugKq0ERaQMh01n2B-86EZFYleeMf8bsccaQMxzOxAg14PxfjR3IImvodTJYqkmfBJYW203etz2-7ZtJUOGw"
    },
    {
      "protected": "eyJhbGciOiJIUzI1NiJ9",
      "header": {
        "kid": "myMacKey"
      },
      "signature": "e7R9gjx0RsUNa3c7qd8k9mQGEhtcG8vsN1W7jbLb2MA"
    }
  ]
}
```

### JWS Serializer Manager

The serializer manager can be helpful when your application deals more than one serialization mode.

```php
<?php

require_once 'vendor/autoload.php';

use Jose\Component\Signature\Serializer;

$manager = Serializer\JWSSerializerManager::create([
    new Serializer\CompactSerializer(),
    new Serializer\JSONFlattenedSerializer(),
    new Serializer\JSONGeneralSerializer(),
]);

// Serializes the second signature (index = 1) of the variable $jws (JWS object) into JSON Flattened serialization mode.
$token = $manager->serialize('jws_json_flattened', $jws, 1);

// Retrieve the JWS object from a token
$jws = $manager->unserialize($token);
```

## JWE Serialization

To use the JWE serializers, you have to install the `jwt-encryption` component.

### JWE Compact

This serialization mode is probably the one you know the most. It it a string composed of five parts encoded in Base64 Url Safe and separated by a dot \(`.`\).

The serializer class is `Jose\Component\Encryption\Serializer\CompactSerializer`. The associated name is `jwe_compact`.

Example:

```text
eyJhbGciOiJSU0ExXzUiLCJlbmMiOiJBMTI4Q0JDLUhTMjU2In0.UGhIOguC7IuEvf_NPVaXsGMoLOmwvc1GyqlIKOK1nN94nHPoltGRhWhw7Zx0-kFm1NJn8LE9XShH59_i8J0PH5ZZyNfGy2xGdULU7sHNF6Gp2vPLgNZ__deLKxGHZ7PcHALUzoOegEI-8E66jX2E4zyJKx-YxzZIItRzC5hlRirb6Y5Cl_p-ko3YvkkysZIFNPccxRU7qve1WYPxqbb2Yw8kZqa2rMWI5ng8OtvzlV7elprCbuPhcCdZ6XDP0_F8rkXds2vE4X-ncOIM8hAYHHi29NX0mcKiRaD0-D-ljQTP-cFPgwCp6X-nZZd9OHBv-B3oWh2TbqmScqXMR4gp_A.AxY8DCtDaGlsbGljb3RoZQ.KDlTtXchhZTGufMYmOYGS4HffxPSUrfmqCHXaI9wOGY.9hH0vgRfYgPnAHOd8stkvw
```

There are some limitations when you use this serialization mode:

* No Additional Authentication Data can be used.
* No shared unprotected header or per-recipient header can be used.

### JWE JSON Flattened

This serialization mode is useful when you need to use the unprotected header. It it a simple JSON object.

The serializer class is `Jose\Component\Encryption\Serializer\JSONFlattenedSerializer`. The associated name is `jwe_json_flattened`.

Example:

```javascript
{
  "protected":"eyJlbmMiOiJBMTI4Q0JDLUhTMjU2In0",
  "unprotected":{"jku":"https://server.example.com/keys.jwks"},
  "header":{"alg":"A128KW","kid":"7"},
  "encrypted_key":"6KB707dM9YTIgHtLvtgWQ8mKwboJW3of9locizkDTHzBC2IlrT1oOQ",
  "iv":"AxY8DCtDaGlsbGljb3RoZQ",
  "ciphertext":"KDlTtXchhZTGufMYmOYGS4HffxPSUrfmqCHXaI9wOGY",
  "tag":"Mz-VPPyU4RlcuYv1IwIvzw"
}
```

### JWE JSON General

This serialization mode is similar to the JWE JSON Flattened, but may contain more than one recipient. It it a JSON object.

The serializer class is `Jose\Component\Encryption\Serializer\JSONGeneralSerializer`. The associated name is `jwe_json_general`.

Example:

```javascript
 {
  "protected":"eyJlbmMiOiJBMTI4Q0JDLUhTMjU2In0",
  "unprotected":{"jku":"https://server.example.com/keys.jwks"},
  "recipients":[
    {
      "header":{"alg":"RSA1_5","kid":"2011-04-29"},
      "encrypted_key":"UGhIOguC7IuEvf_NPVaXsGMoLOmwvc1GyqlIKOK1nN94nHPoltGRhWhw7Zx0-kFm1NJn8LE9XShH59_i8J0PH5ZZyNfGy2xGdULU7sHNF6Gp2vPLgNZ__deLKxGHZ7PcHALUzoOegEI-8E66jX2E4zyJKx-YxzZIItRzC5hlRirb6Y5Cl_p-ko3YvkkysZIFNPccxRU7qve1WYPxqbb2Yw8kZqa2rMWI5ng8OtvzlV7elprCbuPhcCdZ6XDP0_F8rkXds2vE4X-ncOIM8hAYHHi29NX0mcKiRaD0-D-ljQTP-cFPgwCp6X-nZZd9OHBv-B3oWh2TbqmScqXMR4gp_A"
    },
    {
      "header":{"alg":"A128KW","kid":"7"},
      "encrypted_key":"6KB707dM9YTIgHtLvtgWQ8mKwboJW3of9locizkDTHzBC2IlrT1oOQ"
    }
  ],
  "iv":"AxY8DCtDaGlsbGljb3RoZQ",
  "ciphertext":"KDlTtXchhZTGufMYmOYGS4HffxPSUrfmqCHXaI9wOGY",
  "tag":"Mz-VPPyU4RlcuYv1IwIvzw"
 }
```

### JWE Serializer Manager

The serializer manager can be helpful when your application deals more than one serialization mode.

```php
<?php

require_once 'vendor/autoload.php';

use Jose\Component\Encryption\Serializer;

$manager = Serializer\JWESerializerManager::create([
    new Serializer\CompactSerializer(),
    new Serializer\JSONFlattenedSerializer(),
    new Serializer\JSONGeneralSerializer(),
]);

// Serializes the second recipient (index = 1) of the variable $jwe (JWE object) into JSON Flattened serialization mode.
$token = $manager->serialize('jwe_json_flattened', $jwe, 1);

// Retrieve the JWE object from a token
$jwe = $manager->unserialize($token);
```

