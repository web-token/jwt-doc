# Result table

The table hereafter is the result of all benchmarks _with our development environment_. It is given to help you to select the appropriate algorithms for your application.

**The use of the algorithm** `ECDH-ES` **with curves** `P-256`**,** `P-384` **or** `P-521` **is not recommended on PHP7.1 or 7.2**. The cryptographic operations with those curves are done using a pure PHP function and hence very slow.

The use of the RSA algorithms with a very long key \(more that 4096 bits\) is quite slow, but offers a good protection.

The PBES2\* algorithms are quite slow, but also offer a good protection \(see [https://en.wikipedia.org/wiki/PBKDF2](https://en.wikipedia.org/wiki/PBKDF2)\). Default salt size \(512 bits\) and iterations \(4096\) and custom values \(256/1024\) used for the tests. Those values can be configured if needed.

| subject | groups | mean |
| :--- | :--- | :--- |
| sign | JWS,EdDSA,Ed25519 | 139.323μs |
| verify | JWS,EdDSA,Ed25519 | 169.125μs |
| sign | JWS,ECDSA,ES256 | 139.144μs |
| verify | JWS,ECDSA,ES256 | 223.170μs |
| sign | JWS,ECDSA,ES384 | 941.535μs |
| verify | JWS,ECDSA,ES384 | 1,075.417μs |
| sign | JWS,ECDSA,ES512 | 504.271μs |
| verify | JWS,ECDSA,ES512 | 826.615μs |
| sign | JWS,hmac,HS256 | 19.593μs |
| verify | JWS,hmac,HS256 | 24.045μs |
| sign | JWS,hmac,HS384 | 20.061μs |
| verify | JWS,hmac,HS384 | 24.672μs |
| sign | JWS,hmac,HS512 | 19.838μs |
| verify | JWS,hmac,HS512 | 24.935μs |
| sign | JWS,none | 14.021μs |
| verify | JWS,none | 17.317μs |
| sign | JWS,RSASign,PS256 | 1,310.264μs |
| verify | JWS,RSASign,PS256 | 121.113μs |
| sign | JWS,RSASign,PS384 | 1,300.622μs |
| verify | JWS,RSASign,PS384 | 119.065μs |
| sign | JWS,RSASign,PS512 | 1,302.404μs |
| verify | JWS,RSASign,PS512 | 117.445μs |
| sign | JWS,RSASign,RS256 | 1,280.885μs |
| verify | JWS,RSASign,RS256 | 106.382μs |
| sign | JWS,RSASign,RS384 | 1,280.652μs |
| verify | JWS,RSASign,RS384 | 297.263μs |
| sign | JWS,RSASign,RS512 | 1,659.753μs |
| verify | JWS,RSASign,RS512 | 119.476μs |
| encryption/decryption | JWE,GCMKW,A128GCMKW | 63.022μs, 60.639μs, 58.909μs \(with A128CBC-HS256, A192CBC-HS384, A256CBC-HS512 respectively\) |
| encryption/decryption | JWE,GCMKW,A128GCMKW | 48.335μs, 50.021μs, 49.393μs \(with A128GCM, A192GCM, A256GCM respectively\) |
| encryption/decryption | JWE,GCMKW,A192GCMKW | 59.719μs, 59.396μs, 60.329μs \(with A128CBC-HS256, A192CBC-HS384, A256CBC-HS512 respectively\) |
| encryption/decryption | JWE,GCMKW,A192GCMKW | 48.432μs, 49.295μs, 50.244μs \(with A128GCM, A192GCM, A256GCM respectively\) |
| encryption/decryption | JWE,GCMKW,A256GCMKW | 60.966μs, 60.621μs, 59.821μs \(with A128CBC-HS256, A192CBC-HS384, A256CBC-HS512 respectively\) |
| encryption/decryption | JWE,GCMKW,A256GCMKW | 48.894μs, 49.165μs, 49.224μs \(with A128GCM, A192GCM, A256GCM respectively\) |
| encryption/decryption | JWE,KW,A128KW | 159.758μs, 176.995μs, 210.580μs \(with A128CBC-HS256, A192CBC-HS384, A256CBC-HS512 respectively\) |
| encryption/decryption | JWE,KW,A128KW | 93.752μs, 117.309μs, 162.917μs \(with A128GCM, A192GCM, A256GCM respectively\) |
| encryption/decryption | JWE,KW,A192KW | 137.808μs, 176.636μs, 214.446μs \(with A128CBC-HS256, A192CBC-HS384, A256CBC-HS512 respectively\) |
| encryption/decryption | JWE,KW,A192KW | 104.048μs, 122.472μs, 138.150μs \(with A128GCM, A192GCM, A256GCM respectively\) |
| encryption/decryption | JWE,KW,A256KW | 139.867μs, 176.727μs, 208.664μs \(with A128CBC-HS256, A192CBC-HS384, A256CBC-HS512 respectively\) |
| encryption/decryption | JWE,KW,A256KW | 93.840μs, 115.313μs, 140.135μs \(with A128GCM, A192GCM, A256GCM respectively\) |
| encryption | JWE,RSAEnc,RSA1\_5 | from 178.368μs to 373.941μs \(depending on the Content Encryption Algorithm and the key size\) |
| decryption | JWE,RSAEnc,RSA1\_5 | from 354.921μs to 10,148.146μs \(depending on the Content Encryption Algorithm and the key size\) |
| encryption | JWE,RSAEnc,RSA-OAEP | from 188.228μs to 428.624μs \(depending on the Content Encryption Algorithm and the key size\) |
| decryption | JWE,RSAEnc,RSA-OAEP | from 381.853μs to 13,079.733μs \(depending on the Content Encryption Algorithm and the key size\) |
| encryption | JWE,RSAEnc,RSA-OAEP-256 | from 195.231μs to 410.868μs \(depending on the Content Encryption Algorithm and the key size\) |
| decryption | JWE,RSAEnc,RSA-OAEP-256 | from 354.090μs to 11,238.001μs \(depending on the Content Encryption Algorithm and the key size\) |
| encryption/decryption | JWE,PBES2,PBES2HS256A128KW | from 2,109.175μs \(256 bit salt / 1024 counts\) to 7,943.047μs \(512 bit salt / 4096 counts\) |
| encryption/decryption | JWE,PBES2,PBES2HS384A192KW | from 2,719.313μs \(256 bit salt / 1024 counts\) to 10,466.043μs \(512 bit salt / 4096 counts\) |
| encryption/decryption | JWE,PBES2,PBES2HS256A128KW | from 2,746.634μs \(256 bit salt / 1024 counts\) to 10,600.124μs \(512 bit salt / 4096 counts\) |
| encryption | JWE,ECDHES,ECDHESKW,ECDHESA128KW | ~45,198.922μs \(with curve P-256\) |
| encryption | JWE,ECDHES,ECDHESKW,ECDHESA128KW | ~77,320.816μs \(with curve P-384\) |
| encryption | JWE,ECDHES,ECDHESKW,ECDHESA128KW | ~120,709.648μs \(with curve P-521\) |
| encryption | JWE,ECDHES,ECDHESKW,ECDHESA128KW | ~453.445μs \(with curve X25519\) |
| decryption | JWE,ECDHES,ECDHESKW,ECDHESA128KW | ~21,249.059μs \(with curve P-256\) |
| decryption | JWE,ECDHES,ECDHESKW,ECDHESA128KW | ~37,207.750μs \(with curve P-384\) |
| decryption | JWE,ECDHES,ECDHESKW,ECDHESA128KW | ~57,072.871μs \(with curve P-521\) |
| decryption | JWE,ECDHES,ECDHESKW,ECDHESA128KW | ~387.441μs \(with curve X25519\) |
| encryption | JWE,ECDHES,ECDHESKW,ECDHESA192KW | ~44,697.707μs \(with curve P-256\) |
| encryption | JWE,ECDHES,ECDHESKW,ECDHESA192KW | ~76,731.773μs \(with curve P-384\) |
| encryption | JWE,ECDHES,ECDHESKW,ECDHESA192KW | ~124,164.813μs \(with curve P-521\) |
| encryption | JWE,ECDHES,ECDHESKW,ECDHESA192KW | ~501.742μs \(with curve X25519\) |
| decryption | JWE,ECDHES,ECDHESKW,ECDHESA192KW | ~21,603.676μs \(with curve P-256\) |
| decryption | JWE,ECDHES,ECDHESKW,ECDHESA192KW | ~36,172.617μs \(with curve P-384\) |
| decryption | JWE,ECDHES,ECDHESKW,ECDHESA192KW | ~55,530.465μs \(with curve P-521\) |
| decryption | JWE,ECDHES,ECDHESKW,ECDHESA192KW | ~378.129μs \(with curve X25519\) |
| encryption | JWE,ECDHES,ECDHESKW,ECDHESA256KW | ~44,701.426μs \(with curve P-256\) |
| encryption | JWE,ECDHES,ECDHESKW,ECDHESA256KW | ~76,805.012μs \(with curve P-384\) |
| encryption | JWE,ECDHES,ECDHESKW,ECDHESA256KW | ~121,017.648μs \(with curve P-521\) |
| encryption | JWE,ECDHES,ECDHESKW,ECDHESA256KW | ~451.094μs \(with curve X25519\) |
| decryption | JWE,ECDHES,ECDHESKW,ECDHESA256KW | ~21,335.781μs \(with curve P-256\) |
| decryption | JWE,ECDHES,ECDHESKW,ECDHESA256KW | ~36,207.594μs \(with curve P-384\) |
| decryption | JWE,ECDHES,ECDHESKW,ECDHESA256KW | ~55,440.664μs \(with curve P-521\) |
| decryption | JWE,ECDHES,ECDHESKW,ECDHESA256KW | ~377.367μs \(with curve X25519\) |
| encryption | JWE,ECDHES | ~44,762.633μs \(with curve P-256\) |
| encryption | JWE,ECDHES | ~76,660.664μs \(with curve P-384\) |
| encryption | JWE,ECDHES | ~119,539.141μs \(with curve P-521\) |
| encryption | JWE,ECDHES | ~369.992μs \(with curve X25519\) |
| decryption | JWE,ECDHES | ~21,894.422μs \(with curve P-256\) |
| decryption | JWE,ECDHES | ~37,380.137μs \(with curve P-384\) |
| decryption | JWE,ECDHES | ~58,231.930μs \(with curve P-521\) |
| decryption | JWE,ECDHES | ~263.254μs \(with curve X25519\) |

