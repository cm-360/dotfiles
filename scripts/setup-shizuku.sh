#!/bin/sh

echo ""
echo "Setting up Shizuku Rish integration..."
echo "Before proceeding, please:"
echo "  1. Open the Shizuku app."
echo "  2. Go to 'Use Shizuku in terminal apps'."
echo "  3. Tap 'Export files'."
echo "  4. Choose or create a folder named 'rish'."
echo ""
read -p "Press Enter once you have completed the above steps."

RISH_EXPORT_DIR="$HOME/storage/shared/rish"
TERMUX_BIN_DIR="/data/data/com.termux/files/usr/bin"

if [ -d "$RISH_EXPORT_DIR" ]; then
    cp "$RISH_EXPORT_DIR/rish" "$TERMUX_BIN_DIR/rish"
    cp "$RISH_EXPORT_DIR/rish_shizuku.dex" "$TERMUX_BIN_DIR/rish_shizuku.dex"
    sed -i 's/PKG/com.termux/g' "$TERMUX_BIN_DIR/rish"
    chmod +x "$TERMUX_BIN_DIR/rish"
else
    echo "⚠ Missing 'rish' directory, skipping."
fi
