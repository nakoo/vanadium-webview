#!/system/bin/sh
# Ensures permissions on boot
MODDIR=${0%/*}
chmod -R 0755 "$MODDIR"
