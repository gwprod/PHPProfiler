//
// Created by Derek Whittom on 4/2/16.
//

#include "php.h"
#include "php_ini.h"
#include "ext/standard/info.h"
#include "zend.h"
#include "zend_extensions.h"

void statement_handler(zend_op_array *op_array) {
    //TSRMLS_FETCH();
    //fprintf(stderr, "%s:%d\n", zend_get_executed_filename(TSRMLS_C), zend_get_executed_lineno(TSRMLS_C));
}

void function_start_handler(zend_op_array *op_array) {
    TSRMLS_FETCH();
    fprintf(stderr, "Starting %s - %s:%d\n", get_active_function_name(TSRMLS_C), zend_get_executed_filename(TSRMLS_C), zend_get_executed_lineno(TSRMLS_C));
}

void function_end_handler(zend_op_array *op_array) {
    TSRMLS_FETCH();
    fprintf(stderr, "Leaving %s - %s:%d\n", get_active_function_name(TSRMLS_C), zend_get_executed_filename(TSRMLS_C), zend_get_executed_lineno(TSRMLS_C));
}
int call_coverage_zend_startup(zend_extension *extension) {
    TSRMLS_FETCH();
    CG(compiler_options) |= ZEND_COMPILE_EXTENDED_INFO;
    return SUCCESS;
}

#ifndef ZEND_EXT_API
#define ZEND_EXT_API ZEND_DLEXPORT
#endif
ZEND_EXTENSION();

ZEND_DLEXPORT zend_extension zend_extension_entry = {
        "Simple Profiler",
        "0.1",
        "Derek Whittom",
        "",
        "",
        call_coverage_zend_startup,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        statement_handler,
        function_start_handler,
        function_end_handler,
        NULL,
        NULL,
        STANDARD_ZEND_EXTENSION_PROPERTIES
};