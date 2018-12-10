ARG baseimg=raspbian/stretch
FROM $baseimg as build
ENV DEBIAN_FRONTEND=noninteractive
ENV SRC_DIR=/src
RUN mkdir -p $SRC_DIR
RUN apt-get update
RUN apt-get install -y \
    wget git libtool autoconf cmake \
    build-essential pkg-config
WORKDIR $SRC_DIR

RUN wget -q http://zlib.net/zlib-1.2.11.tar.gz
RUN tar -zxf zlib-1.2.11.tar.gz

RUN wget -q https://www.openssl.org/source/openssl-1.1.1.tar.gz
RUN tar xf openssl-1.1.1.tar.gz

RUN wget -q https://nginx.org/download/nginx-1.15.6.tar.gz
RUN tar xf nginx-1.15.6.tar.gz

RUN wget -q https://github.com/arut/nginx-rtmp-module/archive/v1.2.1.tar.gz
RUN tar xf v1.2.1.tar.gz

RUN wget -q ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.42.tar.gz
RUN tar -zxf pcre-8.42.tar.gz

WORKDIR /src/nginx-1.15.6
RUN mkdir -p /build /conf
RUN ./configure --prefix=/build \
    --with-zlib=/src/zlib-1.2.11 \
    --with-openssl=/src/openssl-1.1.1 \
    --with-pcre=/src/pcre-8.42 \
    --sbin-path=/usr/local/bin/nginx \
    --conf-path=/conf/nginx.conf \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/lock/nginx.lock \
    --error-log-path=/var/log/nginx-error.log \
    --http-log-path=/var/log/nginx-access.log \
    --without-mail_pop3_module \
    --without-mail_imap_module \
    --without-mail_smtp_module \
    --without-http_fastcgi_module \
    --without-http_uwsgi_module \
    --without-http_scgi_module \
    --without-http_memcached_module \
    --with-http_ssl_module \
    --with-http_gzip_static_module \
    --with-threads \
    --add-module=../nginx-rtmp-module-1.2.1
RUN make -j4
RUN make install


FROM $baseimg
COPY --from=build /usr/local/bin/nginx /usr/local/bin/
COPY --from=build /build /build
COPY nginx.conf /conf/
RUN mkdir -p /web/www /web/hls
COPY index.html /web/www/
ENTRYPOINT nginx
