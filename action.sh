#!/system/bin/sh
MODDIR=${0%/*}

ui_print() { echo "$1"; }

ui_print "************************************"
ui_print " Updating Vanadium WebView packages "
ui_print "************************************"

CURL_BIN="curl -s -L --connect-timeout 15 --retry 3 --dns-servers 1.1.1.1,1.0.0.1"

ui_print "- Downloading latest TrichromeLibrary..."
$CURL_BIN -o /data/local/tmp/VTL.apk \
    "https://gitlab.com/grapheneos/platform_external_vanadium/-/raw/17/prebuilt/arm64/TrichromeLibrary.apk?ref_type=heads"

ui_print "- Downloading latest Vanadium WebView..."
$CURL_BIN -o /data/local/tmp/VWV.apk \
    "https://gitlab.com/grapheneos/platform_external_vanadium/-/raw/17/prebuilt/arm64/TrichromeWebView.apk?ref_type=heads"

ui_print "- Installing updates..."
pm install -r --install-location 1 /data/local/tmp/VTL.apk
pm install -r --install-location 1 /data/local/tmp/VWV.apk

rm -f /data/local/tmp/VTL.apk /data/local/tmp/VWV.apk
ui_print "Update complete!"
