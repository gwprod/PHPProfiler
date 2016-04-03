//
// Created by Derek Whittom on 4/2/16.
//

#include "php.h"
#include "php_ini.h"
#include "ext/standard/info.h"
#include "zend.h"
#include "zend_extensions.h"
#include "czmq/include/czmq.h"

void activate_function(zend_extension *extension) {
    zctx_t *ctx = zctx_new ();
    printf ("I: connecting to server...\n");
    void *client = zsocket_new (ctx, ZMQ_REQ);
    assert (client);
    zsocket_connect (client, SERVER_ENDPOINT);

    int sequence = 0;
    int retries_left = REQUEST_RETRIES;
    while (retries_left && !zctx_interrupted) {
        //  We send a request, then we work to get a reply
        char request [10];
        sprintf (request, "%d", ++sequence);
        zstr_send (client, request);

        int expect_reply = 1;
        while (expect_reply) {
            //  Poll socket for a reply, with timeout
            zmq_pollitem_t items [] = { { client, 0, ZMQ_POLLIN, 0 } };
            int rc = zmq_poll (items, 1, REQUEST_TIMEOUT * ZMQ_POLL_MSEC);
            if (rc == -1)
                break;          //  Interrupted

            //  .split process server reply
            //  Here we process a server reply and exit our loop if the
            //  reply is valid. If we didn't a reply we close the client
            //  socket and resend the request. We try a number of times
            //  before finally abandoning:

            if (items [0].revents & ZMQ_POLLIN) {
                //  We got a reply from the server, must match sequence
                char *reply = zstr_recv (client);
                if (!reply)
                    break;      //  Interrupted
                if (atoi (reply) == sequence) {
                    printf ("I: server replied OK (%s)\n", reply);
                    retries_left = REQUEST_RETRIES;
                    expect_reply = 0;
                }
                else
                    printf ("E: malformed reply from server: %s\n",
                            reply);

                free (reply);
            }
            else
            if (--retries_left == 0) {
                printf ("E: server seems to be offline, abandoning\n");
                break;
            }
            else {
                printf ("W: no response from server, retrying...\n");
                //  Old socket is confused; close it and open a new one
                zsocket_destroy (ctx, client);
                printf ("I: reconnecting to server...\n");
                client = zsocket_new (ctx, ZMQ_REQ);
                zsocket_connect (client, SERVER_ENDPOINT);
                //  Send request again, on new socket
                zstr_send (client, request);
            }
        }
    }
    zctx_destroy (&ctx);
    return 0;
}
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
        activate_function,
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