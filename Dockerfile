FROM alpine:latest

ARG VERSION=1.2.0
ENV SPEEDTEST_VERSION=${VERSION}

# Install required packages
RUN apk add --no-cache curl tar bash

# Download and install speedtest-cli
RUN ARCH=$(apk info --print-arch) && \
    case "$ARCH" in \
      x86_64) _arch=x86_64 ;; \
      aarch64) _arch=aarch64 ;; \
      armv7) _arch=armhf ;; \
      *) _arch="$ARCH" ;; \
    esac && \
    curl -fsSL -o /tmp/ookla-speedtest.tgz \
      "https://install.speedtest.net/app/cli/ookla-speedtest-${VERSION}-linux-${_arch}.tgz" && \
    tar xvfz /tmp/ookla-speedtest.tgz -C /usr/local/bin speedtest && \
    rm -rf /tmp/ookla-speedtest.tgz

# Create non-root user
RUN adduser -D speedtest

# Switch to non-root user
USER speedtest

# Set default shell
SHELL ["/bin/bash", "-c"]

# Default to interactive shell, but allow running speedtest directly
ENTRYPOINT ["/bin/bash"]
CMD ["-i"]