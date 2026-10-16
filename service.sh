#!/system/bin/sh
MODDIR=${0%/*}

# Wait until boot is fully completed
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 2
done

# Current version stamp from module.prop
CURRENT_VER=$(grep "^versionCode=" "$MODDIR/module.prop" | cut -d= -f2)

# If not registered or module version changed, register/update with arm64 ABI override
if [ ! -f "$MODDIR/.installed" ] || [ "$(cat "$MODDIR/.installed")" != "$CURRENT_VER" ] || ! pm list packages | grep -q "app.vanadium.webview"; then
    if [ -f /system/product/app/VWV/VWV.apk ]; then
        VWV_PATH="/system/product/app/VWV/VWV.apk"
    elif [ -f /system/app/VWV/VWV.apk ]; then
        VWV_PATH="/system/app/VWV/VWV.apk"
    else
        VWV_PATH="$MODDIR/system/app/VWV/VWV.apk"
    fi

    pm install -r --abi arm64-v8a "$VWV_PATH" 2>/dev/null || true

    echo "$CURRENT_VER" > "$MODDIR/.installed"
fi

# Ensure Vanadium WebView is active
cmd webviewupdate set-webview-implementation app.vanadium.webview 2>/dev/null || true
