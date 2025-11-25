FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    DOTNET_INSTALL_DIR=/usr/share/dotnet \
    DOTNET_VERSION=8.0.416

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    ca-certificates curl tar gzip xz-utils libicu-dev \
 && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh \
 && chmod +x /tmp/dotnet-install.sh \
 && /tmp/dotnet-install.sh --channel 8.0 --version $DOTNET_VERSION --install-dir $DOTNET_INSTALL_DIR --architecture x64 \
 && ln -s $DOTNET_INSTALL_DIR/dotnet /usr/local/bin/dotnet \
 && rm -f /tmp/dotnet-install.sh

HEALTHCHECK --interval=1m --timeout=10s --start-period=10s --retries=3 \
  CMD dotnet --list-sdks >/dev/null 2>&1 || exit 1

RUN dotnet --info
