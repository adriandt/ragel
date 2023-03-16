#
# This dockerfile demontrates a build of ragel with full testing. All testing
# dependencies are installed and the test suite is run.
#

FROM ubuntu:focal AS build

ENV DEBIAN_FRONTEND="noninteractive"

# Build dependencies we can get from apt.
RUN apt-get update && apt-get install -y \
	git libtool autoconf automake g++ gcc make \
	wget clang gnupg gdc default-jdk \
	ruby mono-mcs golang ocaml rustc julia \
	gnustep-make python2 python-is-python2 \
	libpcre3-dev libgnustep-base-dev

WORKDIR /devel/llvm/
RUN wget https://releases.llvm.org/3.3/llvm-3.3.src.tar.gz
RUN tar -zxf llvm-3.3.src.tar.gz
WORKDIR /devel/llvm/llvm-3.3.src
RUN ./configure --prefix=/pkgs/llvm-3.3
RUN make REQUIRES_RTTI=1; exit 0
RUN make install; exit 0

WORKDIR /devel/crack
RUN wget http://crack-lang.org/downloads/crack-1.6.tar.gz
RUN tar -zxf crack-1.6.tar.gz
WORKDIR /devel/crack/crack-1.6
ENV PATH=/pkgs/llvm-3.3/bin:$PATH
RUN ./configure --prefix=/pkgs/crack-1.3
RUN make install
ENV PATH=/pkgs/crack-1.3/bin:$PATH

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
RUN make

WORKDIR /devel/ragel/test
RUN ./runtests

