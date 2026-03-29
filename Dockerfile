FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    build-essential \
    crossbuild-essential-arm64 \
    cmake \
    ninja-build \
    gdb-multiarch \
    pkg-config \
    file \
    rsync \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*