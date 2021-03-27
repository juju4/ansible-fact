#!/bin/sh
## one script to be used by travis, jenkins, packer...

umask 022

if [ $# != 0 ]; then
rolesdir=$1
else
rolesdir=$(dirname $0)/..
fi

[ ! -d $rolesdir/geerlingguy.docker ] && git clone https://github.com/geerlingguy/ansible-role-docker.git $rolesdir/geerlingguy.docker

## don't stop build on this script return code
true
