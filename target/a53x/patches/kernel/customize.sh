KERNEL_URL="https://api.github.com/repos/majaahh/android_kernel_samsung_a53x/releases/latest"
KERNEL_ARCHIVE_URL="$(curl -s $KERNEL_URL | jq -r '.assets[] | select(.name | test("^UN1CA_Kernel-.*-a53x\\.tar$")) | .browser_download_url')"
KERNEL_ARCHIVE="$(basename $KERNEL_ARCHIVE_URL)"

if [[ -d "$TMP_DIR" ]]; then
    EVAL "rm -rf \"$TMP_DIR\""
fi
EVAL "mkdir -p \"$TMP_DIR\""

DOWNLOAD_FILE "$KERNEL_ARCHIVE_URL" "$TMP_DIR/$KERNEL_ARCHIVE"

LOG "- Extracting $KERNEL_ARCHIVE"
EVAL "tar -xvf \"$TMP_DIR/$KERNEL_ARCHIVE\" -C \"$TMP_DIR\""
EVAL "rm -f \"$TMP_DIR/$KERNEL_ARCHIVE\""

while IFS= read -r f; do
    IMG="$(basename "$f")"

    LOG "- Extracting $IMG"
    EVAL "lz4 -df --rm \"$TMP_DIR/$IMG\" \"$TMP_DIR/${IMG%.lz4}\""

    LOG "- Replacing ${IMG%.lz4}"
    if [[ -f "$WORK_DIR/kernel/${IMG%.lz4}" ]]; then
        EVAL "rm -f \"$WORK_DIR/kernel/${IMG%.lz4}\""
    fi
    EVAL "mv \"$TMP_DIR/${IMG%.lz4}\" \"$WORK_DIR/kernel/${IMG%.lz4}\""
done < <(find "$TMP_DIR" -maxdepth 1 -type f -name "*.img.lz4")

EVAL "rm -rf \"$TMP_DIR\""

unset KERNEL_ARCHIVE KERNEL_ARCHIVE_URL KERNEL_URL
