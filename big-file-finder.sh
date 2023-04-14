#!/bin/bash
# Usage: ./find-large-files.sh /path/to/search
SEARCH_PATH="$1"

sudo find "$SEARCH_PATH" -type f -size +100M -exec ls -lh {} \;

