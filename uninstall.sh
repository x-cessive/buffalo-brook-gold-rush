#!/bin/bash
# Buffalo Brook Gold Rush - Uninstallation Script

set -e

echo "=========================================="
echo "Buffalo Brook Gold Rush - Uninstaller"
echo "=========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Installation locations
INSTALL_DIR="$HOME/.local/share/buffalo-brook-gold-rush"
BIN_FILE="$HOME/.local/bin/buffalo-brook-gold-rush"
DESKTOP_FILE="$HOME/.local/share/applications/buffalo-brook-gold-rush.desktop"

echo -e "${YELLOW}This will remove Buffalo Brook Gold Rush from your system.${NC}"
echo ""
echo "The following will be deleted:"
echo "  - $INSTALL_DIR"
echo "  - $BIN_FILE"
echo "  - $DESKTOP_FILE"
echo ""

read -p "Are you sure you want to uninstall? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Uninstallation cancelled."
    exit 0
fi

echo ""
echo "Uninstalling..."

# Remove installation directory
if [ -d "$INSTALL_DIR" ]; then
    echo "Removing game files..."
    rm -rf "$INSTALL_DIR"
    echo -e "${GREEN}✓ Game files removed${NC}"
else
    echo -e "${YELLOW}! Game files not found${NC}"
fi

# Remove launcher script
if [ -f "$BIN_FILE" ]; then
    echo "Removing launcher..."
    rm -f "$BIN_FILE"
    echo -e "${GREEN}✓ Launcher removed${NC}"
else
    echo -e "${YELLOW}! Launcher not found${NC}"
fi

# Remove desktop entry
if [ -f "$DESKTOP_FILE" ]; then
    echo "Removing desktop entry..."
    rm -f "$DESKTOP_FILE"
    echo -e "${GREEN}✓ Desktop entry removed${NC}"

    # Update desktop database
    if command -v update-desktop-database &> /dev/null; then
        update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
    fi
else
    echo -e "${YELLOW}! Desktop entry not found${NC}"
fi

echo ""
echo -e "${GREEN}=========================================="
echo "Uninstallation Complete!"
echo "==========================================${NC}"
echo ""
echo "Buffalo Brook Gold Rush has been removed from your system."
echo ""
