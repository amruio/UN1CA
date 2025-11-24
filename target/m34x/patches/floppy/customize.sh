KERNEL_URL="https://github.com/FlopKernel-Series/flop_s5e8825-build_compendium/releases/download/flop-v6.0"
KERNEL_ARCHIVE="FloppyAOSP_v6.0-Vanilla-exynos1280-20251122-1752.tar"

[[ -d "$TMP_DIR" ]] && EVAL "rm -rf \"$TMP_DIR\""
mkdir -p "$TMP_DIR"

DOWNLOAD_FILE "$KERNEL_URL/$KERNEL_ARCHIVE" "$TMP_DIR/$KERNEL_ARCHIVE"

for i in "boot" "vendor_boot"; do
    LOG "- Replacing $i.img"
    EVAL "tar -xvf \"$TMP_DIR/$KERNEL_ARCHIVE\" -C \"$TMP_DIR\" \"$i.img.lz4\""
    EVAL "lz4 -df --rm \"$TMP_DIR/$i.img.lz4\" \"$TMP_DIR/$i.img\""
    [[ -f "$WORK_DIR/kernel/$i.img" ]] && rm -f "$WORK_DIR/kernel/$i.img"
    EVAL "mv \"$TMP_DIR/$i.img\" \"$WORK_DIR/kernel/$i.img\""
done

EVAL "rm -rf \"$TMP_DIR\""
