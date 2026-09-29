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

# Android 14 includes /system/bin/curl by default
CURL_BIN="curl -s -L --connect-timeout 15 --retry 3 --dns-servers 1.1.1.1,1.0.0.1"

ui_print "- Downloading TrichromeLibrary..."
$CURL_BIN -o "$MODPATH/$TLP/VTL.apk" \
    "https://gitlab.com/grapheneos/platform_external_vanadium/-/raw/17/prebuilt/arm64/TrichromeLibrary.apk?ref_type=heads"
[[ -s "$MODPATH/$TLP/VTL.apk" ]] || abort "Failed to download TrichromeLibrary!"

ui_print "- Downloading Vanadium WebView..."
$CURL_BIN -o "$MODPATH/$WVP/VWV.apk" \
    "https://gitlab.com/grapheneos/platform_external_vanadium/-/raw/17/prebuilt/arm64/TrichromeWebView.apk?ref_type=heads"
[[ -s "$MODPATH/$WVP/VWV.apk" ]] || abort "Failed to download Vanadium WebView!"

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
rm -rf "$MODPATH/system/.placeholder"
