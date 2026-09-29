#!/system/bin/sh
# Re-enable standard system WebViews upon module removal
pm enable com.android.webview 2>/dev/null || true
pm enable com.google.android.webview 2>/dev/null || true
pm enable com.google.android.trichromelibrary 2>/dev/null || true
