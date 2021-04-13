FROM ubuntu:focal AS build

ENV DEBIAN_FRONTEND="noninteractive"

# Build dependencies we can get from apt.
RUN apt-get update && apt-get install -y \
	git libtool autoconf automake g++ gcc make \
	curl clang gnupg gdc openjdk-14-jdk \
	ruby mono-mcs golang ocaml rustc julia

RUN curl https://www.colm.net/files/thurston.asc | gpg --import -

WORKDIR /build
ENV COLM_VERSION=0.14.7
RUN curl -O https://www.colm.net/files/colm/colm-${COLM_VERSION}.tar.gz
RUN curl -O https://www.colm.net/files/colm/colm-${COLM_VERSION}.tar.gz.asc
RUN gpg --verify colm-${COLM_VERSION}.tar.gz.asc colm-${COLM_VERSION}.tar.gz
RUN tar -zxvf colm-${COLM_VERSION}.tar.gz
WORKDIR /build/colm-${COLM_VERSION}
RUN ./configure --prefix=/opt/colm.net/colm --disable-manual
RUN make
RUN make install

WORKDIR /build
ENV RAGEL_VERSION=7.0.4
RUN curl -O https://www.colm.net/files/ragel/ragel-${RAGEL_VERSION}.tar.gz 
RUN curl -O https://www.colm.net/files/ragel/ragel-${RAGEL_VERSION}.tar.gz.asc
RUN gpg --verify ragel-${RAGEL_VERSION}.tar.gz.asc ragel-${RAGEL_VERSION}.tar.gz
RUN tar -zxvf ragel-${RAGEL_VERSION}.tar.gz
WORKDIR /build/ragel-${RAGEL_VERSION}
RUN ./configure --prefix=/opt/colm.net/ragel --with-colm=/opt/colm.net/colm --disable-manual
RUN make
RUN make install
WORKDIR /build/ragel-${RAGEL_VERSION}/test
RUN ./runtests
