#!/usr/bin/make
#
# dbg - info, debug, warning, error and usage message facilities
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


#############
# utilities #
#############

# suggestion: List utility filenames, not paths.
#	      Do not list shell builtin (echo, cd, ...) tools.
#	      Keep the list in alphabetical order.

AR= ar
CAT= cat
CC= cc
CP= cp
GREP= grep
RM= rm
SHELL= bash


##################
# How to compile #
##################

CFLAGS= -O3 -g3 -pedantic -Wall
#CFLAGS= -O3 -g3 -pedantic -Wall -Werror


###############
# source code #
###############

# ALL: source files that are permanent (not made, nor removed)

C_SRC= dbg.c dbg_example.c dbg_test.c
H_SRC= dbg.h

ALL_SRC= ${C_SRC} ${H_SRC}


######################
# intermediate files #
######################

# NOTE: ${LIB_OBJS} are objects to put into a library and removed by make clean

LIB_OBJS= dbg.o

# NOTE: ${OTHER_OBJS} are objects NOT put into a library and removed by make clean

OTHER_OBJS= dbg_test.o dbg_example.o

# NOTE: intermediate files to make and removed by make clean

BUILT_C_SRC= dbg_test.c
BUILT_H_SRC=

ALL_BUILT_SRC= ${BUILT_C_SRC} ${BUILT_H_SRC}

# all intermediate files and removed by make clean

ALL_OBJS= ${LIB_OBJS} ${OTHER_OBJS}


#######################
# install information #
#######################

# where to install

DESTDIR= /usr/local/bin


######################
# target information #
######################

# may be used outside of this directory

EXTERN_H= dbg.h
EXTERN_O= dbg.o
EXTERN_LIBA= dbg.a

# NOTE: ${EXTERN_CLOBBER} used outside of this directory and removed by make clobber

EXTERN_CLOBBER= ${EXTERN_O} ${EXTERN_LIBA}

ALL_EXTERN= ${EXTERN_H} ${EXTERN_O} ${EXTERN_LIBA}

# what to make by all but NOT to removed by clobber (because they are not files)

ALL_OTHER_TARGETS= ${ALL_EXTERN} extern_include extern_objs extern_liba extern_all

# what to make by all and removed by clobber

TARGETS= dbg_test dbg_example


###########################################
# all rule - default rule - must be first #
###########################################

all: ${TARGETS} ${ALL_OTHER_TARGETS}
	@:


######################################################
# List rules that do not create themselves as .PHONY #
######################################################

.PHONY: all configure clean clobber install test extern_include extern_objs extern_liba


################
# what to make #
################

dbg.o: dbg.c dbg.h Makefile
	${CC} ${CFLAGS} dbg.c -c

dbg_test.c: dbg.c Makefile
	${RM} -f $@
	${CP} -v -f dbg.c $@

dbg_test.o: dbg_test.c dbg.h Makefile
	${CC} ${CFLAGS} -DDBG_TEST dbg_test.c -c

dbg_test: dbg_test.o Makefile
	${CC} ${CFLAGS} dbg_test.o -o $@

dbg_example.o:  dbg_example.c dbg.h Makefile
	${CC} ${CFLAGS} dbg_example.c -c

dbg_example: dbg_example.o dbg.o Makefile
	${CC} ${CFLAGS} dbg_example.o dbg.o -o $@

dbg.a: ${LIB_OBJS}
	${RM} -f $@
	${AR} -r -c -v $@ $^


###########################################
# rules for use by higher level Makefiles #
###########################################

extern_include: ${EXTERN_H}
	@:

extern_objs: ${EXTERN_O}
	@:

extern_liba: ${EXTERN_LIBA}
	@:

extern_all: extern_include extern_objs extern_liba
	@:

#######################
# internal make rules #
#######################

test: dbg_test Makefile
	${RM} -f dbg_test.out
	@echo "RUNNING: dbg_test"
	@echo "./dbg_test -e 2 foo bar baz >dbg_test.out 2>&1"
	@-./dbg_test -v 1 -e 2 foo bar baz >dbg_test.out 2>&1; \
	  status="$$?"; \
	  if [[ $$status -ne 5 ]]; then \
	    echo "exit status of dbg_test: $$status != 5"; \
	    exit 21; \
	  else \
	      ${GREP} -q '^ERROR\[5\]: main: simulated error, foo: foo bar: bar: errno\[2\]: No such file or directory$$' dbg_test.out; \
	      status="$$?"; \
	      if [[ $$status -ne 0 ]]; then \
		echo "ERROR: did not find the correct dbg_test error message" 1>&2; \
		echo "ERROR: beginning dbg_test.out contents" 1>&2; \
		${CAT} dbg_test.out 1>&2; \
		echo "ERROR: dbg_test.out contents complete" 1>&2; \
		exit 22; \
	      else \
		echo "PASSED: dbg_test"; \
	      fi; \
	  fi


#######################
# common make actions #
#######################

configure:
	@echo nothing to $@

clean:
	${RM} -f ${ALL_OBJS}
	${RM} -f ${ALL_BUILT_SRC}
	${RM} -f dbg_test.out

clobber: clean
	${RM} -f ${TARGETS}
	${RM} -f ${EXTERN_CLOBBER}

install: all
	@echo nothing to $@
