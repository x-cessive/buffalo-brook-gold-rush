#!/bin/bash
# Build Script for Buffalo Brook Gold Rush - Windows
# Creates optimized Windows build with Godot 4

set -e  # Exit on any error

echo "Building Buffalo Brook Gold Rush for Windows..."

# Create build directory if it doesn't exist
BUILD_DIR="./builds/windows"
mkdir -p "$BUILD_DIR"

# Export the project for Windows
godot --headless --export-release "Windows" "$BUILD_DIR/BuffaloBrookGoldRush.exe"

if [ $? -eq 0 ]; then
    echo "Windows build completed successfully!"
    echo "Build location: $BUILD_DIR/BuffaloBrookGoldRush.exe"
    
    # Optionally, create a ZIP archive with required DLLs and other files
    cd "$BUILD_DIR"
    zip -r "../Buffalo_Brook_Gold_Rush_Windows.zip" "BuffaloBrookGoldRush.exe"
    cd ..
    
    echo "Windows build packaged as Buffalo_Brook_Gold_Rush_Windows.zip"
else
    echo "Error: Windows build failed!"
    exit 1
fi