#!/system/bin/sh

# Detect LineageOS ROMs
LOS=$(getprop | grep -o -c "lineage")

if [[ $LOS -gt 0 ]]; then
    TLP="system/product/app/VTL"
    WVP="system/product/app/VWV"
else
    TLP="system/app/VTL"
    WVP="system/app/VWV"
fi

mkdir -p "$MODPATH/$TLP" "$MODPATH/$WVP"

ui_print "- Installing TrichromeLibrary..."
cp "$MODPATH/apks/TrichromeLibrary.apk" "$MODPATH/$TLP/VTL.apk"
[[ -s "$MODPATH/$TLP/VTL.apk" ]] || abort "Failed to copy TrichromeLibrary!"

ui_print "- Installing Vanadium WebView..."
cp "$MODPATH/apks/TrichromeWebView.apk" "$MODPATH/$WVP/VWV.apk"
[[ -s "$MODPATH/$WVP/VWV.apk" ]] || abort "Failed to copy Vanadium WebView!"

# Find active overlay partition
if [[ $LOS -gt 0 ]]; then
    OVERLAY_PATH="system/product/overlay"
elif [[ -d /system/product/overlay ]]; then
    OVERLAY_PATH="system/product/overlay"
elif [[ -d /system_ext/overlay ]]; then
    OVERLAY_PATH="system/system_ext/overlay"
elif [[ -d /system/overlay ]]; then
    OVERLAY_PATH="system/overlay"
elif [[ -d /system/vendor/overlay ]]; then
    OVERLAY_PATH="system/vendor/overlay"
else
    abort "No valid overlay directory found on device!"
fi

ui_print "- Installing WebView overlay into /$OVERLAY_PATH..."
mkdir -p "$MODPATH/$OVERLAY_PATH"
cp "$MODPATH/overlay/CustomWebViewOverlay.apk" "$MODPATH/$OVERLAY_PATH/CustomWebViewOverlay.apk"

# Cleanup temporary files inside module directory
rm -rf "$MODPATH/overlay"
rm -rf "$MODPATH/apks"
rm -rf "$MODPATH/system/.placeholder"
