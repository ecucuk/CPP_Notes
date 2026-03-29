#!/usr/bin/env bash
set -euo pipefail

PI_USER="ergun.cucuk"
PI_HOST="192.168.1.25"
REMOTE_DIR="/home/${PI_USER}/Projects"
PORT="2345"

LESSON_FILTER="${1:-1}"

normalize_lesson() {
    local input="$1"

    if [[ "$input" =~ ^[0-9]$ ]]; then
        printf "Lesson-0%s\n" "$input"
    elif [[ "$input" =~ ^[0-9][0-9]$ ]]; then
        printf "Lesson-%s\n" "$input"
    elif [[ "$input" =~ ^Lesson-[0-9][0-9]$ ]]; then
        printf "%s\n" "$input"
    else
        echo "Invalid lesson: $input"
        exit 1
    fi
}

LESSON_DIR=$(normalize_lesson "$LESSON_FILTER")

# Binary name çıkar
BINARY_NAME=$(ls build-rpi5/Examples/${LESSON_DIR} | grep -E '^lesson_')

echo "Starting gdbserver on ${PI_HOST}:${PORT} (${BINARY_NAME})"

ssh -t "${PI_USER}@${PI_HOST}" \
    "cd ${REMOTE_DIR}/${LESSON_DIR} && gdbserver :${PORT} ./${BINARY_NAME}"