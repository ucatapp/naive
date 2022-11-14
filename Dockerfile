FROM golang:latest AS builder
WORKDIR /app

# RUN apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community --no-cache git go

RUN go env -w GO111MODULE=auto
# RUN go get -u github.com/caddyserver/xcaddy/cmd/xcaddy
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest
RUN xcaddy build master --with github.com/caddyserver/forwardproxy@caddy2=github.com/klzgrad/forwardproxy@naive \
        --with github.com/imgk/caddy-trojan \
 #        --with github.com/mholt/caddy-webdav

###

FROM alpine

COPY --from=builder /app/caddy /usr/bin/caddy
CMD /usr/bin/caddy run -config /etc/caddy/caddy.json
