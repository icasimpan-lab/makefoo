#!/usr//bin/env bash

#
# build/ci.sh
#
#   script that does various CI (Continous Integration) tasks for makefoo
###
# by default, it 
#  - boostraps environment (makefoo)
#  - configures
#  - builds
#  - makes fake installation
#  - tests
#  - makes distcheck
#
###

header()
{
    echo "===================="
    echo "| $@"
    echo "--------------------"
}

set -e

header "makefoo"
if [ ! -d makefoo-master ] ; then
    git clone https://github.com/zbigg/makefoo.git makefoo-master
else
    ( cd makefoo-master; git pull )
fi

header "aclocal"
aclocal -I makefoo-master

header "configure"
./configure

source makefoo_configured_defs.mk

#header "make"
#${MAKEFOO_MAKE}

header "make install"
${MAKEFOO_MAKE} install DESTDIR=`pwd`/.tmp-installation
rm -rf .tmp-installation

header "make check"
${MAKEFOO_MAKE} check

header "make distcheck"
${MAKEFOO_MAKE} distcheck

