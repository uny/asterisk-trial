FROM debian:bookworm-slim AS build
RUN apt-get update && apt-get install --yes --no-install-recommends \
    build-essential \
    bzip2 \
    ca-certificates \
    libedit-dev \
    libjansson-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    patch \
    pkg-config \
    uuid-dev \
    wget && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /usr/src
RUN wget https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-22-current.tar.gz && \
    tar zxvf asterisk-22-current.tar.gz && \
    rm asterisk-22-current.tar.gz && \
    mv asterisk-22.* asterisk
WORKDIR /usr/src/asterisk
RUN ./configure --disable-xmldoc --prefix=/opt/asterisk && \
    make -j$(nproc) && \
    make install

FROM debian:bookworm-slim AS runtime
RUN apt-get update && apt-get install -y --no-install-recommends \
    libedit2 \
    libjansson4 \
    libsqlite3-0 \
    libssl3 \
    libxml2 && \
    rm -rf /var/lib/apt/lists/*
COPY --from=build /opt/asterisk /opt/asterisk
EXPOSE 5060/tcp 5060/udp 8088/tcp 10000-20000/udp
CMD ["/opt/asterisk/sbin/asterisk", "-f"]
