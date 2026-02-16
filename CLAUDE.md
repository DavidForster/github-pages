# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository is a Docker image (`davidforster/github-pages`) for local GitHub Pages development. It packages the `github-pages` Ruby gem into an Alpine-based container that runs Jekyll in serve mode.

## Architecture

- **Dockerfile**: Builds from `alpine:3.23`, installs the `github-pages` gem at the version pinned in `GITHUB_PAGES_VERSION`, creates a `jekyll` user, and sets up two directories: `/home/jekyll/src` (source) and `/srv` (generated output).
- **entrypoint.sh**: When invoked with `jekyll` (the default CMD), runs `jekyll serve` with `--watch`, `--incremental`, `--drafts`, `--future`, and `--strict_front_matter`. Any other argument is passed directly to `jekyll`.
- **index.html**: A minimal Jekyll page used as the default content when no volume is mounted.

## Key Environment Variables

| Variable | Default | Purpose |
|---|---|---|
| `GITHUB_PAGES_VERSION` | `232` | Version of the `github-pages` gem to install |
| `SRCPATH` | `/home/jekyll/src` | Jekyll source directory (mount user content here) |
| `SRVPATH` | `/srv` | Jekyll output directory |

## Building and Running

Build locally (single platform):
```sh
make build
```

Build and push multi-platform (`linux/amd64,linux/arm64`) to Docker Hub:
```sh
make push          # pushes :<version> and :latest
make push-latest   # pushes :latest only
```

`make push` requires a `docker buildx` builder: `docker buildx create --use` (one-time setup).

Run with default test page:
```sh
docker run -p 4000:4000 davidforster/github-pages
```

Run with a local Jekyll site:
```sh
docker run -p 4000:4000 -v /path/to/site:/home/jekyll/src davidforster/github-pages
```

To upgrade the gem version, update `GITHUB_PAGES_VERSION` in the Dockerfile. The version tag applied to the Docker image is extracted automatically from that value. Image tags on Docker Hub correspond to the `github-pages` gem version number.

## Gemfile / Gemfile.lock in user sites

The container itself is the locked environment, so projects do not need a `Gemfile.lock`. If a mounted site has a `Gemfile.lock` that pins different gem versions, Jekyll will fail at startup. Either delete the lockfile and add it to `.gitignore`, or regenerate it against the container:

```sh
docker run --rm -v /path/to/site:/home/jekyll/src --entrypoint bundle davidforster/github-pages update
```

## Ruby 3.4 note

Alpine 3.23 ships Ruby 3.4, which removed `csv` and `base64` from stdlib. Jekyll 3.10.0 (bundled in `github-pages` 232) depends on both, so the Dockerfile explicitly installs them as standalone gems after the main gem install. If `github-pages` is updated to a version that declares these as explicit dependencies, the extra `gem install csv base64` line can be removed.
