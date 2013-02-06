#! /bin/bash
#
# Build source RPM w/ using cabalrpm (cblrpm).
#
set -e

hkgname=$1
builddir=$2
if test "x$hkgname" = "x"; then
    echo "Usage: $0 HACKAGE_NAME [BUILDDIR]"
    exit 1
fi

info=`cabal info $hkgname`; rc=$?
pversion=$(echo "$info" | sed -nr 's, *Versions available:.* ([^ ]+)$,\1,p')

test "x$builddir" = "x" && builddir="/tmp/$hkgname/$pversion" || :

rpmspec="ghc-$hkgname.spec"

test -f $rpmspec || cblrpm $hkgname

tgz=$HOME/.cabal/packages/hackage.haskell.org/$hkgname/$pversion/$hkgname-$pversion.tar.gz
test -f $tgz || cabal fetch $hkgname

rpmbuild_ () {
    rpmbuild --define "_topdir ${builddir}" \
        --define "_srcrpmdir ${builddir}" \
        --define "_sourcedir ${tgz%/*}" \
        --define "_buildroot ${builddir}" \
        -bs $@
}

rpmbuild_ $rpmspec 

# vim:sw=4:ts=4:et:
