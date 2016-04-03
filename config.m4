PHP_ARG_ENABLE(profiler, [whether to enable Profiler support],
[ --enable-profiler   Enable Profiler support])

PHP_ARG_WITH(zmq,     whether to enable 0MQ support,
[  --with-zmq[=DIR]   Enable 0MQ support. DIR is the prefix to libzmq installation directory.], yes)

if test "$PHP_PROFILER" = "yes"; then
  AC_DEFINE(HAVE_PROFILER, 1, [Whether you have Profiler])
  AC_PATH_PROG(PKG_CONFIG, pkg-config, no)

  AC_MSG_CHECKING(libzmq installation)
  if test "x$PHP_ZMQ" = "xyes"; then
    if test "x${PKG_CONFIG_PATH}" = "x"; then
      #
      # "By default, pkg-config looks in the directory prefix/lib/pkgconfig for these files"
      #
      # Add a bit more search paths for common installation locations. Can be overridden by setting
      # PKG_CONFIG_PATH env variable or passing --with-zmq=PATH
      #
      export PKG_CONFIG_PATH="/usr/local/${PHP_LIBDIR}/pkgconfig:/usr/${PHP_LIBDIR}/pkgconfig:/opt/${PHP_LIBDIR}/pkgconfig:/opt/local/${PHP_LIBDIR}/pkgconfig"
    fi
  else
    export PKG_CONFIG_PATH="${PHP_ZMQ}/${PHP_LIBDIR}/pkgconfig"
    export PHP_ZMQ_EXPLICIT_PKG_CONFIG_PATH="${PKG_CONFIG_PATH}"
  fi

  if $PKG_CONFIG --exists libzmq; then
    PHP_ZMQ_VERSION=`$PKG_CONFIG libzmq --modversion`
    PHP_ZMQ_PREFIX=`$PKG_CONFIG libzmq --variable=prefix`

    AC_MSG_RESULT([found version $PHP_ZMQ_VERSION, under $PHP_ZMQ_PREFIX])
    PHP_ZMQ_LIBS=`$PKG_CONFIG libzmq --libs`
    PHP_ZMQ_CFLAGS=`$PKG_CONFIG libzmq --cflags`

    PHP_EVAL_LIBLINE($PHP_ZMQ_LIBS, ZMQ_SHARED_LIBADD)
    PHP_EVAL_INCLINE($PHP_ZMQ_CFLAGS)
  else
    AC_MSG_ERROR(Unable to find libzmq installation)
  fi

  PHP_SUBST(ZMQ_SHARED_LIBADD)
  PHP_NEW_EXTENSION(php_profiler, php_profiler.c, $ext_shared)

  PHP_ADD_MAKEFILE_FRAGMENT
fi