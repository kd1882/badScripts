#!/bin/bash
# Usage: ./archive-project.sh project-dir
PROJECT_DIR="$1"
TIMESTAMP=$(date "+%Y%m%d-%H%M%S")
ARCHIVE_NAME="${PROJECT_DIR##*/}_$TIMESTAMP.tar.gz"

tar -czvf "$ARCHIVE_NAME" "$PROJECT_DIR"

