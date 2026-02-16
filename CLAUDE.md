# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository is a Docker image (`davidforster/github-pages`) for local GitHub Pages development. It packages the `github-pages` Ruby gem into an Alpine-based container that runs Jekyll in serve mode.

## Architecture

- **Dockerfile**: Builds from `alpine:3.13`, installs the `github-pages` gem at the version pinned in `GITHUB_PAGES_VERSION`, creates a `jekyll` user, and sets up two directories: `/home/jekyll/src` (source) and `/srv` (generated output).
- **entrypoint.sh**: When invoked with `jekyll` (the default CMD), runs `jekyll serve` with `--watch`, `--incremental`, `--drafts`, `--future`, and `--strict_front_matter`. Any other argument is passed directly to `jekyll`.
- **index.html**: A minimal Jekyll page used as the default content when no volume is mounted.

## Key Environment Variables

| Variable | Default | Purpose |
|---|---|---|
| `GITHUB_PAGES_VERSION` | `232` | Version of the `github-pages` gem to install |
| `SRCPATH` | `/home/jekyll/src` | Jekyll source directory (mount user content here) |
| `SRVPATH` | `/srv` | Jekyll output directory |

## Building and Running

Build the image:
```sh
docker build -t davidforster/github-pages .
```

Run with default test page:
```sh
docker run -p 4000:4000 davidforster/github-pages
```

Run with a local Jekyll site:
```sh
docker run -p 4000:4000 -v /path/to/site:/home/jekyll/src davidforster/github-pages
```

To upgrade the gem version, update `GITHUB_PAGES_VERSION` in the Dockerfile. Image tags on Docker Hub correspond to the `github-pages` gem version number.
