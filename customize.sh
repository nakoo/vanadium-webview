ui_print "************************************"
ui_print "   Vanadium WebView Installer       "
ui_print "************************************"

# Check Android API (Requires Android 14 / API 34+)
if [[ $API -lt 34 ]]; then
    abort "Error: Android 14+ (API 34+) is required!"
fi

# Check Architecture
if [[ "$ARCH" != "arm64" ]]; then
    abort "Error: Only arm64 architecture is supported!"
fi

ui_print "- Disabling conflicting WebView implementations..."
pm disable com.android.webview 2>/dev/null || true
pm disable com.google.android.webview 2>/dev/null || true
pm disable com.google.android.trichromelibrary 2>/dev/null || true

# Execute main installation script
if [ -f "$MODPATH/common/install.sh" ]; then
    . "$MODPATH/common/install.sh"
else
    abort "Error: Installation script missing!"
fi
