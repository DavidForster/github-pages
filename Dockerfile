FROM alpine:3.7

ENV SRCPATH="/home/jekyll/src" \
    SRVPATH="/srv" \
    GITHUB_PAGES_VERSION="180"

RUN apk --no-cache add --virtual build-dependencies \
        build-base \
        libxml2-dev \
        ruby-dev \
    && apk --no-cache add \
        ruby \
        ruby-json \
    && gem install github-pages --version ${GITHUB_PAGES_VERSION} --no-document \
    && addgroup -S jekyll \
    && adduser -S -G jekyll jekyll \
    && mkdir -p ${SRCPATH} ${SRVPATH} \
    && chown jekyll:jekyll ${SRCPATH} ${SRVPATH} \
    && apk --no-cache del \
        build-dependencies

USER jekyll:jekyll

ADD index.html ${SRCPATH}
WORKDIR ${SRCPATH}
VOLUME ${SRCPATH} ${SRVPATH}

EXPOSE 4000

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["jekyll"]
