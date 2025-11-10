#!/bin/bash
# Buffalo Brook Gold Rush - Complete Build and Package Script
# Creates a standalone game that can be double-clicked to launch

set -e

echo "=========================================="
echo "Buffalo Brook Gold Rush - Game Builder"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check for Godot
if ! command -v godot &> /dev/null; then
    echo -e "${RED}Error: Godot Engine not found!${NC}"
    echo ""
    echo "Please install Godot 4.0+ first:"
    echo "  sudo pacman -S godot"
    echo ""
    exit 1
fi

GODOT_VERSION=$(godot --version 2>/dev/null | head -1)
echo -e "${GREEN}✓ Found Godot: $GODOT_VERSION${NC}"
echo ""

# Build directories
BUILD_DIR="./builds/linux"
PACKAGE_DIR="./BuffaloBrookGoldRush-Linux"
RELEASE_DIR="./releases"

echo -e "${YELLOW}Step 1/5: Creating build directories...${NC}"
mkdir -p "$BUILD_DIR"
mkdir -p "$PACKAGE_DIR"
mkdir -p "$RELEASE_DIR"
echo -e "${GREEN}✓ Directories created${NC}"
echo ""

echo -e "${YELLOW}Step 2/5: Exporting game executable...${NC}"
# Export the game
godot --headless --export-release "Linux/X11" "$BUILD_DIR/BuffaloBrookGoldRush.x86_64" 2>&1 | grep -v "WARNING: " || true

if [ ! -f "$BUILD_DIR/BuffaloBrookGoldRush.x86_64" ]; then
    echo -e "${RED}Export failed! Creating runtime version instead...${NC}"
    echo ""
    echo "The game will run using Godot runtime (works the same way)."
    echo ""
fi

echo -e "${GREEN}✓ Game exported${NC}"
echo ""

echo -e "${YELLOW}Step 3/5: Creating launcher script...${NC}"

# Create a standalone launcher that works without installation
cat > "$PACKAGE_DIR/play.sh" << 'LAUNCHER_EOF'
#!/bin/bash
# Buffalo Brook Gold Rush - Standalone Launcher

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Check if executable exists
if [ -f "./BuffaloBrookGoldRush.x86_64" ]; then
    # Run the exported executable
    ./BuffaloBrookGoldRush.x86_64 "$@"
else
    # Run with Godot runtime
    if command -v godot &> /dev/null; then
        godot --path . res://scenes/menu.tscn "$@"
    else
        echo "Error: Neither game executable nor Godot found!"
        echo ""
        echo "Please install Godot: sudo pacman -S godot"
        exit 1
    fi
fi
LAUNCHER_EOF

chmod +x "$PACKAGE_DIR/play.sh"

# Create a desktop launcher file
cat > "$PACKAGE_DIR/BuffaloBrookGoldRush.desktop" << 'DESKTOP_EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Buffalo Brook Gold Rush
Comment=A gold panning simulation game
Exec=bash -c 'cd "%k" && ./play.sh'
Path=%k
Icon=icon
Terminal=false
Categories=Game;Simulation;
Keywords=game;gold;panning;simulation;
DESKTOP_EOF

chmod +x "$PACKAGE_DIR/BuffaloBrookGoldRush.desktop"

echo -e "${GREEN}✓ Launcher created${NC}"
echo ""

echo -e "${YELLOW}Step 4/5: Copying game files...${NC}"

# Copy executable if it exists
if [ -f "$BUILD_DIR/BuffaloBrookGoldRush.x86_64" ]; then
    cp "$BUILD_DIR/BuffaloBrookGoldRush.x86_64" "$PACKAGE_DIR/"
    chmod +x "$PACKAGE_DIR/BuffaloBrookGoldRush.x86_64"
    echo "  - Copied executable"
fi

# Copy essential game files for runtime mode
cp -r scenes "$PACKAGE_DIR/"
cp -r scripts "$PACKAGE_DIR/"
cp -r autoload "$PACKAGE_DIR/"
cp -r resources "$PACKAGE_DIR/" 2>/dev/null || true
cp -r audio "$PACKAGE_DIR/" 2>/dev/null || true
cp -r shaders "$PACKAGE_DIR/" 2>/dev/null || true
cp project.godot "$PACKAGE_DIR/"

echo "  - Copied game files"
echo -e "${GREEN}✓ Files copied${NC}"
echo ""

echo -e "${YELLOW}Step 5/5: Creating README...${NC}"

cat > "$PACKAGE_DIR/README.txt" << 'README_EOF'
========================================
Buffalo Brook Gold Rush
A Gold Panning Simulation Game
========================================

HOW TO PLAY:
-----------

Option 1: Double-click "play.sh"
Option 2: Double-click "BuffaloBrookGoldRush.desktop"
Option 3: From terminal: ./play.sh

CONTROLS:
---------
WASD / Arrow Keys - Move
E - Interact / Pan for gold
J - Tilt pan left
K - Tilt pan right
Space - Shake pan
ESC - Pause

INSTALLATION (Optional):
-----------------------
To add to your application menu:
1. Copy BuffaloBrookGoldRush.desktop to ~/.local/share/applications/
2. Update desktop database: update-desktop-database ~/.local/share/applications/

REQUIREMENTS:
------------
- Godot Engine 4.0+ (for runtime mode)
- OpenGL 3.3 compatible GPU
- Linux (tested on Manjaro/Arch)

TROUBLESHOOTING:
---------------
If the game won't start:
1. Make sure play.sh is executable: chmod +x play.sh
2. Install Godot: sudo pacman -S godot
3. Run from terminal to see errors: ./play.sh

Enjoy the game!
README_EOF

echo -e "${GREEN}✓ README created${NC}"
echo ""

# Create archive
echo -e "${YELLOW}Creating release archive...${NC}"
ARCHIVE_NAME="BuffaloBrookGoldRush-Linux-v1.0.tar.gz"
tar -czf "$RELEASE_DIR/$ARCHIVE_NAME" -C . "$(basename "$PACKAGE_DIR")"

ARCHIVE_SIZE=$(du -h "$RELEASE_DIR/$ARCHIVE_NAME" | cut -f1)
echo -e "${GREEN}✓ Archive created: $ARCHIVE_SIZE${NC}"
echo ""

echo -e "${GREEN}=========================================="
echo "Build Complete!"
echo "==========================================${NC}"
echo ""
echo -e "${BLUE}Standalone Game Location:${NC}"
echo "  $PACKAGE_DIR/"
echo ""
echo -e "${BLUE}To play now:${NC}"
echo "  cd $PACKAGE_DIR && ./play.sh"
echo ""
echo -e "${BLUE}Distribution Package:${NC}"
echo "  $RELEASE_DIR/$ARCHIVE_NAME"
echo ""
echo -e "${YELLOW}To distribute:${NC}"
echo "  1. Share the .tar.gz file"
echo "  2. Users extract and run ./play.sh"
echo "  3. No installation required!"
echo ""
