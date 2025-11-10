#!/bin/bash
# Build Script for Buffalo Brook Gold Rush - Linux
# Creates optimized Linux build with Godot 4

set -e  # Exit on any error

echo "Building Buffalo Brook Gold Rush for Linux..."

# Create build directory if it doesn't exist
BUILD_DIR="./builds/linux"
mkdir -p "$BUILD_DIR"

# Export the project for Linux
godot --headless --export-release "Linux" "$BUILD_DIR/buffalo_brook_gold_rush.x86_64"

if [ $? -eq 0 ]; then
    echo "Linux build completed successfully!"
    echo "Build location: $BUILD_DIR/buffalo_brook_gold_rush.x86_64"
    
    # Make executable
    chmod +x "$BUILD_DIR/buffalo_brook_gold_rush.x86_64"
    
    # Optionally, create a ZIP archive
    cd "$BUILD_DIR"
    zip -r "../Buffalo_Brook_Gold_Rush_Linux.zip" "buffalo_brook_gold_rush.x86_64"
    cd ..
    
    echo "Linux build packaged as Buffalo_Brook_Gold_Rush_Linux.zip"
else
    echo "Error: Linux build failed!"
    exit 1
fi