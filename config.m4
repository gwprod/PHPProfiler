PHP_ARG_ENABLE(profiler, [whether to enable Profiler support],
[ --enable-profiler   Enable Profiler support])

if test "$PHP_PROFILER" = "yes"; then
  AC_DEFINE(HAVE_PROFILER, 1, [Whether you have Profiler])
  FIND_LIBRARY(ZMQ_LIB libzmq)
  TARGET_LINK_LIBRARIES(myExecOrLib ${ZMQ_LIB})
  PHP_NEW_EXTENSION(php_profiler, php_profiler.c, $ext_shared)
  PHP_ADD_MAKEFILE_FRAGMENT
fi