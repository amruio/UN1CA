# [
APPLY_VENDOR_PATCH()
{
    _CHECK_NON_EMPTY_PARAM "DIR" "$1" || return 1
    _CHECK_NON_EMPTY_PARAM "PATCH" "$2" || return 1

    local DIR="$1"
    local PATCH="$2"
    local PATCH_PATH="$MODPATH/patches/$DIR/$PATCH"

    if [[ ! -f "$PATCH_PATH" ]]; then
        LOGE "File not found: ${PATCH_PATH//$SRC_DIR\//}"
        return 1
    fi

    LOG "- Applying \"$(grep "^Subject:" "$PATCH_PATH" | sed "s/.*PATCH] //")\" to /vendor/$DIR"
    EVAL "LC_ALL=C git apply --directory=\"$WORK_DIR/vendor/$DIR\" --verbose --unsafe-paths \"$PATCH_PATH\"" || return 1
}
# ]

APPLY_VENDOR_PATCH "etc" "0001-Always-affine-SF-to-all-CPU-cores.patch"

if ! grep -q "HiddenMenu" "$WORK_DIR/vendor/etc/init/init.s5e8825.rc"; then
    APPLY_VENDOR_PATCH "etc/init" "0000-Create-carrier-folder-for-HiddenMenu.patch"
fi
APPLY_VENDOR_PATCH "etc/init" "0001-Optimize-for-faster-boot-time.patch"
APPLY_VENDOR_PATCH "etc/init" "0002-Disable-UFS-Power-Saving-on-Init.patch"
APPLY_VENDOR_PATCH "etc/init" "0003-Restrict-apps-access-to-proc-net-unix.patch"

LOG_STEP_IN "- Updating GPU blobs"
ADD_TO_WORK_DIR "a54xnsxx" "vendor" "lib/egl"
ADD_TO_WORK_DIR "a54xnsxx" "vendor" "lib64/egl"
ADD_TO_WORK_DIR "a54xnsxx" "vendor" "etc"
LOG_STEP_OUT
