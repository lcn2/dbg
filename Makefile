#!/usr/bin/make
#
# dbg - example of how to use usage(), dbg(), warn(), err()
#
# Copyright (c) 1989,1997,2018-2022 by Landon Curt Noll.  All Rights Reserved.
#
# Permission to use, copy, modify, and distribute this software and
# its documentation for any purpose and without fee is hereby granted,
# provided that the above copyright, this permission notice and text
# this comment, and the disclaimer below appear in all of the following:
#
#       supporting documentation
#       source copies
#       source works derived from this source
#       binaries derived from this source or from derived source
#
# LANDON CURT NOLL DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
# INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO
# EVENT SHALL LANDON CURT NOLL BE LIABLE FOR ANY SPECIAL, INDIRECT OR
# CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
# USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
#
# chongo (Landon Curt Noll, http://www.isthe.com/chongo/index.html) /\oo/\
#
# Share and enjoy! :-)


SHELL= /bin/bash

CC= cc
CFLAGS= -O3 -g3 -pedantic -Wall -Werror -DDBG_TEST
#CFLAGS= -O3 -g3 -pedantic -Wall -Werror -DDBG_TEST -DDBG_LINT
RM= rm
GREP= grep
CAT= cat

DESTDIR= /usr/local/bin

TARGETS= dbg.o dbg

all: ${TARGETS}

dbg.o: dbg.c dbg.h Makefile
	${CC} ${CFLAGS} dbg.c -c

dbg: dbg.c dbg.h Makefile
	${CC} ${CFLAGS} dbg.c -o $@

configure:
	@echo nothing to $@

clean:
	${RM} -f dbg.o
	${RM} -rf dbg.dSYM
	${RM} -f dbg.out

clobber: clean
	${RM} -f ${TARGETS}

install: all
	@echo nothing to $@

test: dbg Makefile
	${RM} -f dbg.out
	@echo "RUNNING: dbg"
	@echo "./dbg -e 2 foo bar baz >dbg.out 2>&1"
	@-./dbg -v 1 -e 2 foo bar baz > dbg.out 2>&1; \
	  status="$$?"; \
	  if [[ $$status -ne 5 ]]; then \
	    echo "exit status of dbg: $$status != 5"; \
	    exit 21; \
	  else \
	      ${GREP} -q '^FATAL\[5\]: main: simulated error, foo: foo bar: bar errno\[2\]: No such file or directory$$' dbg.out; \
	      status="$$?"; \
	      if [[ $$status -ne 0 ]]; then \
		echo "ERROR: did not find the correct dbg error message" 1>&2; \
		echo "ERROR: beginning dbg.out contents" 1>&2; \
		${CAT} dbg.out 1>&2; \
		echo "ERROR: dbg.out contents complete" 1>&2; \
		exit 22; \
	      else \
		echo "PASSED: dbg"; \
	      fi; \
	  fi
