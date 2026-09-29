#!/system/bin/sh

# 1. Re-enable standard system WebViews and libraries
pm enable com.android.webview 2>/dev/null || true
pm enable com.google.android.webview 2>/dev/null || true
pm enable com.google.android.trichromelibrary 2>/dev/null || true

# 2. Clean up data updates if action.sh was ever run
pm uninstall app.vanadium.webview 2>/dev/null || true
pm uninstall app.vanadium.trichromelibrary 2>/dev/null || true

# 3. Explicitly switch active WebView back to stock default
cmd webviewupdate set-webview-implementation com.google.android.webview 2>/dev/null || \
cmd webviewupdate set-webview-implementation com.android.webview 2>/dev/null || true
