KERNEL_URL="https://github.com/FlopKernel-Series/flop_s5e8825-build_compendium/releases/download/flop-v6.0"
KERNEL_ARCHIVE="FloppyOneUI_v6.0-Vanilla-exynos1280-20251122-1752"

if [[ -d "$TMP_DIR" ]]; then
    EVAL "rm -rf \"$TMP_DIR\""
fi
mkdir -p "$TMP_DIR"

DOWNLOAD_FILE "$KERNEL_URL/$KERNEL_ARCHIVE.tar" "$TMP_DIR/$KERNEL_ARCHIVE.tar"

for i in "boot" "vendor_boot"; do
    LOG "- Replacing $i.img"
    EVAL "tar -xvf \"$TMP_DIR/$KERNEL_ARCHIVE.tar\" -C \"$TMP_DIR\" \"$i.img.lz4\""
    EVAL "lz4 -df --rm \"$TMP_DIR/$i.img.lz4\" \"$TMP_DIR/$i.img\""
    if [[ -f "$WORK_DIR/kernel/$i.img" ]]; then
        rm -f "$WORK_DIR/kernel/$i.img"
    fi
    EVAL "mv \"$TMP_DIR/$i.img\" \"$WORK_DIR/kernel/$i.img\""
done

EVAL "rm -rf \"$TMP_DIR\""
