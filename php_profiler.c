//
// Created by Derek Whittom on 4/2/16.
//

#include "php.h"
#include "php_ini.h"
#include "ext/standard/info.h"
#include "zend.h"
#include "zend_extension.h"

void statement_handler(zend_op_array *op_array) {

}

int call_coverage_zend_startup(zend_extension *extension) {
    TSRMLS_FETCH();
    CG(extended_info) = 1;
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
        NULL,
        NULL,
        NULL,
        NULL,
        STANDARD_ZEND_EXTENSION_PROPERTIES
};