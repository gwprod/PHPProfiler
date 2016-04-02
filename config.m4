PHP_ARG_ENABLE(profiler, [whether to enable Profiler support],
[ --enable-profiler   Enable Profiler support])

if test "$PHP_PROFILER" = "yes"; then
  AC_DEFINE(HAVE_PROFILER, 1, [Whether you have Profiler])
  PHP_NEW_EXTENSION(profiler, php_profiler.c, $ext_shared)
fi