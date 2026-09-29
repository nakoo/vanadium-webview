ui_print "************************************"
ui_print "   Vanadium WebView Installer       "
ui_print "************************************"

# Check Android API (Requires Android 14 / API 34+)
[ "$API" -lt 34 ] && abort "Error: Android 14+ (API 34+) is required!"

# Check Architecture
[ "$ARCH" != "arm64" ] && abort "Error: Only arm64 architecture is supported!"

ui_print "- Disabling conflicting WebView implementations..."
pm disable com.android.webview 2>/dev/null || true
pm disable com.google.android.webview 2>/dev/null || true
pm disable com.google.android.trichromelibrary 2>/dev/null || true

# Detect LineageOS ROMs
if getprop | grep -qi "lineage"; then
    TLP="system/product/app/VTL"
    WVP="system/product/app/VWV"
else
    TLP="system/app/VTL"
    WVP="system/app/VWV"
fi

mkdir -p "$MODPATH/$TLP" "$MODPATH/$WVP"

ui_print "- Installing TrichromeLibrary..."
mv "$MODPATH/apks/TrichromeLibrary.apk" "$MODPATH/$TLP/VTL.apk"
[ -s "$MODPATH/$TLP/VTL.apk" ] || abort "Failed to install TrichromeLibrary!"

ui_print "- Installing Vanadium WebView..."
mv "$MODPATH/apks/TrichromeWebView.apk" "$MODPATH/$WVP/VWV.apk"
[ -s "$MODPATH/$WVP/VWV.apk" ] || abort "Failed to install Vanadium WebView!"

# Find active overlay partition
if getprop | grep -qi "lineage" || [ -d /system/product/overlay ]; then
    OVERLAY_PATH="system/product/overlay"
elif [ -d /system_ext/overlay ]; then
    OVERLAY_PATH="system/system_ext/overlay"
elif [ -d /system/overlay ]; then
    OVERLAY_PATH="system/overlay"
elif [ -d /system/vendor/overlay ]; then
    OVERLAY_PATH="system/vendor/overlay"
else
    abort "No valid overlay directory found on device!"
fi

ui_print "- Installing WebView overlay into /$OVERLAY_PATH..."
mkdir -p "$MODPATH/$OVERLAY_PATH"
mv "$MODPATH/overlay/CustomWebViewOverlay.apk" "$MODPATH/$OVERLAY_PATH/CustomWebViewOverlay.apk"

# Cleanup temporary build files
rm -rf "$MODPATH/overlay" "$MODPATH/apks" "$MODPATH/system/.placeholder"
