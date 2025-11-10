#!/bin/bash
# Build Script for Buffalo Brook Gold Rush - Android
# Creates optimized Android build with Godot 4

set -e  # Exit on any error

echo "Building Buffalo Brook Gold Rush for Android..."

# Create build directory if it doesn't exist
BUILD_DIR="./builds/android"
mkdir -p "$BUILD_DIR"

# Export the project for Android
godot --headless --export-release "Android" "$BUILD_DIR/buffalo_brook_gold_rush.apk"

if [ $? -eq 0 ]; then
    echo "Android build completed successfully!"
    echo "Build location: $BUILD_DIR/buffalo_brook_gold_rush.apk"
    
    # APK is already a complete package, but we'll just confirm
    if [ -f "$BUILD_DIR/buffalo_brook_gold_rush.apk" ]; then
        echo "APK file created successfully!"
        ls -lh "$BUILD_DIR/buffalo_brook_gold_rush.apk"
        
        # Copy to higher level directory as well
        cp "$BUILD_DIR/buffalo_brook_gold_rush.apk" .
        echo "APK also copied to main directory as buffalo_brook_gold_rush.apk"
    else
        echo "Error: APK file was not created!"
        exit 1
    fi
else
    echo "Error: Android build failed!"
    exit 1
fi