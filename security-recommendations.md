# Security Recommendations

## Security Recommendations

Signed or Encrypted Tokens are not just the next trendy/popular way to authenticate users. They provide great features but when used incorrectly they can expose your application to major security issues.

Please read the following recommendations carefully.

## Algorithms

### Algorithm Choice

If all parties are able to protect their keys \(e.g. private applications\), symmetric algorithms are a good choice as they are faster in general. If you use public clients, you should prefer asymmetric algorithms.

### Available Algorithms

This framework provides dozen of signature and encryption algorithms, but you do not need all of them. Most applications only support 1 or 2 algorithms.

You should only use necessary algorithms. For example, HS384 algorithm may be avoided if you already have HS256 and HS512.

### Avoid Weak Algorithms

Some algorithms are not recommended as there are known security issues:

* `none`: this algorithm is not a real algorithm. It should only be used when other security means exist. An encrypted connection is certainly not enough!
* `RSA1_5`: there are known attacks using this algorithm. If you can avoid its use, then do it.

## Keys And Key Sets

### Key Size

A small key size is as secured as a password like `123456789`. You should use at least 256 bits symmetric keys and at lease 2048 bits RSA keys.

In any case, you MUST use a true random number generator.

### Additional Information

It is highly recommended to set the following parameters to yours key:

* `kid`: A unique key ID,
* `use`: indicates the usage of the key. Either `sig` \(signature/verification\) or `enc` \(encryption/decryption\). 
* `alg`: the algorithm allowed to be used with this key.

### Key Rotation

A key is fine but may be cracked e.g. by bruteforce. Changing you keys after several days or weeks is encouraged.

## Token Creation

### Header Parameters

Broadly speaking, you should set your header parameter in the protected header. The use of the unprotected header should be limited to specific use cases.

When using encrypted tokens, the claims `iss` and `aud` should be duplicated into the header. This will avoid unwanted decryption when tokens are sent to a wrong audience.

### Payload And Claims

There is no size constraint for the payload, but when tokens are used in a web context, it should be as small as possible. When used, claims should be limited to the minimum.

Does your application really need to get all the information about a user? For each context, you should choose carefully the claims you want to use.

#### Token Unique ID

A unique token ID should be set to all tokens you create. The associated claim is `jti`.

This claim is highly recommended as it can prevent replay attacks.

#### Time Indicators

The JWT specification introduces several claims to limit the period of validity of the tokens:

* `exp`: expiration time,
* `iat`: issuance time,
* `nbf`: validity point in time.

These claims are not mandatory, but it is recommended to define a period of time for the token validity. When used, the expiration time should be in adaquation with the context of your application. A security token with 2 weeks lifetime is something you should avoid.

#### Issuer And Audience

The claims `iss` \(issuer\) and `aud` \(audience\) should always be set. When duplicated in the header, their values MUST be identical.

## Application Communication

### Secured Connection

Unless you use encrypted tokens, you should use a secured connection when transmitting tokens between parties. A secured communication is not only needed when transmitting tokens, but also when you exchange keys and key sets with other applications.

## Loading Process

When you receive a token, the following steps should be followed in this order. If one failed, you you reject the whole token.

1. Unserialize the token
2. For each signature/recipient \(may be possible when using the Json General Serialization Mode\):
   1. Check the complete header \(protected and unprotected\)
   2. Verify the signature \(JWS\) or decrypt the token \(JWE\)
   3. Check the claims in the payload \(if any\)

### Unserialize The Token

You should only use the serialization mode\(s\) you need. If you intent to use yur tokens in a web context, then use only the Compact Serialization. If an error occurred during this process, you should consider the token as invalid.

### Check The Header

Header parameters have to be checked. You should at least check the `alg` \(algorithm\) and `enc` \(only for JWE\) parameters. The `crit` \(critical\) header parameter is always checked.

Please note that unknown header parameters are ignored. If your token is verified, those parameters should not be used.

When used, unprotected header parameters should be handled with care.

### Signature Verification / Payload Decryption

Let the component do its job. The most important step for developers is to ensure that the right key/ket set is used.

### Check The Claims

This step is only required if the payload contains claims. When present, you should always check the `exp`, `iat`, `nbf`, `iss` and `aud` claims. Application specific claims should also always checked.

The whole token should be rejected in case of failure. Unknown claims should be ignored.

## Stay Tuned

You should subscribe to security forums of similar websites and have a continuous technological watch. The tokens may be compromised because of malicious attacks on the algorithms, keys or other components related to the JWT \(directly or indirectly\).

The [Security group on Stack Exchange](https://security.stackexchange.com/) is a good start.

