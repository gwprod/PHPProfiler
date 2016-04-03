#!/bin/bash
export CFLAGS="-Wall -Wextra -Wdeclaration-after-statement -Wmissing-field-initializers -Wshadow -Wno-unused-parameter -ggdb3"
phpize
./configure  --with-zmq
make all install
EXTENSIONDIR=`php -r 'echo ini_get("extension_dir");'`
echo "zend_extension=${EXTENSIONDIR}/php_profiler.so" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini
echo "zend_extension=${EXTENSIONDIR}/php_profiler.so" > /tmp/temp-php-config.ini
cat /tmp/temp-php-config.ini