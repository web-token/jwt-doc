# Standalone Application

## Installation

To install the standalone application, you have to clone the repository and install the dependencies.\
We consider that `git` and `composer` are correctly installed.

```bash
git clone https://github.com/web-token/jwt-app.git
cd jwt-app
composer install --no-dev --optimize-autoloader --classmap-authoritative
```

You will find the standalone console command in the `bin` folder.

```bash
./bin/jose
```
