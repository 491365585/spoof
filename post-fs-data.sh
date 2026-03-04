#!/system/bin/sh
# System Property Debugging Tool
# Reference implementation for modifying device identifiers during post-fs-data stage.

MODDIR="${0%/*}"
SERIAL_FILE="$MODDIR/serial.txt"
LOG_FILE="$MODDIR/system_props.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
}

if [ -f "$SERIAL_FILE" ]; then
    NEW_VAL=$(cat "$SERIAL_FILE" | tr -d '[:space:]')
else
    # Generate random 10-char value for testing
    NEW_VAL=$(cat /dev/urandom | tr -dc 'A-Z0-9' | head -c 10)
    echo "$NEW_VAL" > "$SERIAL_FILE"
fi

if [ -n "$NEW_VAL" ]; then
    log "Updating property identifiers to: $NEW_VAL"

    # Step 1: Manage persistent property cache
    resetprop --delete persist.sys.serialno 2>/dev/null

    # Step 2: Override read-only (ro.*) properties
    # Using -n to skip property change notification
    resetprop -n ro.serialno "$NEW_VAL"
    resetprop -n ro.boot.serialno "$NEW_VAL"
    resetprop -n ro.vendor.serialno "$NEW_VAL"

    # Step 3: Write persistent (persist.*) properties
    # Using -p to write to persistent storage
    resetprop -p persist.sys.serialno "$NEW_VAL"

    # Step 4: Additional identifier properties for consistency
    resetprop -n ro.ril.serialnumber "$NEW_VAL" 2>/dev/null
    resetprop -n sys.serialnumber "$NEW_VAL" 2>/dev/null
    resetprop -n gsm.serial "$NEW_VAL" 2>/dev/null

    # Step 5: Verification
    VERIFY=$(getprop persist.sys.serialno)
    if [ "$VERIFY" = "$NEW_VAL" ]; then
        log "STATE_VALIDATED: persist.sys.serialno = $VERIFY"
    else
        log "STATE_MISMATCH: persist.sys.serialno = $VERIFY"
        resetprop persist.sys.serialno "$NEW_VAL"
        resetprop -p persist.sys.serialno "$NEW_VAL"
    fi

    log "Property update sequence completed."
fi
