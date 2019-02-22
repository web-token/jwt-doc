---
description: How to use Symfony events
---

# Events

With the version 2.0 of the Symfony Bundle, you will be able to listen or subscribe to events.

All events can be found in the class `Jose\Bundle\JoseFramework\Event\Events`.

* **JWS:**
  * Events::JWS\_BUILT\_SUCCESS
  * Events::JWS\_BUILT\_FAILURE
  * Events::JWS\_VERIFICATION\_SUCCESS
  * Events::JWS\_VERIFICATION\_FAILURE
  * Events::JWS\_LOADING\_SUCCESS
  * Events::JWS\_LOADING\_FAILURE
* **JWE:**
  * Events::JWE\_BUILT\_SUCCESS
  * Events::JWE\_BUILT\_FAILURE
  * Events::JWE\_DECRYPTION\_SUCCESS
  * Events::JWE\_DECRYPTION\_FAILURE
  * Events::JWE\_LOADING\_SUCCESS
  * Events::JWE\_LOADING\_FAILURE
* **Nested Tokens:**
  * Events::NESTED\_TOKEN\_ISSUED Events::NESTED\_TOKEN\_LOADING\_SUCCESS Events::NESTED\_TOKEN\_LOADING\_FAILURE
* **Checked Header:**
  * Events::HEADER\_CHECK\_SUCCESS
  * Events::HEADER\_CHECK\_FAILURE
* **Checked Claim:**
  * Events::CLAIM\_CHECK\_SUCCESS
  * Events::CLAIM\_CHECK\_FAILURE

### Example:

{% code-tabs %}
{% code-tabs-item title="App\\EventSubscriber\\JwsSubscriber.php" %}
```php
<?php

declare(strict_types=1);

namespace App\EventSubscriber;

use Jose\Bundle\JoseFramework\Event\Events;
use Jose\Bundle\JoseFramework\Event\JWSBuiltSuccessEvent;
use Jose\Bundle\JoseFramework\Event\JWSVerificationFailureEvent;
use Jose\Bundle\JoseFramework\Event\JWSVerificationSuccessEvent;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;

class JwsSubscriber implements EventSubscriberInterface
{
    public static function getSubscribedEvents()
    {
        return [
            Events::JWS_VERIFICATION_SUCCESS => ['onJwsVerificationSuccess'],
            Events::JWS_VERIFICATION_FAILURE => ['onJwsVerificationFailure'],
            Events::JWS_BUILT_SUCCESS => ['onJwsBuiltSuccess'],
            Events::JWS_BUILT_FAILURE => ['onJwsBuiltFailure'],
        ];
    }

    public function onJwsVerificationSuccess(JWSVerificationSuccessEvent $event): void
    {
        // Do something here
    }

    public function onJwsVerificationFailure(JWSVerificationFailureEvent $event): void
    {
        // Do something here
    }

    public function onJwsBuiltSuccess(JWSBuiltSuccessEvent $event): void
    {
        // Do something here
    }

    public function onJwsBuiltFailure(JWSBuiltFailureEvent $event): void
    {
        // Do something here
    }
}
```
{% endcode-tabs-item %}
{% endcode-tabs %}

