dnl $Id: config.m4,v 1.4 2006/02/10 08:56:47 pajoye Exp $
dnl config.m4 for extension php_spread
dnl don't forget to call PHP_EXTENSION(php_spread)

dnl Comments in this file start with the string 'dnl'.
dnl Remove where necessary. This file will not work
dnl without editing.

dnl If your extension references something external, use with:

dnl PHP_ARG_WITH(php_spread, for php_spread support,
dnl Make sure that the comment is aligned:
dnl [  --with-php_spread             Include php_spread support])

dnl Otherwise use enable:

PHP_ARG_ENABLE(php_spread, whether to enable php_spread support,
 [  --with-spread[=DIR]      Enable php_spread support])


if test "$PHP_SPREAD" != "no"; then

	ifdef([AC_PROG_EGREP], [
		AC_PROG_EGREP
		], [
		AC_CHECK_PROG(EGREP, egrep, egrep)
		])

	ifdef([AC_PROG_SED], [
		AC_PROG_SED
		], [
		ifdef([LT_AC_PROG_SED], [
			LT_AC_PROG_SED
			], [
			AC_CHECK_PROG(SED, sed, sed)
			])
		])

	if test -r "$PHP_SPREAD/include/sp.h"; then
		PHP_LIBSPREAD_DIR="$PHP_SPREAD"
	else
		AC_MSG_CHECKING(for libspread in default path)
		for i in /usr /usr/local; do
			if test -r "$i/include/sp.h"; then
				PHP_LIBSPREAD_DIR=$i
				AC_MSG_RESULT(found in $i)
			fi
		done
	fi

	AC_CHECK_HEADER([$PHP_LIBSPREAD_DIR/include/sp.h], [], AC_MSG_ERROR('include/sp.h' header not found))
	AC_CHECK_HEADER([$PHP_LIBSPREAD_DIR/include/sp_events.h], [], AC_MSG_ERROR('include/sp_events.h' header not found))

	AC_CHECK_PROG(SPREAD_CMD, spread, spread)

	if test ! -f "$PHP_LIBSPREAD_DIR/include/sp_func.h"; then
		AC_MSG_ERROR('include/sp.h' header not found)
	fi

	SPREAD_VERSION=`$EGREP "define.*SPREAD_VERSION" $PHP_LIBSPREAD_DIR/include/sp.h | $SED -e 's/<< 24//g' | $SED -e 's/<< 16//g' | $SED -e 's/[[^0-9)]]//g'`
	if test `echo $SPREAD_VERSION | $SED -e 's/[[^0-9]]/ /g' | $AWK '{print $1*1000000 + $2*10000 + $3*100 + $4}'` -lt 3170300; then
		AC_MSG_ERROR([spread version greater or equal to 3.17.3 is required])
	else
		AC_MSG_RESULT([Spread 3.17.3 or superior...found])
	fi


	PHP_ADD_INCLUDE($PHP_LIBSPREAD_DIR/include)

    PHP_ADD_LIBRARY_WITH_PATH(spread, $PHP_LIBSPREAD_DIR/$PHP_LIBDIR, SPREAD_SHARED_LIBADD)
    AC_DEFINE(HAVE_SPREAD,1,[ ])

	PHP_SUBST(SPREAD_SHARED_LIBADD)

   	PHP_EXTENSION(spread, $ext_shared)
fi
