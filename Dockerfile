FROM alpine:latest

ENV LISTEN_ADDRESS ":8080"

ENV TRACK_REPO_TAG ""

ENV GOPATH /go

ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chown 777 "$GOPATH"

COPY . "$GOPATH/src/github.com/WuHan0608/webhook-pushover/"

RUN sed -i -e s'/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/' /etc/apk/repositories && \
    apk add -U musl-dev go ca-certificates tzdata && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    cd "$GOPATH/src/github.com/WuHan0608/webhook-pushover/" && \
    go install -ldflags="-s -w" && \
    apk del -r go && \
    rm -rf /var/cache/apk/*

WORKDIR $GOPATH

CMD ["webhook-pushover"]
