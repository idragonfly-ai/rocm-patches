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

ACTIVE_LIB=$(readlink -f /usr/lib/x86_64-linux-gnu/librocblas.so || true)

if [ -z "$ACTIVE_LIB" ] || [ ! -e "$ACTIVE_LIB" ]; then
    ACTIVE_LIB=$(find /usr/lib/x86_64-linux-gnu -name "librocblas.so.*" | sort -V | tail -n 1)
fi

if [ -z "$ACTIVE_LIB" ]; then
    echo "Error: Could not determine active rocblas library version." >&2
    exit 1
fi

ACTIVE_ROCM_PATH=$(dirname "$ACTIVE_LIB")

# Find the target rocblas library folder corresponding to the active path
TARGET_DIR=$(find "$ACTIVE_ROCM_PATH" -type d -path "*/rocblas/*/library" -o -path "*/rocblas/library" 2>/dev/null | head -n 1)

if [ -z "$TARGET_DIR" ]; then
    # Fallback to general search if specific subpath isn't directly beneath active path
    TARGET_DIR=$(find /usr/lib/x86_64-linux-gnu -type d -path "*/rocblas/*/library" -o -path "*/rocblas/library" 2>/dev/null | head -n 1)
fi

if [ -z "$TARGET_DIR" ]; then
    echo "Error: Could not locate rocblas target library directory on this system."
    exit 1
fi

echo "Target directory found: $TARGET_DIR"

echo "Copying files quietly..."
sudo cp "$PATCH_DIR"/*906* "$TARGET_DIR/"

echo "Syncing filesystem..."
sudo sync

echo "Patch complete. $LOCAL_FILES files successfully deployed to $TARGET_DIR."

