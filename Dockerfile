# Parent container
FROM alpine:3.7

# Set paths and GitHub Pages gem version to use
ENV SRCPATH="/home/jekyll/src" \
    SRVPATH="/srv" \
    GITHUB_PAGES_VERSION="185"

# Install build dependencies
RUN apk --no-cache add --virtual build-dependencies \
        build-base \
        libxml2-dev \
        ruby-dev \
# Install runtime requirements
    && apk --no-cache add \
        ruby \
        ruby-json \
# Install GitHub Pages gem
    && gem install github-pages --version ${GITHUB_PAGES_VERSION} --no-document \
# Create a group and user to tun
    && addgroup -S jekyll \
    && adduser -S -G jekyll jekyll \
# Create directories
    && mkdir -p ${SRCPATH} ${SRVPATH} \
# Set directory owners
    && chown jekyll:jekyll ${SRCPATH} ${SRVPATH} \
# Remove build dependencies
    && apk --no-cache del \
        build-dependencies

# Set runtime user and group
USER jekyll:jekyll

# Copy the default page to the source directory
ADD index.html ${SRCPATH}

# Set the working directory
WORKDIR ${SRCPATH}

# Expose directories as available volumes
VOLUME ${SRCPATH} ${SRVPATH}

# Expose web server
EXPOSE 4000

# Add the entrypoint shell script
ADD entrypoint.sh /entrypoint.sh

# Set the entry point and command
ENTRYPOINT ["/entrypoint.sh"]
CMD ["jekyll"]
