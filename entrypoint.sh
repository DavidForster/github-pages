#!/bin/sh
set -e

if [ "$1" = 'jekyll' ]; then
    exec /usr/bin/jekyll serve --source ${SRCPATH} --destination ${SRVPATH} --watch --incremental --strict_front_matter --drafts --future --host 0.0.0.0
fi

exec /usr/bin/jekyll $@
