#!/bin/bash
# Usage: ./backup-dir.sh source-dir backup-dir
SOURCE_DIR="$1"
BACKUP_DIR="$2"
TIMESTAMP=$(date "+%Y%m%d-%H%M%S")
ARCHIVE_NAME="${SOURCE_DIR##*/}_$TIMESTAMP.tar.gz"

tar -czvf "$BACKUP_DIR/$ARCHIVE_NAME" "$SOURCE_DIR"

