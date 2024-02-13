# The Framework

The JWT Framework is the main package and contains all features and components described in this documentation. It is split in several sub-packages depending on your needs.

* `web-token/jwt-framework`: The complete framework
  * `web-token/jwt-library`: The library and all its components
  * `web-token/jwt-bundle`: The Symfony bundle
  * `web-token/jwt-experimental`: All experimental features

{% hint style="warning" %}
We highly recommend the use of the dedicated package instead installing the whole JWT Framork
{% endhint %}



{% hint style="danger" %}
Other packages mentioned in the previous documentation version are deprecated and grouped under the `web-token/jwt-library`.

Please make sure all dependencies such as OpenSSL, libSodium, AESKW library and so on are kept.
{% endhint %}
