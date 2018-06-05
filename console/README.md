# Console

The project comes with console commands.  
They are available:

* [as a standalone command](standalone.md)
* [through the dedicated Symfony console command](symfony-console.md)
* [as a PHAR \(PHP Archive\)](phar-application.md)

## Available Commands

In the following example, we will call commands using `./jose.phar`. If you need more information about a command, call the command with the option `--help`.

### Key Management Commands

#### Private Key To Public Key Converter

This command will convert a private key into a public key. It has no effect on shared keys \(e.g. `oct` keys\).

```bash
./jose.phar key:convert:public '{"kty":"EC","crv":"P-256","d":"kiNCxSbRjlAbHrEbrwVKS8vIXUh6URChrmw","x":"-wdLWDWCZP6oFYl8aGVfU0MsFlckjaSVrO7hEsc8lgk","y":"rt8XDTalLMCRB5Tu9WQc2d0TOVwXXHkVDbI7cIig6r4"}'

{"kty":"EC","crv":"P-256","x":"-wdLWDWCZP6oFYl8aGVfU0MsFlckjaSVrO7hEsc8lgk","y":"rt8XDTalLMCRB5Tu9WQc2d0TOVwXXHkVDbI7cIig6r4"}
```

#### Key Analyze

The following command will analyze the key passed as argument and find issues.

```bash
./jose.phar key:analyze '{"kty":"oct","k":"N2aIJSQCxTo"}'

The parameter "alg" should be added.
The parameter "use" should be added.
The parameter "kid" should be added.
The key length is less than 128 bits.
```

#### PKCS\#1 Key Converter

This command will convert a RSA or EC key into PKCS\#1 key.

```bash
./jose.phar key:convert:pkcs1 '{"kty":"EC","crv":"P-256","d":"kiNCxSbRjlAbHrEbrwVKS8vIXUh6URChrmw","x":"-wdLWDWCZP6oFYl8aGVfU0MsFlckjaSVrO7hEsc8lgk","y":"rt8XDTalLMCRB5Tu9WQc2d0TOVwXXHkVDbI7cIig6r4"}'

-----BEGIN EC PRIVATE KEY-----
MHcCAQEEIJIjQsUm0Y5QGx6xG68N4GrprVrFSkvLyF1IelEQoa5soAoGCCqGSM49
AwEHoUQDQgAE+wdLWDWCZP6oFYl8aGVfU0MsFlckjaSVrO7hEsc8lgmu3xcNNqUs
wJEHlO71ZBzZ3RM5XBdceRUNsjtwiKDqvg==
-----END EC PRIVATE KEY-----
```

#### Key Generators

The key generator commands will generate a private or shared key. The following options are available:

* `-o` or `--out`: save the output into a file: `--out private.key`.
* `-u` or `--use`: indicates the usage of the key \(`sig` or `enc`\): `--use enc`. _This option is highly recommended_.
* `-a` or `--alg`: indicates the algorithm to be used with the key: `--alg RSA-OAEP-256`. _This option is highly recommended_.

**Elliptic Curve Key**

This command will generate an Elliptic Curve key \(EC\). The supported curves are `P-256`, `P-384` and `P-521`.

```bash
./jose.phar key:generate:ec P-256

{"kty":"EC","crv":"P-256","d":"BZ231BFhhHAhx-D4myu4O1hi-vUHnRqxoCsQKUKFNrA","x":"Tv5YeQuD1CWDbfre65kYX2Lq_MGnUq0Ek2yUFixy31M","y":"pj0FyoGaByyBlt5RbTHhBdgcC-S6cgxzLpxd6mGmsbM"}
```

**RSA Key**

This command will generate a RSA key. The key size must be at least 384 bits. Recommended size is 2048 bits or more.

```bash
./jose.phar key:generate:rsa 512

{"kty":"RSA","n":"l1UPHqgOFThDUlfrP2DFnCwsD5ITls12nXer6A4YepUP_DnF9mFoXCkyflA_TOJtFiZW6NXWOY0NdE3YjzT-qQ","e":"AQAB","d":"CxVvxg8I-QTl6WIHGN09m_KgR4Ora6Agz-ez74sYv-GONPD3yjEWeAavdOsGK8iJX4Pe1Qss52VKddeKRQ9LAQ","p":"xkR0kbThGGD8HYtfPUv5Ds1zE5LlQvYgBiv15eOk9ns","q":"w2Xk86kiaRhXWXM8XPJ5Tn6bdTT6thzoqazuIO53SCs","dp":"RCBLibGEUvMoTiKQtChByRNRQl2MR2j48gXy9W42Rbc","dq":"T0x5910LxwUG5hl7ROluy6lcI9wFZ4Uh80JoPdspc5M","qi":"Z73ha9Fmg6s-rgRbF0dG0QMd1aY9g1i8qnAxXp3JMus"}
```

