#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SYSROOT="/Volumes/RPI_SYSROOT/sysroot"
IMAGE="rpi5-cross:bookworm"

docker run --rm -it \
  -v "${PROJECT_ROOT}":/work \
  -v "${SYSROOT}":/sysroot:ro \
  -w /work \
  "${IMAGE}" \
  bash -lc "
    cmake -S . -B build-rpi5 -G Ninja \
      -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/rpi5-aarch64.cmake &&
    cmake --build build-rpi5
  "