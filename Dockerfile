FROM martinussuherman/alpine-tz-ep-code-server

ENV LABEL_MAINTAINER="Martinus Suherman" \
    LABEL_VENDOR="martinussuherman" \
    LABEL_IMAGE_NAME="martinussuherman/alpine-tz-ep-code-server-net-sdk-31" \
    LABEL_URL="https://hub.docker.com/r/martinussuherman/alpine-tz-ep-code-server-net-sdk-31/" \
    LABEL_VCS_URL="https://github.com/martinussuherman/alpine-tz-ep-code-server-net-sdk-31" \
    LABEL_DESCRIPTION="Alpine Linux based image of code-server bundled with .NET Core SDK and some utilities" \
    LABEL_LICENSE="GPL-3.0" \
    # container/su-exec UID 
    EUID=1001 \
    # container/su-exec GID 
    EGID=1001 \
    # additional directories to create + chown (space separated) 
    ECHOWNDIRS= \
    # additional files to create + chown (space separated) 
    ECHOWNFILES= \
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8

RUN apk --no-cache --update add \
    ca-certificates \
    \
    # .NET Core dependencies
    icu-libs \
    krb5-libs \
    libgcc \
    libintl \
    libssl1.1 \
    libstdc++ \ 
    lttng-ust \
    numactl \
    zlib

# Install .NET Core SDK
RUN dotnet_sdk_version=3.1.404 \
    && wget -O dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/$dotnet_sdk_version/dotnet-sdk-$dotnet_sdk_version-linux-musl-x64.tar.gz \
    && dotnet_sha512='c6e73e88c69fa2c81eb572a64206fa6e94cb376230a05f14028c35aab202975c857973f9b5fac849c60d22f37563d8d53689c2605571e3b922bda2489e12346d' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -C /usr/share/dotnet -oxzf dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \
    && rm dotnet.tar.gz \
    # Trigger first run experience by running arbitrary cmd
    && dotnet help

#
ARG LABEL_VERSION="latest"
ARG LABEL_BUILD_DATE
ARG LABEL_VCS_REF

# Build-time metadata as defined at http://label-schema.org
LABEL maintainer=$LABEL_MAINTAINER \
      org.label-schema.build-date=$LABEL_BUILD_DATE \
      org.label-schema.description=$LABEL_DESCRIPTION \
      org.label-schema.name=$LABEL_IMAGE_NAME \
      org.label-schema.schema-version="1.0" \
      org.label-schema.url=$LABEL_URL \
      org.label-schema.license=$LABEL_LICENSE \
      org.label-schema.vcs-ref=$LABEL_VCS_REF \
      org.label-schema.vcs-url=$LABEL_VCS_URL \
      org.label-schema.vendor=$LABEL_VENDOR \
      org.label-schema.version=$LABEL_VERSION