**Octet Key**

This command will generate a octet key \(oct\). Recommended size is 128 bits or more.

```bash
./jose.phar key:generate:oct 256

{"kty":"oct","k":"kWpZXidz3sVVx2Jn1J-5ANXnA2IKwfIAY2CoBW1q7I0"}
```

**Octet Key Pair Key**

This command will generate a octet key pair key \(OKP\). Supported curves are `X25519` \(for encryption only\) and `Ed25519` \(signature only\).

```bash
./jose.phar key:generate:okp 256

{"kty":"OKP","crv":"X25519","x":"TgTD7RS0KF3eU8HdTM6ACxu365uco3x2Cee9SBXiu2I","d":"BypCXV7KUai-zrwrdoAmgnHX6Kosw0sVpDVPwrXoNKY"}
```

**None Key**

This command will generate a none key. This key type is only used by the `none` algorithm. Key parameters `alg` and `use` are automatically set.

```bash
./jose.phar key:generate:none

{"kty":"none","use":"sig","alg":"none"}
```

**From An Existing Secret**

> This feature was introduced in version 1.1.

If you already have a secret, you can use it to create an octet key \(`oct`\).

```bash
./jose.phar key:generate:from_secret "This is my secret"
```

In case your secret is binary string, you will have to encode it first \(Base64\) and indicate it is encoded.

```bash
./jose.phar key:generate:from_secret "VGhpcyBpcyBteSBzZWNyZXQ=" --is_b64
```

#### Key Loaders

The key loader commands will loader keys from various sources. The following options are available:

* `-o` or `--out`: save the output into a file: `--out private.key`.
* `-u` or `--use`: indicates the usage of the key \(`sig` or `enc`\): `--use enc`. _This option is highly recommended_.
* `-a` or `--alg`: indicates the algorithm to be used with the key: `--alg RSA-OAEP-256`. _This option is highly recommended_.

**Convert From PEM/DER Keys**

This command can load and convert a DER/PEM key file into a JWK. It supports encrypted keys as well as PKCS\#1 and PKCS\#8 encodings or public/private keys.

```bash
./jose.phar key:load:key /path/to/file.pem "This is my secret to decrypt the key"

{"kty":"OKP","crv":"X25519","x":"TgTD7RS0KF3eU8HdTM6ACxu365uco3x2Cee9SBXiu2I","d":"BypCXV7KUai-zrwrdoAmgnHX6Kosw0sVpDVPwrXoNKY"}
```

**Convert From PKCS\#12 Keys**

This command can load and convert a PKCS\#12 key file into a JWK. It supports encrypted keys.

```bash
./jose.phar key:load:p12 /path/to/file.p12 "This is my secret to decrypt the key"

{"kty":"OKP","crv":"X25519","x":"TgTD7RS0KF3eU8HdTM6ACxu365uco3x2Cee9SBXiu2I","d":"BypCXV7KUai-zrwrdoAmgnHX6Kosw0sVpDVPwrXoNKY"}
```

**Convert From A X.509 Certificate**

This command can load and convert a X.509 key file into a JWK.

```bash
./jose.phar key:load:x509 /path/to/file.cert

{"kty":"OKP","crv":"X25519","x":"TgTD7RS0KF3eU8HdTM6ACxu365uco3x2Cee9SBXiu2I"}
```

#### RSA Key Optimization

This command optimizes a RSA key by calculating additional primes \(CRT\). The following option is available:

* `-o` or `--out`: save the output into a file: `--out private.key`.

