#!/bin/bash

set -e
set -x

INCLUDE=locales,${INCLUDE:-netcat}

[ $# -lt 2 ] && (
	echo "usage: $0 <repository> <release> [<tag1,tag2,...>]" 1>&2 ;
	exit 1
)

[ -d "docker/contrib" ] || (
	echo "cannot read the docker/contrib directory, please make sure you "\
		"initialized the docker/ git submodule properly" 1>&2
	exit 1
)

mkdir -p ${BUILD_DIR:=build}

docker/contrib/mkimage.sh -d $BUILD_DIR --compression=gz \
	debootstrap --variant=${VARIANT:-minbase} --include=$INCLUDE $2

docker build -t $1:$2 .
docker push $1:$2

rm -rf $BUILD_DIR

if [ $# -gt 2 ]
then
	for tag in ${3//,/ }
	do
		docker tag $1:$2 $1:$tag
		docker push $1:$tag
	done
fi
