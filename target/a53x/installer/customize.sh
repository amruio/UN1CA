REPOSITORY="https://github.com/majaahh/proprietary_vendor_samsung_exynos/releases/download"
BOOTLOADER_BLOBS=(
    "fld.bin_SM-%s"
    "harx.bin_SM-%s"
    "keystorage.bin_SM-%s"
    "ldfw.img_SM-%s"
    "modem.bin_SM-%s"
    "modem_debug.bin_SM-%s"
    "sboot.bin_SM-%s"
    "tzar.img_SM-%s"
    "tzsw.img_SM-%s"
    "uh.bin_SM-%s"
)

declare -A MODEL_TAGS=(
    [A5360]="A5360ZHSHFYI1_TGY_OZS"
    [A536B]="A536BXXSHFYI1_EUX_OXM"
    [A536E]="A536EXXSHFYI4_INS_ODM"
    [A536N]="A536NKSSCFYH1_KOO_OKR"
)

printf "%s\n" "A5360" "A536B" "A536E" "A536N" | while read -r MODEL; do
    MODEL_TAG="${MODEL_TAGS[$MODEL]}"
    [[ -z "${MODEL_TAG:-}" ]] && {
        ABORT "No tag defined for $MODEL"
    }

    ZIP_ARCHIVE="${MODEL_TAG%%_*}_BL_CP-los"
    ZIP_PATH="$TMP_DIR/$ZIP_ARCHIVE.zip"

    BLOBS=""
    for i in "${BOOTLOADER_BLOBS[@]}"; do
        BLOBS+="$(printf "$i" "$MODEL") "
    done

    LOG "- Downloading $ZIP_ARCHIVE.zip"
    DOWNLOAD_FILE "$REPOSITORY/$MODEL_TAG/$ZIP_ARCHIVE.zip" "$ZIP_PATH" || return 1

    LOG "- Extracting $ZIP_ARCHIVE.zip"
    EVAL "unzip -o \"$ZIP_PATH\" -d \"$TMP_DIR\" $BLOBS" || return 1

    EVAL "rm -f \"$ZIP_PATH\""

    unset BLOBS MODEL_TAG ZIP_ARCHIVE ZIP_PATH
done

unset BOOTLOADER_BLOBS REPOSITORY MODEL_TAG
