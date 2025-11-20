REPOSITORY="https://github.com/majaahh/proprietary_vendor_samsung_exynos/releases/download"
A5360_TAG="A5360ZHSHFYI1_TGY_OZS"
A536B_TAG="A536BXXSHFYI1_EUX_OXM"
A536E_TAG="A536EXXSHFYI4_INS_ODM"
A536N_TAG="A536NKSSCFYH1_KOO_OKR"

for i in "A5360" "A536B" "A536E" "A536N"; do
    MODEL_TAG_NAME="${i}_TAG"
    eval "MODEL_TAG=\${$MODEL_TAG_NAME}"
    ZIP_ARCHIVE="$(echo "$MODEL_TAG" | cut -d'_' -f1)_BL_CP-los"
    BOOTLOADER_BLOBS="\"fld.bin_SM-$i\" "
    BOOTLOADER_BLOBS+="\"harx.bin_SM-$i\" "
    BOOTLOADER_BLOBS+="\"keystorage.bin_SM-$i\" "
    BOOTLOADER_BLOBS+="\"ldfw.img_SM-$i\" "
    BOOTLOADER_BLOBS+="\"modem.bin_SM-$i\" "
    BOOTLOADER_BLOBS+="\"modem_debug.bin_SM-$i\" "
    BOOTLOADER_BLOBS+="\"sboot.bin_SM-$i\" "
    BOOTLOADER_BLOBS+="\"tzar.img_SM-$i\" "
    BOOTLOADER_BLOBS+="\"tzsw.img_SM-$i\" "
    BOOTLOADER_BLOBS+="\"uh.bin_SM-$i\""

    LOG "- Downloading $ZIP_ARCHIVE.zip"
    DOWNLOAD_FILE "$REPOSITORY/$MODEL_TAG/$ZIP_ARCHIVE.zip" "$TMP_DIR/$ZIP_ARCHIVE.zip" || return 1

    LOG "- Extracting $ZIP_ARCHIVE.zip"
    EVAL "unzip \"$TMP_DIR/$ZIP_ARCHIVE.zip\" -d \"$TMP_DIR\" $BOOTLOADER_BLOBS" || return 1
    EVAL "rm -f \"$TMP_DIR/$ZIP_ARCHIVE.zip\""
done
