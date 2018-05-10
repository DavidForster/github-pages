# Docker container for local GitHub Pages development

[![](https://images.microbadger.com/badges/image/davidforster/github-pages.svg)](https://microbadger.com/images/davidforster/github-pages "Get your own image badge on microbadger.com")

## Synopsis

An Alpine based lightweight container for local GitHub Pages development

### Tags

Tags are congruent with the versions of the [GitHub Pages gem](https://rubygems.org/gems/github-pages). "latest" should reflect the latest build with the latest gem version.

## Usage

### Docker

Pull the latest version using:

    docker pull davidforster/github-pages

_Or_ pull a specific version using (replacing _nn_ with the desired version):

    docker pull davidforster/github-pages:nn

Run the container using:

    docker run -p 4000:4000 davidforster/github-pages

If you don't mount your source files as a volume then a default index.html page is configured which will allow you to test that the container is working (see [index.html](index.html)).

### Docker Compose

Based on the above, the following should work when added to your docker-compose.yml configuration file:

    image: davidforster/github-pages
    ports:
        - 4000:4000
    volumes:
        - .:/home/jekyll/src

### Volumes

Volumes are defined for the source and served directories. Mount your source files at:

    /home/jekyll/src

and collect your generated files from

    /srv

### Ports

Port 4000 (Jekyll's default WeBrick server port when running in "serve" mode) is exposed

### User

The Jekyll process runs under the user "jekyll", created as part of the Docker build.

## License

This project is licensed under the [MIT License](LICENSE)
