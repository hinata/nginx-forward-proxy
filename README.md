# nginx-forward-proxy

## What is this?

The 'nginx-foward-proxy' is a so simple HTTP proxy server using the nginx.
You can easily build a HTTP proxy server using this.

## Try this container

### Requirement packages

- Docker

### How to use

```
$ docker run --rm -d -p 3128:3128 hinata/nginx-forward-proxy:latest
$ curl -x http://127.0.0.1:3128 https://www.google.co.jp
```

## See also

- https://github.com/chobits/ngx_http_proxy_connect_module

## LICENSE

Apache 2.0
