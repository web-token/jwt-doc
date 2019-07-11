# The "Easy" Way

In version 2.1, an "Easy" component will be released. With this component you will be able to produce and consume tokens an easy way.

* Step 1: install the package and the algorithms you want to use.
* Step 2: create your scripts.

### Installation



### JWS Creation And Verification

In the following example, we will create a signed token \(JWS\) with a set of standard and custom claims and headers.

```php
use Jose\Component\Core\JWK;
use Jose\Easy\Build;

$time = time(); // The current time

$jwk = new JWK([
    'kty' => 'RSA',
    'kid' => 'bilbo.baggins@hobbiton.example',
    'use' => 'sig',
    'n' => 'n4EPtAOCc9AlkeQHPzHStgAbgs7bTZLwUBZdR8_KuKPEHLd4rHVTeT-O-XV2jRojdNhxJWTDvNd7nqQ0VEiZQHz_AJmSCpMaJMRBSFKrKb2wqVwGU_NsYOYL-QtiWN2lbzcEe6XC0dApr5ydQLrHqkHHig3RBordaZ6Aj-oBHqFEHYpPe7Tpe-OfVfHd1E6cS6M1FZcD1NNLYD5lFHpPI9bTwJlsde3uhGqC0ZCuEHg8lhzwOHrtIQbS0FVbb9k3-tVTU4fg_3L_vniUFAKwuCLqKnS2BYwdq_mzSnbLY7h_qixoR7jig3__kRhuaxwUkRz5iaiQkqgc5gHdrNP5zw',
    'e' => 'AQAB',
    'd' => 'bWUC9B-EFRIo8kpGfh0ZuyGPvMNKvYWNtB_ikiH9k20eT-O1q_I78eiZkpXxXQ0UTEs2LsNRS-8uJbvQ-A1irkwMSMkK1J3XTGgdrhCku9gRldY7sNA_AKZGh-Q661_42rINLRCe8W-nZ34ui_qOfkLnK9QWDDqpaIsA-bMwWWSDFu2MUBYwkHTMEzLYGqOe04noqeq1hExBTHBOBdkMXiuFhUq1BU6l-DqEiWxqg82sXt2h-LMnT3046AOYJoRioz75tSUQfGCshWTBnP5uDjd18kKhyv07lhfSJdrPdM5Plyl21hsFf4L_mHCuoFau7gdsPfHPxxjVOcOpBrQzwQ',
    'p' => '3Slxg_DwTXJcb6095RoXygQCAZ5RnAvZlno1yhHtnUex_fp7AZ_9nRaO7HX_-SFfGQeutao2TDjDAWU4Vupk8rw9JR0AzZ0N2fvuIAmr_WCsmGpeNqQnev1T7IyEsnh8UMt-n5CafhkikzhEsrmndH6LxOrvRJlsPp6Zv8bUq0k',
    'q' => 'uKE2dh-cTf6ERF4k4e_jy78GfPYUIaUyoSSJuBzp3Cubk3OCqs6grT8bR_cu0Dm1MZwWmtdqDyI95HrUeq3MP15vMMON8lHTeZu2lmKvwqW7anV5UzhM1iZ7z4yMkuUwFWoBvyY898EXvRD-hdqRxHlSqAZ192zB3pVFJ0s7pFc',
    'dp' => 'B8PVvXkvJrj2L-GYQ7v3y9r6Kw5g9SahXBwsWUzp19TVlgI-YV85q1NIb1rxQtD-IsXXR3-TanevuRPRt5OBOdiMGQp8pbt26gljYfKU_E9xn-RULHz0-ed9E9gXLKD4VGngpz-PfQ_q29pk5xWHoJp009Qf1HvChixRX59ehik',
    'dq' => 'CLDmDGduhylc9o7r84rEUVn7pzQ6PF83Y-iBZx5NT-TpnOZKF1pErAMVeKzFEl41DlHHqqBLSM0W1sOFbwTxYWZDm6sI6og5iTbwQGIC3gnJKbi_7k_vJgGHwHxgPaX2PnvP-zyEkDERuf-ry4c_Z11Cq9AqC2yeL6kdKT1cYF8',
    'qi' => '3PiqvXQN0zwMeE-sBvZgi289XP9XCQF3VWqPzMKnIgQp7_Tugo6-NZBKCQsMf3HaEGBjTVJs_jcK8-TRXvaKe-7ZMaQj8VfBdYkssbu0NKDDhjJ-GtiseaDVWt7dcH0cfwxgFUHpQh7FoCrjFJ6h6ZEpMF6xmujs4qMpPz8aaI4',
]);
$jws = Build::jws() // We build a JWS
    ->exp($time + 3600) // The "exp" claim
    ->iat($time) // The "iat" claim
    ->nbf($time) // The "nbf" claim
    ->jti('0123456789', true) // The "jti" claim.
                              // The second argument indicate this pair shall be duplicated in the header
    ->alg('RS512') // The signature algorithm. A string or an algorithm class.
    ->iss('issuer') // The "iss" claim
    ->aud('audience1') // Add an audience ("aud" claim)
    ->aud('audience2') // Add another audience
    ->sub('subject') // The "sub" claim
    ->claim('https://example.com/isRoot', true)
    ->header('prefs', ['field1', 'field7'])
    ->sign($jwk) // Compute the token with the given JWK
;

echo $jws; // The variable $jws now contains your token
```

A token you received can be read and verified. Verification is done on the signature and the claims or header parameters you want.

```php
use Jose\Component\Core\JWK;
use Jose\Easy\Validate;

$jwk = new JWK([
    'kty' => 'RSA',
    'kid' => 'bilbo.baggins@hobbiton.example',
    'use' => 'sig',
    'n' => 'n4EPtAOCc9AlkeQHPzHStgAbgs7bTZLwUBZdR8_KuKPEHLd4rHVTeT-O-XV2jRojdNhxJWTDvNd7nqQ0VEiZQHz_AJmSCpMaJMRBSFKrKb2wqVwGU_NsYOYL-QtiWN2lbzcEe6XC0dApr5ydQLrHqkHHig3RBordaZ6Aj-oBHqFEHYpPe7Tpe-OfVfHd1E6cS6M1FZcD1NNLYD5lFHpPI9bTwJlsde3uhGqC0ZCuEHg8lhzwOHrtIQbS0FVbb9k3-tVTU4fg_3L_vniUFAKwuCLqKnS2BYwdq_mzSnbLY7h_qixoR7jig3__kRhuaxwUkRz5iaiQkqgc5gHdrNP5zw',
    'e' => 'AQAB'
]);
$jwt = Validate::token($jws) // We want to validate the token in the variable $jws
    ->algs(['RS256', 'RS512']) // The algorithms allowed to be used
    ->exp() // We check the "exp" claim
    ->iat(1000) // We check the "iat" claim. Leeway is 1000ms (1s)
    ->nbf() // We check the "nbf" claim
    ->aud('audience1') // Allowed audience
    ->iss('issuer') // Allowed issuer
    ->sub('subject') // Allowed subject
    ->jti('0123456789') // Token ID
    ->key($jwk) // Key used to verify the signature
    ->run() // Go!
;
```

If everything is ok, the variable `$jwt` contains a `Jose\Easy\JWT` object. This object has 2 properties: `header` and `claim` containing the loaded values.

### JWE Creation And Decryption

