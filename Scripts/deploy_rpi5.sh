#!/usr/bin/env bash
set -euo pipefail

PI_USER="ergun.cucuk"
PI_HOST="ecpi"
REMOTE_DIR="/home/${PI_USER}/Projects"
BUILD_ROOT="build-rpi5/Examples"
LESSON_FILTER="${1:-}"

if [[ ! -d "${BUILD_ROOT}" ]]; then
    echo "Build output directory not found: ${BUILD_ROOT}"
    echo "Build first."
    exit 1
fi

normalize_lesson_dir() {
    local input="$1"

    if [[ -z "${input}" ]]; then
        return 0
    fi

    if [[ "${input}" =~ ^Lesson-[0-9][0-9]$ ]]; then
        printf '%s\n' "${input}"
        return 0
    fi

    if [[ "${input}" =~ ^[0-9]$ ]]; then
        printf 'Lesson-0%s\n' "${input}"
        return 0
    fi

    if [[ "${input}" =~ ^[0-9][0-9]$ ]]; then
        printf 'Lesson-%s\n' "${input}"
        return 0
    fi

    echo "Invalid lesson filter: ${input}" >&2
    echo "Use Lesson-0x, 0x or x." >&2
    exit 1
}

LESSON_DIR="$(normalize_lesson_dir "${LESSON_FILTER}")"

lesson_binaries=()
while IFS= read -r binary_path; do
    lesson_binaries+=("${binary_path}")
done < <(
    if [[ -n "${LESSON_DIR}" ]]; then
        find "${BUILD_ROOT}/${LESSON_DIR}" \
            -type f \
            -perm -111 \
            ! -name "*.o" \
            ! -name "*.a" \
            ! -name "*.so" \
            ! -name "*.cmake" \
            ! -name "CMake*" \
            | sort
    else
        find "${BUILD_ROOT}" \
            -type f \
            -path "*/Lesson-[0-9][0-9]/*" \
            -perm -111 \
            ! -name "*.o" \
            ! -name "*.a" \
            ! -name "*.so" \
            ! -name "*.cmake" \
            ! -name "CMake*" \
            | sort
    fi
)

if [[ ${#lesson_binaries[@]} -eq 0 ]]; then
    if [[ -n "${LESSON_DIR}" ]]; then
        echo "No lesson binaries found under ${BUILD_ROOT}/${LESSON_DIR}"
    else
        echo "No lesson binaries found under ${BUILD_ROOT}"
        echo "Expected lesson directories in the format Lesson-0x."
    fi
    exit 1
fi

echo "Deploy target: ${PI_USER}@${PI_HOST}:${REMOTE_DIR}"
if [[ -n "${LESSON_DIR}" ]]; then
    echo "Lesson filter: ${LESSON_DIR}"
else
    echo "Lesson filter: all lessons"
fi

echo "Files to deploy:"
for binary_local in "${lesson_binaries[@]}"; do
    echo "  - $(basename "${binary_local}")"
done

relative_paths=()
for binary_local in "${lesson_binaries[@]}"; do
    relative_paths+=("${binary_local#${BUILD_ROOT}/}")
done

(
    cd "${BUILD_ROOT}"
    COPYFILE_DISABLE=1 tar --no-xattrs --no-acls -czf - "${relative_paths[@]}"
) | ssh "${PI_USER}@${PI_HOST}" "mkdir -p ${REMOTE_DIR} && tar -xzf - -C ${REMOTE_DIR}"

echo "Deployed ${#lesson_binaries[@]} binary file(s) to ${PI_USER}@${PI_HOST}:${REMOTE_DIR}"