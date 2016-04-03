#!/bin/bash

install_czmq() {
    local version=$1
    local build_dir="${BUILD_DIR}/czmq-build"

    if test -d "${build_dir}"
    then
        rm -rf "${build_dir}"
    fi

    git clone https://github.com/zeromq/czmq "${build_dir}"

    pushd "${build_dir}"

        ./autogen.sh


        ./configure --prefix="/usr/lib/czmq" --without-libsodium

        make -j 8
        make install
    popd
}

BUILD_DIR="/tmp"
export CFLAGS="-Wall -Wextra -Wmissing-field-initializers -Wno-unused-parameter -ggdb3"
phpize
install_czmq
./configure --with-zmq --with-czmq=/usr/lib/czmq
make all install
EXTENSIONDIR=`php -r 'echo ini_get("extension_dir");'`
echo "zend_extension=${EXTENSIONDIR}/php_profiler.so" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini
echo "zend_extension=${EXTENSIONDIR}/php_profiler.so" > /tmp/temp-php-config.ini
cat /tmp/temp-php-config.ini

