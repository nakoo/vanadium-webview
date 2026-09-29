#!/system/bin/sh
MODDIR=${0%/*}

# Wait until boot is fully completed
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 2
done

# Ensure Vanadium WebView is active
cmd webviewupdate set-webview-implementation app.vanadium.webview 2>/dev/null || true
