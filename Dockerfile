FROM scratch
MAINTAINER devel@olbat.net

ADD build/rootfs.tar.gz /

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen

ENV LANG en_US.utf8
ENV LANGUAGE en_US.utf8
ENV LC_ALL en_US.utf8
