#!/system/bin/sh
MODDIR=${0%/*}

ui_print() { echo "$1"; }

ui_print "************************************"
ui_print " Updating Vanadium WebView packages "
ui_print "************************************"

# Locate bundled APK base directory
if [ -d "$MODDIR/system/product/app/VTL" ]; then
    APP_BASE="$MODDIR/system/product/app"
elif [ -d "$MODDIR/system/app/VTL" ]; then
    APP_BASE="$MODDIR/system/app"
else
    ui_print "Error: Bundled APKs not found in module directory!"
    exit 1
fi

# TrichromeLibrary (VTL) must be installed before WebView (VWV)
for pkg in VTL VWV; do
    SRC="$APP_BASE/$pkg/$pkg.apk"
    TMP="/data/local/tmp/$pkg.apk"

    if [ -f "$SRC" ]; then
        ui_print "- Staging and installing $pkg..."
        cp "$SRC" "$TMP"
        chmod 644 "$TMP"
        pm install -r --install-location 1 "$TMP"
        rm -f "$TMP"
    else
        ui_print "Warning: $SRC missing, skipping..."
    fi
done

ui_print "Update complete!"
