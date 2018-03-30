FROM alpine:3.7

ENV SRCPATH="/home/jekyll/src" \
    SRVPATH="/srv" \
    GITHUB_PAGES_VERSION="179"

RUN apk --no-cache add \
        build-base \
        libxml2-dev \
        ruby \
        ruby-dev \
        ruby-json && \
    gem install github-pages --version ${GITHUB_PAGES_VERSION} --no-document && \
    addgroup -S jekyll && \
    adduser -S -G jekyll jekyll &&\
    mkdir -p ${SRCPATH} ${SRVPATH} && \
    chown jekyll:jekyll ${SRCPATH} ${SRVPATH}

USER jekyll:jekyll

ADD index.html ${SRCPATH}
WORKDIR ${SRCPATH}
VOLUME ${SRCPATH} ${SRVPATH}

EXPOSE 4000

ENTRYPOINT jekyll serve --destination ${SRVPATH} --watch --incremental --strict_front_matter --drafts --future --host 0.0.0.0
