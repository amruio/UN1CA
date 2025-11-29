# [
APPLY_PARTITION_PATCH()
{
    _CHECK_NON_EMPTY_PARAM "PARTITION" "$1" || return 1
    _CHECK_NON_EMPTY_PARAM "DIR" "$2" || return 1
    _CHECK_NON_EMPTY_PARAM "PATCH" "$3" || return 1

    local PARTITION="$1"
    local DIR="$2"
    local PATCH="$3"
    local PATCH_PATH="$MODPATH/patches/$PARTITION/$DIR/$PATCH"

    if [[ ! -f "$PATCH_PATH" ]]; then
        LOGE "File not found: ${PATCH_PATH//$SRC_DIR\//}"
        return 1
    fi

    if ! IS_VALID_PARTITION_NAME "$PARTITION"; then
        LOGE "\"$PARTITION\" is not a valid partition name"
        return 1
    fi

    if [[ "$PARTITION" == "system" ]]; then
        PARTITION+="system"
    elif [[ "$PARTITION" == "system_ext" ]]; then
        PARTITION+="system/system_ext"
    fi

    LOG "- Applying \"$(grep "^Subject:" "$PATCH_PATH" | sed "s/.*PATCH] //")\" to /$PARTITION/$DIR"
    EVAL "LC_ALL=C git apply --directory=\"$WORK_DIR/$PARTITION/$DIR\" --verbose --unsafe-paths \"$PATCH_PATH\"" || return 1
}
# ]

APPLY_PARTITION_PATCH "vendor" "etc" "0001-Always-affine-SF-to-all-CPU-cores.patch"
APPLY_PARTITION_PATCH "vendor" "etc/init" "0001-Optimize-for-faster-boot-time.patch"
APPLY_PARTITION_PATCH "vendor" "etc/init" "0002-Disable-UFS-Power-Saving-on-Init.patch"
APPLY_PARTITION_PATCH "vendor" "etc/init" "0003-Restrict-apps-access-to-proc-net-unix.patch"

LOG_STEP_IN "- Updating GPU blobs"
ADD_TO_WORK_DIR "a54xnsxx" "vendor" "lib/egl"
ADD_TO_WORK_DIR "a54xnsxx" "vendor" "lib64/egl"
ADD_TO_WORK_DIR "a54xnsxx" "vendor" "etc"
LOG_STEP_OUT
