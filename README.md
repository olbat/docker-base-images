# Docker base image builder [![Build Status](https://secure.travis-ci.org/olbat/docker-base-images.png?branch=master)](https://travis-ci.org/olbat/docker-base-images)


## Overview
Build base Docker  images using the official [mkimage.sh](https://github.com/docker/docker/blob/master/contrib/mkimage.sh) generation script from docker's upstream repository.

The generated images are modified to setup an UTF-8 locale when it's possible
(see Dockerfiles).


## Dependencies
The build script depends on the following softwares:
* bash
* docker
* busybox-static
* debootstrap
* rinse


## Usage
```
usage: build.sh <distrib> <release> [<repository> <tag1,tag2,...>]

```
__Note__: the build can be customized specifying the `INCLUDE` env. var.


## Example
Build and push the `user/debian` image based on the `stable` Debian release with the 'jessie' and '8.x' extra tags:

```bash
# as root
./build.sh debian user/debian stable jessie,8.x
```

__Note__: if the image has to be pushed pushed to a login-enabled registry, you should first login using `docker login`


## Images
- [Busybox](https://hub.docker.com/r/olbat/busybox)
- [Alpine](https://hub.docker.com/r/olbat/alpine)
- [Debian](https://hub.docker.com/r/olbat/debian)
- [Ubuntu](https://hub.docker.com/r/olbat/ubuntu)
- [CentOS](https://hub.docker.com/r/olbat/centos)
- [Fedora](https://hub.docker.com/r/olbat/fedora)
__Note__: this images are generated on a daily basis using [Travis CI](https://travis-ci.org/olbat/docker-base-images)
