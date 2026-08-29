# Custom Algorithm

This framework provides dozens of signature or encryption algorithms. If your application uses a custom algorithm or if another algorithm has been recently approved in the JWT context, it may be interesting to use it with this framework.

Hopefully, this is very easy. In the following example, we will create a class to use the ChaCha20 + Poly 1305 (IETF variant) encryption algorithm as a Key Encryption Algorithm.

```php
<?php

declare(strict_types=1);

namespace Acme\Algorithm;

use Base64Url\Base64Url;
use Jose\Component\Core\JWK;
use const Sodium\CRYPTO_AEAD_CHACHA20POLY1305_IETF_NPUBBYTES;

/**
 * This algorithm is a custom algorithm that use the ChaCha20 + Poly 1305 with a 192 bits nonce (IETF variant).
 */
final class ChaCha20Poly1305IETF implements KeyEncryption //The algorithm acts as a Key Encryption algorithm
{
    /**
     * {@inheritdoc}
     */
    public function name(): string
    {
        return 'ChaCha20+Poly1305+IETF'; // The name of our algorithm. This name will be used in our JWE headers
    }

    /**
     * {@inheritdoc}
     */
    public function allowedKeyTypes(): array
    {
        return ['oct']; // Key types for this algorithm are octet keys
    }

    /**
     * {@inheritdoc}
     */
    public function encryptKey(JWK $key, string $cek, array $completeHeader, array &$additionalHeader): string
    {
        $this->checkKey($key); // We check the key
        $kek = Base64Url::decode($key->get('k')); // We retrieve the secret
        $nonce = random_bytes(CRYPTO_AEAD_CHACHA20POLY1305_IETF_NPUBBYTES); // We create a nonce
        $additionalHeader['nonce'] = Base64Url::encode($nonce); // We add the nonce to the header

        return sodium_crypto_aead_chacha20poly1305_ietf_encrypt($cek, '', $nonce, $kek); // We return the encrypted CEK
    }

    /**
     * {@inheritdoc}
     */
    public function decryptKey(JWK $key, string $encrypted_cek, array $header): string
    {
        $this->checkKey($key); // We check the key
        $this->checkAdditionalParameters($header); // We verify the nonce is in the headers
        $nonce = Base64Url::decode($header['nonce']); // We retrieve the nonce
        $kek = Base64Url::decode($key->get('k')); // an the secret

        $decrypted = sodium_crypto_aead_chacha20poly1305_ietf_decrypt($encrypted_cek, '', $nonce, $kek); // We try to decrypt the CEK
        if (false === $decrypted) { // If it fails we throw an exception
            throw new \RuntimeException('Unable to decrypt.');
        }

        return $decrypted; // Otherwise we return the decrypted CEK
    }

    /**
     * @param JWK $key
     */
    protected function checkKey(JWK $key)
    {
        if (!in_array($key->get('kty'), $this->allowedKeyTypes())) {
            throw new \InvalidArgumentException('Wrong key type.');
        }
        if (!$key->has('k')) {
            throw new \InvalidArgumentException('The key parameter "k" is missing.');
        }
    }

    /**
     * @param array $header
     */
    protected function checkAdditionalParameters(array $header)
    {
        foreach (['nonce'] as $k) {
            if (!array_key_exists($k, $header)) {
                throw new \InvalidArgumentException(sprintf('Parameter "%s" is missing.', $k));
            }
        }
    }

    /**
     * {@inheritdoc}
     */
    public function getKeyManagementMode(): string
    {
        return self::MODE_ENCRYPT; //Key Management Mode is 'enc'.
    }
}
```

## The Expected CEK Size

Since 4.2, the `JWEDecrypter` passes the size of the key expected by the content encryption algorithm as an **additional argument** of `KeyEncryption::decryptKey()` and `KeyWrapping::unwrapKey()`. The value is the one returned by `ContentEncryptionAlgorithm::getCEKSize()`, in bits.

Algorithms that need it may implement a constant-time behaviour on failure instead of leaking it through an exception. This is what `RSA1_5` does for its implicit rejection.

The argument is not declared in the interfaces yet, so that existing implementations keep working: those that do not expect it simply ignore it, the others read it with `func_num_args()`/`func_get_arg(3)`.

```php
public function decryptKey(JWK $key, string $encrypted_cek, array $header): string
{
    // The expected CEK size, in bits, or null when the caller does not provide it.
    $encryptionKeyLength = func_num_args() > 3 ? func_get_arg(3) : null;

    // ...
}
```

{% hint style="warning" %}
The argument will be added to the interfaces and become **required** in 5.0. If you maintain a custom key encryption or key wrapping algorithm, start reading it now.
{% endhint %}

