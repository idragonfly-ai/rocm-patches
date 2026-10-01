#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATCH_DIR="$SCRIPT_DIR/patch"

echo "Checking patch directory..."

if [ ! -d "$PATCH_DIR" ]; then
    echo "Error: Directory $PATCH_DIR does not exist."
    exit 1
fi

LOCAL_FILES=$(find "$PATCH_DIR" -maxdepth 1 -type f -name "*906*" | wc -l)

if [ "$LOCAL_FILES" -eq 0 ]; then
    echo "Error: No gfx906 files found in $PATCH_DIR"
    exit 1
fi

echo "Found $LOCAL_FILES gfx906 files in patch directory."

echo "Locating active rocblas library path..."

TARGET_DIR=$(find /opt /usr/lib -type d -path "*/rocblas/*/library" -o -path "*/rocblas/library" 2>/dev/null | head -n 1)

if [ -z "$TARGET_DIR" ]; then
    echo "Error: Could not locate rocblas library path on this system."
    exit 1
fi

echo "Target directory found: $TARGET_DIR"

echo "Copying files quietly..."
sudo cp "$PATCH_DIR"/*906* "$TARGET_DIR/"

echo "Syncing filesystem..."
sudo sync

echo "Patch complete. $LOCAL_FILES files successfully deployed to $TARGET_DIR."
