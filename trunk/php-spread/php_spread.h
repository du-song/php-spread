/* ==================================================================
 * Spread Client Extension for PHP
 * Copyright (c) 2001 George Schlossnagle
 * All rights reserved.
 * ==================================================================
 * This source code is made available free and without charge subject
 * to the terms of the PHP Group License as detailed in bundled LICENSE file.
 * ==================================================================
 * George Schlossnagle <george@omniti.com>
 * ==================================================================
*/

#ifndef PHP_SPREAD_H
#define PHP_SPREAD_H

#include "php.h"
#include "php_ini.h"

#include "zend.h"
#include "zend_API.h"
#include "zend_execute.h"
#include "zend_compile.h"
#include "zend_extensions.h"

#ifdef ZTS
#include "TSRM.h"
#endif

#include <sp.h>

#ifdef PHP_WIN32
#define PHP_SPREAD_API __declspec(dllexport)
#else
#define PHP_SPREAD_API
#endif

/* declarations of functions to be exported */
PHP_FUNCTION(spread);
PHP_FUNCTION(spread_connect);
PHP_FUNCTION(multicast);
PHP_FUNCTION(spread_multicast);
PHP_FUNCTION(spread_disconnect);
PHP_FUNCTION(spread_error);
PHP_FUNCTION(spread_join);
PHP_FUNCTION(spread_receive);

extern zend_module_entry spread_module_entry;
#define phpext_spread_ptr &spread_module_entry

PHP_MINIT_FUNCTION(spread);
PHP_RINIT_FUNCTION(spread);
PHP_MSHUTDOWN_FUNCTION(spread);
PHP_RSHUTDOWN_FUNCTION(spread);
PHP_MINFO_FUNCTION(spread);

#ifdef ZEND_ENGINE_2
zend_class_entry *spread_class_entry;
#endif

/* Extends zend object */
typedef struct _ze_spread_object {
	zend_object zo;
	mailbox *mbox;
	HashTable *prop_handler;
} ze_spread_object;

#define spread_module_ptr &spread_module_entry

ZEND_BEGIN_MODULE_GLOBALS(spread)
	int default_conn;
ZEND_END_MODULE_GLOBALS(spread)

#define SpG(v) (spread_globals.v)
#endif