```bash
./jose.phar key:optimize '{"kty":"RSA","n":"l4mLzvr6ewIWrPvP6j5PYp0yPRhtkMW1F-dbQ1VWGoB_Mq5IIuflOo7W2ERyh71exUGkmvoesWL3zCtFIOnlxw","e":"AQAB","d":"lxh8oLq7el9QwNasL0JF4WwgJa7vwISB1v3Gj9LM8cpZPqXnPGPeoE5QAOUi1bJsIEqzHsR-rnLHsarlTfXMIQ"}'

{"kty":"RSA","n":"l4mLzvr6ewIWrPvP6j5PYp0yPRhtkMW1F-dbQ1VWGoB_Mq5IIuflOo7W2ERyh71exUGkmvoesWL3zCtFIOnlxw","e":"AQAB","d":"lxh8oLq7el9QwNasL0JF4WwgJa7vwISB1v3Gj9LM8cpZPqXnPGPeoE5QAOUi1bJsIEqzHsR-rnLHsarlTfXMIQ","p":"w0WuNlrO16rSPKHQn02FsOwzczlchC9ZpdS-00JKOr8","q":"xqn5LMfXwhWK-RGlXkSUHKCPb-SLKV8f8p41pDkjvvk","dp":"NGGAtfvt-FROSQ1vFQyKjEcQFhyRALRi6-UBu1HQ76k","dq":"kUqaO4_kUcNjogivwqOxFsauYIzq4dT6Dnx6iqJnbDE","qi":"TwJ4WOG0r1q6vZ13Kze2HPXtlnllyq9ZfClrVwovC_I"}
```

_RSA keys generated by this framework are already optimized. This command may be needed when you import RSA keys from external sources._ _The optimization is not mandatory but highly recommended. cryptographic operations are up to 10 times faster._

#### Key Thumbprint

This command will calculate the key thumbprint as per the [RFC7638](https://tools.ietf.org/html/rfc7638). The following options are available:

* `-o` or `--out`: save the output into a file: `--out private.key`.
* `--hash`: the hashing method. Default is `sha256`. Supported methods are the one listed by [`hash_algos`](http://php.net/manual/en/function.hash-algos.php).

```bash
./jose.phar key:thumbprint '{"kty":"RSA","n":"l4mLzvr6ewIWrPvP6j5PYp0yPRhtkMW1F-dbQ1VWGoB_Mq5IIuflOo7W2ERyh71exUGkmvoesWL3zCtFIOnlxw","e":"AQAB","d":"lxh8oLq7el9QwNasL0JF4WwgJa7vwISB1v3Gj9LM8cpZPqXnPGPeoE5QAOUi1bJsIEqzHsR-rnLHsarlTfXMIQ","p":"xqn5LMfXwhWK-RGlXkSUHKCPb-SLKV8f8p41pDkjvvk","q":"w0WuNlrO16rSPKHQn02FsOwzczlchC9ZpdS-00JKOr8","dp":"kUqaO4_kUcNjogivwqOxFsauYIzq4dT6Dnx6iqJnbDE","dq":"NGGAtfvt-FROSQ1vFQyKjEcQFhyRALRi6-UBu1HQ76k","qi":"dkguRXkQcrvYbvFcnmGrcjIs36FJa-1dtd7QCRYHTBo"}'

gNur2UtA8NMAoxJfgMYhJqnuWR8u-60aeRbKtZwj4DE
```

### Keyset Management Commands

#### Private Keys To Public Keys Converter

This command has the same affect as `key:convert:public` except that it will convert all keys in the keyset. It has no effect on shared keys \(e.g. `oct` keys\).

```bash
./jose.phar keyset:convert:public '<keyset here>'

<public keyset>
```

#### Key Analyze

This command has the same behaviour as `key:analyze` except that it will analize all keys in the keyset.

```bash
./jose.phar keyset:analyze '<keyset here>'

<keyset analyze result>
```

#### Keyset Generators

The key set generator commands will generate key sets with random keys of the same type.

These commands have the same options as the key generator commands. The only difference is that you have to indicate the number of keys you want in the key set.

Examples:

```bash
./jose.phar keyset:generate:rsa 3 512 # Create 3 RSA keys (512 bits each)
./jose.phar keyset:generate:oct 5 128 # Create 5 oct keys (128 bits each)
./jose.phar keyset:generate:okp 2 X25519 # Create 2 OKP keys (curve X25519)
./jose.phar keyset:generate:ec 3 P-521 # Create 3 EC keys (curve P-521)
```

The result of these commands is a JWKSet object.

#### Key Set Modification

* `keyset:add:key`:         Add a key into a key set.
* `keyset:merge`:           Merge several key sets into one.
* `keyset:rotate`:          Rotate a key set.

#### Distant Key Set Loading

* `keyset:load:jku`:        Loads a key set from an url.
* `keyset:load:x5u`:        Loads a key set from an url.

