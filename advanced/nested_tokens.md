Nested Tokens
=============

JWT can be signed or encrypted and both operations can be performed when you needed.
This library is able to create and load nested tokens, but at the moment there is no build in class to do that.

There are few recommendations to follow when you want to deal with nested tokens:

1. You have to set the following header parameters. These headers indicate that the token contains another token.
    * `typ`: `JWT`,
    * `cty`: `JWT`.
2. The token MUST first be signed, then encrypted

**The order is very important**.
If you first encrypt then you sign, the signature can be removed in favour of another one using a weaker algorithm are a corrupted key.
Moreover, it protects the signer privacy by hiding information that could be set in the JWS header.
