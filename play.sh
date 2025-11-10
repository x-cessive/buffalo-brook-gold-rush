#!/bin/bash
# Buffalo Brook Gold Rush - Quick Play Script
# Double-click this file to play the game!

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Check for Godot
if ! command -v godot &> /dev/null; then
    zenity --error --text="Godot Engine not found!\n\nPlease install Godot 4.0+:\nsudo pacman -S godot" --title="Buffalo Brook Gold Rush" 2>/dev/null || \
    echo "Error: Godot Engine not found! Install with: sudo pacman -S godot"
    exit 1
fi

# Launch the game (uses main scene from project.godot)
godot --path "$SCRIPT_DIR"
