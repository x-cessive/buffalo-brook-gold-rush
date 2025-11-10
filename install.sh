#!/bin/bash
# Buffalo Brook Gold Rush - Linux Installation Script
# Installs the game to ~/.local/share/buffalo-brook-gold-rush

set -e

echo "=========================================="
echo "Buffalo Brook Gold Rush - Installer"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Installation directory
INSTALL_DIR="$HOME/.local/share/buffalo-brook-gold-rush"
BIN_DIR="$HOME/.local/bin"
DESKTOP_DIR="$HOME/.local/share/applications"

# Create directories if they don't exist
mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"
mkdir -p "$DESKTOP_DIR"

echo -e "${YELLOW}Checking for required dependencies...${NC}"

# Check if Godot is installed
if ! command -v godot &> /dev/null; then
    echo -e "${RED}Error: Godot Engine not found!${NC}"
    echo ""
    echo "To play this game, you need Godot 4.0+ installed."
    echo ""
    echo "Install options for Manjaro/Arch:"
    echo "  1. From AUR: yay -S godot"
    echo "  2. From official repos: sudo pacman -S godot"
    echo "  3. Download from: https://godotengine.org/download"
    echo ""
    read -p "Would you like to continue installation anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 1
    fi
else
    GODOT_VERSION=$(godot --version 2>/dev/null || echo "unknown")
    echo -e "${GREEN}✓ Godot found: $GODOT_VERSION${NC}"
fi

echo ""
echo -e "${YELLOW}Installing Buffalo Brook Gold Rush...${NC}"

# Copy game files to installation directory
echo "Copying game files to $INSTALL_DIR..."
cp -r . "$INSTALL_DIR/"

# Make sure the icon exists (create a placeholder if not)
if [ ! -f "$INSTALL_DIR/icon.png" ]; then
    echo "Creating placeholder icon..."
    # Create a simple placeholder - in reality the game should have an icon
    touch "$INSTALL_DIR/icon.png"
fi

# Create launcher script
echo "Creating launcher script..."
cat > "$BIN_DIR/buffalo-brook-gold-rush" << 'EOF'
#!/bin/bash
# Buffalo Brook Gold Rush Launcher

GAME_DIR="$HOME/.local/share/buffalo-brook-gold-rush"

if [ ! -d "$GAME_DIR" ]; then
    echo "Error: Game not found at $GAME_DIR"
    echo "Please run install.sh first."
    exit 1
fi

# Check if Godot is available
if ! command -v godot &> /dev/null; then
    echo "Error: Godot Engine not found!"
    echo "Please install Godot 4.0+ to play this game."
    echo ""
    echo "Install with: sudo pacman -S godot"
    echo "Or download from: https://godotengine.org/download"
    exit 1
fi

# Launch the game
cd "$GAME_DIR"
godot --path . res://scenes/menu.tscn
EOF

chmod +x "$BIN_DIR/buffalo-brook-gold-rush"

# Create desktop entry
echo "Creating desktop launcher..."
cat > "$DESKTOP_DIR/buffalo-brook-gold-rush.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Buffalo Brook Gold Rush
Comment=A gold panning simulation game
Exec=$BIN_DIR/buffalo-brook-gold-rush
Icon=$INSTALL_DIR/icon.png
Terminal=false
Categories=Game;Simulation;
Keywords=game;gold;panning;simulation;
EOF

chmod +x "$DESKTOP_DIR/buffalo-brook-gold-rush.desktop"

# Update desktop database
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$DESKTOP_DIR" 2>/dev/null || true
fi

echo ""
echo -e "${GREEN}=========================================="
echo "Installation Complete!"
echo "==========================================${NC}"
echo ""
echo "You can now launch the game in three ways:"
echo ""
echo -e "  1. ${YELLOW}From terminal:${NC} buffalo-brook-gold-rush"
echo -e "  2. ${YELLOW}From app menu:${NC} Search for 'Buffalo Brook Gold Rush'"
echo -e "  3. ${YELLOW}Manually:${NC} cd ~/.local/share/buffalo-brook-gold-rush && godot --path . res://scenes/menu.tscn"
echo ""
echo "To uninstall, run: ./uninstall.sh"
echo ""
echo -e "${YELLOW}Note:${NC} Make sure ~/.local/bin is in your PATH"
echo "      (Most distros add this automatically)"
echo ""
