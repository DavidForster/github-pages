# Docker container for local GitHub Pages development

## Synopsis

An Alpine based lightweight container for local GitHub Pages development

### Tags

Tags are congruent with the versions of the [GitHub Pages gem](https://rubygems.org/gems/github-pages). "latest" should reflect the latest build with the latest gem version.

## Building

Build locally (single platform, for testing):

    make build

Build and push multi-platform (`linux/amd64` and `linux/arm64`) to Docker Hub:

    make push          # pushes :<version> and :latest
    make push-latest   # pushes :latest only

`make push` requires a buildx builder if you haven't created one: `docker buildx create --use`

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

## Gemfile.lock

This container is the locked environment — projects do not need a `Gemfile.lock`. If your site has one that pins different gem versions, Jekyll will fail at startup. Either delete it (and add it to `.gitignore`), or regenerate it against the container:

    docker run --rm -v /path/to/your/site:/home/jekyll/src --entrypoint bundle davidforster/github-pages update

## License

This project is licensed under the [MIT License](LICENSE)
