#!/bin/bash

set -e
set -x

[ $# -lt 2 ] && (
	echo "usage: $0 <distrib> <release> [<repository> <tag1,tag2,...>]" 1>&2
	exit 1
)

[ -d "docker/contrib" ] || (
	echo "ERROR: cannot read the docker/contrib directory, please make"\
		"sure you initialized the docker/ git submodule properly" 1>&2
	exit 1
)

mkdir -p ${BUILD_DIR:=$PWD/build}
MKIMAGE_OPTS=${MKIMAGE_OPTS:--d $BUILD_DIR --compression=gz}

case $1 in
busybox)
	[ $INCLUDE ] && echo "WARNING: $1 does not support \$INCLUDE" 1>&2
	script=mkimage.sh
	args="$MKIMAGE_OPTS busybox-static"
	;;

alpine)
	[ $INCLUDE ] && echo "WARNING: $1 does not support \$INCLUDE" 1>&2
	script=mkimage-alpine.sh
	args="-s -r $2"
	# FIXME: ugly hack since it's not possible to specify a build directory
        #	 to the mkimage-alpine.sh script
	postinstall="mv rootfs.tar.xz $BUILD_DIR"
	;;

debian|ubuntu)
	[ $1 == ubuntu ] && components=main,universe || components=main

	script=mkimage.sh
	args="$MKIMAGE_OPTS debootstrap"
	args+=" --variant=minbase --include=locales,${INCLUDE:-netcat-openbsd}"
	args+=" --components=$components $2"
	;;

centos|fedora|rhel|slc|opensuze)
	pkgfile=$(mktemp)
	trap 'rm -f -- "$pkgfile"' INT TERM HUP EXIT ERR
	echo glibc-common >> $pkgfile
	echo ${INCLUDE:-nmap-ncat} | tr "," "\n" >> $pkgfile

	script=mkimage.sh
	args="$MKIMAGE_OPTS rinse"
	args+=" --distribution=$2 --add-pkg-list=$pkgfile"
	;;

*)
	echo "invalid distrib $1" 1>&2
	exit 1
	;;
esac

docker/contrib/$script $args
[ "$postinstall" ] && $postinstall

image=${3:-$1}
docker build -f Dockerfile.$1 -t $image .

rm -rf $BUILD_DIR

if [ $# -gt 3 ]
then
	for tag in ${4//,/ }
	do
		docker tag $image $image:$tag
		docker push $image:$tag
	done
else
	docker push $image
fi
