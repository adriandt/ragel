#
# This dockerfile demonstrates a minimal build of ragel off the master branch.
# No manual or testing dependencies are installed.
#
FROM ubuntu:focal AS build

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && apt-get install -y \
	git libtool autoconf automake gcc g++ make

WORKDIR /devel
RUN git clone https://github.com/adrian-thurston/colm.git
WORKDIR /devel/colm
RUN ./autogen.sh
RUN ./configure --prefix=/pkgs/colm
RUN make install

WORKDIR /devel
RUN git clone https://github.com/adrian-thurston/ragel.git
WORKDIR /devel/ragel
RUN ./autogen.sh
RUN ./configure --prefix=/pkgs/ragel --with-colm=/pkgs/colm
RUN make install
