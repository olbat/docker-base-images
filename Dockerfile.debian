FROM scratch
MAINTAINER devel@olbat.net

ADD build/rootfs.tar.gz /

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
&& locale-gen

ENV LANG en_US.utf8 \
LANGUAGE en_US.utf8 \
LC_ALL en_US.utf8
