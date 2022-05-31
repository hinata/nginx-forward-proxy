#@# vim: set filetype=dockerfile:
FROM alpine:3.15
LABEL maintainer "Takahiro INOUE <github.com/hinata>"

ARG DEFAULT_USER=user
ARG DEFAULT_PASSWORD=password

ENV USER $DEFAULT_USER
ENV PASSWORD $DEFAULT_PASSWORD
ENV NGINX_VERSION 1.21.6

##
# dependent packages for docker build
##

WORKDIR /tmp

RUN apk update &&   \
    apk add         \
      alpine-sdk    \
      openssl-dev   \
      pcre-dev      \
      zlib-dev      \
      apache2-utils

RUN curl -LSs http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -O                                             && \
    tar xf nginx-${NGINX_VERSION}.tar.gz                                                                             && \
    cd     nginx-${NGINX_VERSION}                                                                                    && \
    git clone https://github.com/chobits/ngx_http_proxy_connect_module                                               && \
    patch -p1 < ./ngx_http_proxy_connect_module/patch/proxy_connect_rewrite_102101.patch                             && \
    ./configure                                                                                                         \
      --add-module=./ngx_http_proxy_connect_module                                                                      \
      --sbin-path=/usr/sbin/nginx                                                                                       \
      --with-cc-opt='-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' && \
    make -j $(nproc)                                                                                                 && \
    make install                                                                                                     && \
    rm -rf /tmp/*

RUN htpasswd -bc /usr/local/nginx/.htpasswd $USER $PASSWORD

##
# application deployment
##

WORKDIR /

COPY ./nginx.conf /usr/local/nginx/conf/nginx.conf

EXPOSE 3128

STOPSIGNAL SIGTERM

CMD [ "nginx", "-g", "daemon off;" ]
