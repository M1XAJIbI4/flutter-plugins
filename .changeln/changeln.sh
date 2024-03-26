#!/bin/bash

###################################################
## Generating changelogs for all project components
###################################################

# battery_plus_aurora
changeln --conf ./packages/battery_plus/battery_plus_aurora/changeln.yaml

# cached_network_image
changeln --conf ./packages/cached_network_image/changeln.yaml

# camera_aurora
changeln --conf ./packages/camera/camera_aurora/changeln.yaml

# connectivity_plus_aurora
changeln --conf ./packages/connectivity_plus/connectivity_plus_aurora/changeln.yaml

# device_info_plus_aurora
changeln --conf ./packages/device_info_plus/device_info_plus_aurora/changeln.yaml

# flutter_cache_manager
changeln --conf ./packages/flutter_cache_manager/changeln.yaml

# flutter_keyboard_visibility_aurora
changeln --conf ./packages/flutter_keyboard_visibility/flutter_keyboard_visibility_aurora/changeln.yaml

# flutter_local_notifications_aurora
changeln --conf ./packages/flutter_local_notifications/flutter_local_notifications_aurora/changeln.yaml

# flutter_secure_storage_aurora
changeln --conf ./packages/flutter_secure_storage/flutter_secure_storage_aurora/changeln.yaml

# google_fonts
changeln --conf ./packages/google_fonts/changeln.yaml

# package_info_plus_aurora
changeln --conf ./packages/package_info_plus/package_info_plus_aurora/changeln.yaml

# path_provider_aurora
changeln --conf ./packages/path_provider/path_provider_aurora/changeln.yaml

# sensors_plus_aurora
changeln --conf ./packages/sensors_plus/sensors_plus_aurora/changeln.yaml

# shared_preferences_aurora
changeln --conf ./packages/shared_preferences/shared_preferences_aurora/changeln.yaml

# sqflite_aurora
changeln --conf ./packages/sqflite/sqflite_aurora/changeln.yaml

# wakelock_plus_aurora
changeln --conf ./packages/wakelock_plus/wakelock_plus_aurora/changeln.yaml

# xdga_directories
changeln --conf ./packages/xdga_directories/changeln.yaml
