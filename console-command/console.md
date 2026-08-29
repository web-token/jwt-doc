# Console Commands

The JWT Framework provides a comprehensive set of command-line tools for managing keys, key sets, and tokens. These tools are invaluable for development, testing, and production operations.

## Installation Options

The console commands are available in three different ways to suit your needs:

### 1. Standalone Application
Perfect for quick operations without a full project setup.
- **[Learn more](standalone.md)**

### 2. Symfony Console Integration
Integrated into your Symfony application's console.
- **[Learn more](symfony-console.md)**

### 3. PHAR (PHP Archive)
A self-contained executable file that works anywhere PHP is installed.
- **[Learn more](phar-application.md)**
- Download the latest PHAR from the [releases page](https://github.com/web-token/jwt-framework/releases)

## Quick Start

{% hint style="info" %}
In the following examples, we use `./jose.phar` as the command prefix. Replace it with:
- `php bin/console jose:` if using Symfony Console
- `vendor/bin/jose` if using the standalone application
{% endhint %}

### Getting Help

All commands support the `--help` option for detailed usage information:

```bash
./jose.phar key:generate --help
```

### Saving Output to Files

You can easily save command output to files for later use:

```bash
# Generate and save a new key
./jose.phar key:generate:oct 256 > secret-key.json

# Convert a key and save it
./jose.phar key:convert:pkcs1 '{"kty":"EC",...}' > key.pem
```

## Command Categories

The console commands are organized into logical categories:

### 🔑 Key Management
Create, convert, analyze, and optimize cryptographic keys:
- Generate new keys (RSA, EC, OKP, oct)
- Convert between formats (JWK, PEM, DER, PKCS#1, PKCS#8)
- Extract public keys from private keys
- Analyze key security
- Optimize RSA keys for performance
- Calculate key thumbprints

### 📦 Key Set Management
Manage collections of keys:
- Merge multiple key sets
- Convert all keys in a set
- Analyze all keys in a set
- Extract specific keys from sets

### 🔄 Key Loading
Load keys from various sources:
- Load from files (JWK, PEM, DER)
- Load from URLs (JKU, X5U)
- Load from X.509 certificates
- Load from PKCS#12 bundles

## Usage Examples

### Generate a New Symmetric Key

```bash
# Generate a 256-bit symmetric key
./jose.phar key:generate:oct 256
```

Output:
```json
{"kty":"oct","k":"Base64UrlEncodedKey..."}
```

### Generate an RSA Key Pair

```bash
# Generate a 2048-bit RSA key with usage information
./jose.phar key:generate:rsa 2048 --use sig --alg RS256
```

### Convert a Private Key to Public Key

```bash
./jose.phar key:convert:public '{"kty":"EC","crv":"P-256","d":"...",...}'
```

## Command Reference

### Key Management Commands

#### Private Key To Public Key Converter

This command will convert a private key into a public key. It has no effect on shared keys (e.g. `oct` keys).

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

#### PKCS#1 Key Converter

This command will convert a RSA or EC key into PKCS#1 key.

```bash
./jose.phar key:convert:pkcs1 '{"kty":"EC","crv":"P-256","d":"kiNCxSbRjlAbHrEbrwVKS8vIXUh6URChrmw","x":"-wdLWDWCZP6oFYl8aGVfU0MsFlckjaSVrO7hEsc8lgk","y":"rt8XDTalLMCRB5Tu9WQc2d0TOVwXXHkVDbI7cIig6r4"}'

-----BEGIN EC PRIVATE KEY-----
MHcCAQEEIJIjQsUm0Y5QGx6xG68N4GrprVrFSkvLyF1IelEQoa5soAoGCCqGSM49
AwEHoUQDQgAE+wdLWDWCZP6oFYl8aGVfU0MsFlckjaSVrO7hEsc8lgmu3xcNNqUs
wJEHlO71ZBzZ3RM5XBdceRUNsjtwiKDqvg==
-----END EC PRIVATE KEY-----
```

#### PKCS#8 Key Converter

This command will convert a `RSA`, `EC` or `OKP` key into a PKCS#8 key. It is the counterpart of `key:convert:pkcs1`, for the projects that share keys with libraries only able to import PKCS#8 private keys, such as the npm `jose` package.

```bash
./jose.phar key:convert:pkcs8 '{"kty":"EC","crv":"P-256","d":"kiNCxSbRjlAbHrEbrwVKS8vIXUh6URChrmw","x":"-wdLWDWCZP6oFYl8aGVfU0MsFlckjaSVrO7hEsc8lgk","y":"rt8XDTalLMCRB5Tu9WQc2d0TOVwXXHkVDbI7cIig6r4"}'

-----BEGIN PRIVATE KEY-----
MIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQgkiNCxSbRjlAbHrEb
rw3gaumtWsVKS8vIXUh6URChrmyhRANCAAT7B0tYNYJk/qgViXxoZV9TQywWVySN
pJWs7uESxzyWCa7fFw02pSzAkQeU7vVkHNndEzlcF1x5FQ2yO3CIoOq+
-----END PRIVATE KEY-----
```

As PKCS#8 only covers private keys, public keys are converted into a `SubjectPublicKeyInfo` structure:

```bash
./jose.phar key:convert:pkcs8 '{"kty":"EC","crv":"P-256","x":"-wdLWDWCZP6oFYl8aGVfU0MsFlckjaSVrO7hEsc8lgk","y":"rt8XDTalLMCRB5Tu9WQc2d0TOVwXXHkVDbI7cIig6r4"}'

-----BEGIN PUBLIC KEY-----
MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE+wdLWDWCZP6oFYl8aGVfU0MsFlck
jaSVrO7hEsc8lgmu3xcNNqUswJEHlO71ZBzZ3RM5XBdceRUNsjtwiKDqvg==
-----END PUBLIC KEY-----
```

{% hint style="info" %}
Unlike `key:convert:pkcs1`, this command also handles `OKP` keys (`Ed25519`, `X25519`). It supports every curve of the framework, the [Brainpool](../the-components/key-jwk-and-key-set-jwkset/key-management.md#elliptic-curve-key-pair) ones included.
{% endhint %}

#### Key Generators

The key generator commands will generate a private or shared key. The following options are available:

* `-u` or `--use`: indicates the usage of the key (`sig` or `enc`): `--use enc`. _This option is highly recommended_.
* `-a` or `--alg`: indicates the algorithm to be used with the key: `--alg RSA-OAEP-256`. _This option is highly recommended_.

**Elliptic Curve Key**

This command will generate an Elliptic Curve key (EC). The supported curves are `P-256`, `P-384` and `P-521`.

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

This command will generate a octet key (oct). Recommended size is 128 bits or more.

```bash
./jose.phar key:generate:oct 256

{"kty":"oct","k":"kWpZXidz3sVVx2Jn1J-5ANXnA2IKwfIAY2CoBW1q7I0"}
```

**Octet Key Pair Key**

This command will generate a octet key pair key (OKP). Supported curves are `X25519` (for encryption only) and `Ed25519` (signature only).

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

If you already have a secret, you can use it to create an octet key (`oct`).

```bash
./jose.phar key:generate:from_secret "This is my secret"
```

In case your secret is binary string, you will have to encode it first (Base64) and indicate it is encoded.

```bash
./jose.phar key:generate:from_secret "VGhpcyBpcyBteSBzZWNyZXQ=" --is_b64
```

#### Key Loaders

The key loader commands will load keys from various sources. The following options are available:

* `-u` or `--use`: indicates the usage of the key (`sig` or `enc`): `--use enc`. _This option is highly recommended_.
* `-a` or `--alg`: indicates the algorithm to be used with the key: `--alg RSA-OAEP-256`. _This option is highly recommended_.

**Convert From PEM/DER Keys**

This command can load and convert a DER/PEM key file into a JWK. It supports encrypted keys as well as PKCS#1 and PKCS#8 encodings or public/private keys.

```bash
./jose.phar key:load:key /path/to/file.pem "This is my secret to decrypt the key"

{"kty":"OKP","crv":"X25519","x":"TgTD7RS0KF3eU8HdTM6ACxu365uco3x2Cee9SBXiu2I","d":"BypCXV7KUai-zrwrdoAmgnHX6Kosw0sVpDVPwrXoNKY"}
```

**Convert From PKCS#12 Keys**

This command can load and convert a PKCS#12 key file into a JWK. It supports encrypted keys.

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

This command optimizes a RSA key by calculating additional primes (CRT). The following option is available:

```bash
./jose.phar key:optimize '{"kty":"RSA","n":"l4mLzvr6ewIWrPvP6j5PYp0yPRhtkMW1F-dbQ1VWGoB_Mq5IIuflOo7W2ERyh71exUGkmvoesWL3zCtFIOnlxw","e":"AQAB","d":"lxh8oLq7el9QwNasL0JF4WwgJa7vwISB1v3Gj9LM8cpZPqXnPGPeoE5QAOUi1bJsIEqzHsR-rnLHsarlTfXMIQ"}'

{"kty":"RSA","n":"l4mLzvr6ewIWrPvP6j5PYp0yPRhtkMW1F-dbQ1VWGoB_Mq5IIuflOo7W2ERyh71exUGkmvoesWL3zCtFIOnlxw","e":"AQAB","d":"lxh8oLq7el9QwNasL0JF4WwgJa7vwISB1v3Gj9LM8cpZPqXnPGPeoE5QAOUi1bJsIEqzHsR-rnLHsarlTfXMIQ","p":"w0WuNlrO16rSPKHQn02FsOwzczlchC9ZpdS-00JKOr8","q":"xqn5LMfXwhWK-RGlXkSUHKCPb-SLKV8f8p41pDkjvvk","dp":"NGGAtfvt-FROSQ1vFQyKjEcQFhyRALRi6-UBu1HQ76k","dq":"kUqaO4_kUcNjogivwqOxFsauYIzq4dT6Dnx6iqJnbDE","qi":"TwJ4WOG0r1q6vZ13Kze2HPXtlnllyq9ZfClrVwovC_I"}
```

_RSA keys generated by this framework are already optimized. This command may be needed when you import RSA keys from external sources._ _The optimization is not mandatory but highly recommended. Cryptographic operations are up to 10 times faster._

#### Key Thumbprint

This command will calculate the key thumbprint as per the [RFC7638](https://tools.ietf.org/html/rfc7638). The following options are available:

* `--hash`: the hashing method. Default is `sha256`. Supported methods are the one listed by [`hash_algos`](http://php.net/manual/en/function.hash-algos.php).

```bash
./jose.phar key:thumbprint '{"kty":"RSA","n":"l4mLzvr6ewIWrPvP6j5PYp0yPRhtkMW1F-dbQ1VWGoB_Mq5IIuflOo7W2ERyh71exUGkmvoesWL3zCtFIOnlxw","e":"AQAB","d":"lxh8oLq7el9QwNasL0JF4WwgJa7vwISB1v3Gj9LM8cpZPqXnPGPeoE5QAOUi1bJsIEqzHsR-rnLHsarlTfXMIQ","p":"xqn5LMfXwhWK-RGlXkSUHKCPb-SLKV8f8p41pDkjvvk","q":"w0WuNlrO16rSPKHQn02FsOwzczlchC9ZpdS-00JKOr8","dp":"kUqaO4_kUcNjogivwqOxFsauYIzq4dT6Dnx6iqJnbDE","dq":"NGGAtfvt-FROSQ1vFQyKjEcQFhyRALRi6-UBu1HQ76k","qi":"dkguRXkQcrvYbvFcnmGrcjIs36FJa-1dtd7QCRYHTBo"}'

gNur2UtA8NMAoxJfgMYhJqnuWR8u-60aeRbKtZwj4DE
```

### Keyset Management Commands

#### Private Keys To Public Keys Converter

This command has the same effect as `key:convert:public` except that it will convert all keys in the keyset. It has no effect on shared keys (e.g. `oct` keys).

```bash
./jose.phar keyset:convert:public '<keyset here>'

<public keyset>
```

#### Key Analyze

This command has the same behaviour as `key:analyze` except that it will analyze all keys in the keyset.

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
