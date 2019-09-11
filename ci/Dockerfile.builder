FROM ubuntu:18.04
MAINTAINER Oisín Mac Fhearaí

RUN mkdir /urweb
WORKDIR /urweb

ENV COMPILER=/urweb/urweb-build

# get dependencies
RUN apt-get update -yqq && apt-get install -yqq build-essential wget mlton libssl-dev libpq-dev libmysqlclient-dev libicu-dev git autoconf libtool

# get Ur/Web release tarball
RUN mkdir -p $COMPILER && \
    git clone https://github.com/urweb/urweb.git urweb

# build Ur/Web from recent commit and install in prefix
RUN cd urweb && \
    git checkout b506e44ebbf80d98bb1a39d5566e7cdf53b3fc78 && \
    ./autogen.sh && \
    ./configure --prefix=$COMPILER && \
    make && \
    make install

ENV URWEB_HOME=${COMPILER}
ENV LD_LIBRARY_PATH=${COMPILER}/lib
ENV PATH=${COMPILER}/bin:${PATH}
