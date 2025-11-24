EXTRACT_DTBO() {
    local REVS=("0" "4" "5")
    local DTBO="$TMP_DIR/dtbo"
    local DTSI="$TMP_DIR/dtsi"

    [[ -d "$TMP_DIR" ]] && rm -rf "$TMP_DIR"
    mkdir -p "$TMP_DIR"

    EVAL "mkdtboimg dump $WORK_DIR/kernel/dtbo.img --dtb $DTBO"

    for i in $(seq 0 2); do
        EVAL "dtc -I dtb -O dts $DTBO.$i -o $DTSI.$i"
        EVAL "rm -f \"$DTBO.$i\"" || true
    done
}

APPLY_DTBO_PATCH() {
    local PATCH="$SRC_DIR/target/a25x/patches/dtbo/patches/$1"

    if [[ ! -f "$PATCH" ]]; then
        LOGE "File not found: ${PATCH//$SRC_DIR\//}"
        return 1
    fi

    LOG "- Applying \"$(grep "^Subject:" "$PATCH" | sed "s/.*PATCH] //")\" to dtbo"
    EVAL "LC_ALL=C git apply --directory=\"$TMP_DIR\" --verbose --unsafe-paths \"$PATCH\"" || return 1
}

PACK_TO_DTBO() {
    local REVS=("0" "4" "5")

    for i in "${!REVS[@]}"; do
        EVAL "dtc -I dts -O dtb -o $TMP_DIR/a25x_swa_open_w00_r0${REVS[$i]}.dtbo $TMP_DIR/dtsi.$i"
    done
}

PACK_TO_IMG() {
    local CONF="$SRC_DIR/target/a25x/patches/dtbo/a25x.cfg"

    EVAL "mkdtboimg cfg_create $TMP_DIR/dtbo.img $CONF -d $TMP_DIR"
}

LOG "- Extracting dtbo"
EXTRACT_DTBO
APPLY_DTBO_PATCH "0001-Fix-Adaptive-Refresh-Rate-Color-Flickering.patch"
LOG "- Repacking dtbo"
PACK_TO_DTBO
PACK_TO_IMG
[[ -f "$WORK_DIR/kernel/dtbo.img" ]] && rm -rf "$WORK_DIR/kernel/dtbo.img"
LOG "- Copying new dtbo.img"
EVAL "cp -fa \"$TMP_DIR/dtbo.img\" \"$WORK_DIR/kernel/dtbo.img\""

rm -rf "$TMP_DIR"
