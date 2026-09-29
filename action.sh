#!/system/bin/sh
MODDIR=${0%/*}

ui_print() { echo "$1"; }

ui_print "************************************"
ui_print " Updating Vanadium WebView packages "
ui_print "************************************"

# Locate bundled APKs in module directory
if [ -f "$MODDIR/system/product/app/VTL/VTL.apk" ]; then
    VTL_SRC="$MODDIR/system/product/app/VTL/VTL.apk"
    VWV_SRC="$MODDIR/system/product/app/VWV/VWV.apk"
elif [ -f "$MODDIR/system/app/VTL/VTL.apk" ]; then
    VTL_SRC="$MODDIR/system/app/VTL/VTL.apk"
    VWV_SRC="$MODDIR/system/app/VWV/VWV.apk"
else
    ui_print "Error: Bundled APKs not found in module directory!"
    exit 1
fi

ui_print "- Staging bundled TrichromeLibrary..."
cp "$VTL_SRC" /data/local/tmp/VTL.apk
chmod 644 /data/local/tmp/VTL.apk

ui_print "- Staging bundled Vanadium WebView..."
cp "$VWV_SRC" /data/local/tmp/VWV.apk
chmod 644 /data/local/tmp/VWV.apk

ui_print "- Installing updates..."
pm install -r --install-location 1 /data/local/tmp/VTL.apk
pm install -r --install-location 1 /data/local/tmp/VWV.apk

rm -f /data/local/tmp/VTL.apk /data/local/tmp/VWV.apk
ui_print "Update complete!"
