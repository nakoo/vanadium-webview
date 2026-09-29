#!/system/bin/sh
MODDIR=${0%/*}

# Wait until boot is fully completed
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 2
done

# Check module version from module.prop
CURRENT_VER=$(grep "^version=" "$MODDIR/module.prop" | cut -d= -f2)

# If not registered or module version changed, update packages
if [ ! -f "$MODDIR/.installed" ] || [ "$(cat "$MODDIR/.installed")" != "$CURRENT_VER" ]; then
    if [ -f /system/product/app/VTL/VTL.apk ]; then
        VTL_PATH="/system/product/app/VTL/VTL.apk"
        VWV_PATH="/system/product/app/VWV/VWV.apk"
    elif [ -f /system/app/VTL/VTL.apk ]; then
        VTL_PATH="/system/app/VTL/VTL.apk"
        VWV_PATH="/system/app/VWV/VWV.apk"
    else
        VTL_PATH="$MODDIR/system/app/VTL/VTL.apk"
        VWV_PATH="$MODDIR/system/app/VWV/VWV.apk"
    fi

    pm install -r --abi arm64-v8a "$VTL_PATH" 2>/dev/null || true
    pm install -r --abi arm64-v8a "$VWV_PATH" 2>/dev/null || true
    
    # Save current version stamp
    echo "$CURRENT_VER" > "$MODDIR/.installed"
fi

# Ensure Vanadium WebView is active
cmd webviewupdate set-webview-implementation app.vanadium.webview 2>/dev/null || true
