#!/bin/bash
# Master Build Script for Buffalo Brook Gold Rush
# Builds for all supported platforms: Linux, Windows, Android

set -e  # Exit on any error

echo "======================================="
echo "Buffalo Brook Gold Rush - Master Build"
echo "======================================="

# Make sure build scripts are executable
chmod +x build_linux.sh
chmod +x build_windows.sh
chmod +x build_android.sh

# Ask user which platforms to build
echo "Select platforms to build:"
echo "1) Linux only"
echo "2) Windows only" 
echo "3) Android only"
echo "4) All platforms"
echo -n "Enter choice (1-4): "
read -r choice

case $choice in
    1)
        echo "Building for Linux only..."
        ./build_linux.sh
        ;;
    2)
        echo "Building for Windows only..."
        ./build_windows.sh
        ;;
    3)
        echo "Building for Android only..."
        ./build_android.sh
        ;;
    4)
        echo "Building for all platforms..."
        
        # Build for Linux
        echo "---------------------------------------"
        echo "Building for Linux..."
        ./build_linux.sh
        
        # Build for Windows  
        echo "---------------------------------------"
        echo "Building for Windows..."
        ./build_windows.sh
        
        # Build for Android
        echo "---------------------------------------"
        echo "Building for Android..."
        ./build_android.sh
        
        echo "======================================="
        echo "All builds completed!"
        echo "Check the builds/ directory for output files."
        ;;
    *)
        echo "Invalid choice!"
        exit 1
        ;;
esac

echo "Build process completed!"