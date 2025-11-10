# Installation Guide - Buffalo Brook Gold Rush

Quick installation guide for Linux users (Manjaro/Arch).

## Quick Install (Recommended)

### Prerequisites

You need Godot 4.0+ installed:

```bash
# Manjaro/Arch Linux
sudo pacman -S godot

# Or from AUR
yay -S godot
```

### Install the Game

```bash
# Clone the repository
git clone https://github.com/x-cessive/Buffalo-Brook-Gold-Rush.git
cd Buffalo-Brook-Gold-Rush

# Checkout the working branch
git checkout claude/game-will-fix-011CUyexuokcTJKMP3gARsV9

# Run the installer
./install.sh
```

That's it! The game is now installed.

## Launch the Game

After installation, you can launch the game in three ways:

### 1. From Terminal (Easiest)
```bash
buffalo-brook-gold-rush
```

### 2. From Application Menu
- Open your application menu
- Search for "Buffalo Brook Gold Rush"
- Click the icon

### 3. Manually
```bash
cd ~/.local/share/buffalo-brook-gold-rush
godot --path . res://scenes/menu.tscn
```

## Uninstall

To remove the game:

```bash
cd Buffalo-Brook-Gold-Rush
./uninstall.sh
```

Or manually:
```bash
rm -rf ~/.local/share/buffalo-brook-gold-rush
rm ~/.local/bin/buffalo-brook-gold-rush
rm ~/.local/share/applications/buffalo-brook-gold-rush.desktop
```

## Troubleshooting

### "godot: command not found"

Install Godot:
```bash
sudo pacman -S godot
```

### "buffalo-brook-gold-rush: command not found"

Make sure `~/.local/bin` is in your PATH. Add this to `~/.bashrc` or `~/.zshrc`:
```bash
export PATH="$HOME/.local/bin:$PATH"
```

Then reload:
```bash
source ~/.bashrc  # or source ~/.zshrc
```

### Vulkan Errors (Intel HD Graphics 3000 and older GPUs)

The game is already configured to use OpenGL for compatibility with older GPUs. If you still see Vulkan errors, the latest branch has the fix.

### Parse Errors in Scripts

Make sure you're on the correct branch:
```bash
git checkout claude/game-will-fix-011CUyexuokcTJKMP3gARsV9
git pull origin claude/game-will-fix-011CUyexuokcTJKMP3gARsV9
```

## File Locations

After installation:
- **Game files**: `~/.local/share/buffalo-brook-gold-rush/`
- **Launcher**: `~/.local/bin/buffalo-brook-gold-rush`
- **Desktop entry**: `~/.local/share/applications/buffalo-brook-gold-rush.desktop`

## Development Mode

If you want to modify the game or run it directly without installing:

```bash
cd Buffalo-Brook-Gold-Rush
godot --path . res://scenes/menu.tscn
```

Or open in Godot editor:
```bash
godot --path .
```

Then press F5 to run.

## System Requirements

### Minimum
- **OS**: Linux (tested on Manjaro/Arch)
- **GPU**: OpenGL 3.3 compatible (Intel HD Graphics 3000 or better)
- **RAM**: 512 MB
- **Disk**: 100 MB

### Recommended
- **OS**: Any modern Linux distribution
- **GPU**: OpenGL 3.3+ or Vulkan 1.0+
- **RAM**: 1 GB
- **Disk**: 200 MB

## Getting Help

- **Issues**: Report bugs on [GitHub Issues](https://github.com/x-cessive/Buffalo-Brook-Gold-Rush/issues)
- **Documentation**: Check the [Wiki](https://github.com/x-cessive/Buffalo-Brook-Gold-Rush/wiki)
- **Demo**: See [DEMO.md](DEMO.md) for gameplay guide

---

Enjoy the game! ⛏️✨
