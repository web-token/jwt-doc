PHAR Application
================

**Important: at the moment, the PHAR application compilation process is not fully achieved.**
**You have to download the application and compile it on your own.**

# Installation

You must first install Box:

```sh
curl -LSs https://box-project.github.io/box2/installer.php | php
```

If everything is fine, the `box` command should be available:

```sh
box --version
```

Then you can download and build the archive. This step takes  between one and two minutes.

```sh
git clone https://github.com/web-token/jwt-app.git
cd jwt-app
composer install --no-dev --optimize-autoloader --classmap-authoritative

box build
```

When the compilation is finished, you will get a `jose.phar` file at the project root folder.  
You can move this file wherever you want (e.g. `/usr/local/bin`).

To use it, just execute the following line:

```sh
jose.phar
```
