# Buffalo Brook Gold Rush - Quick Start Guide

## 🎮 Fastest Way to Play

### Method 1: Double-Click to Play (Easiest!)

Just **double-click `play.sh`** in your file manager!

That's it - the game will launch immediately.

---

### Method 2: Build Standalone Executable

Want a proper executable you can distribute? Run:

```bash
./build_standalone.sh
```

This creates:
- `BuffaloBrookGoldRush-Linux/` - Standalone game folder
- `releases/BuffaloBrookGoldRush-Linux-v1.0.tar.gz` - Distribution package

Then double-click `play.sh` inside the `BuffaloBrookGoldRush-Linux` folder!

---

### Method 3: Install to System

For integration with your app menu:

```bash
./install.sh
```

Then launch from terminal:
```bash
buffalo-brook-gold-rush
```

Or find "Buffalo Brook Gold Rush" in your application menu!

---

## ⚙️ Requirements

- **Godot 4.0+** - Install with: `sudo pacman -S godot`
- **OpenGL 3.3+** compatible GPU
- **Linux** (tested on Manjaro/Arch)

---

## 🎯 Controls

| Key | Action |
|-----|--------|
| **WASD / Arrows** | Move |
| **E** | Interact / Pan for gold |
| **J** | Tilt pan left |
| **K** | Tilt pan right |
| **Space** | Shake pan |
| **ESC** | Pause |

---

## 🐛 Troubleshooting

### "Godot not found"
```bash
sudo pacman -S godot
```

### "Permission denied" when running play.sh
```bash
chmod +x play.sh
./play.sh
```

### Vulkan errors (older GPUs)
The game is already configured to use OpenGL for compatibility. The warnings are normal and can be ignored.

### Parse errors
Make sure you're on the correct branch:
```bash
git checkout claude/game-will-fix-011CUyexuokcTJKMP3gARsV9
git pull
```

---

## 📦 Distribution

To share the game with others:

1. Run `./build_standalone.sh`
2. Share `releases/BuffaloBrookGoldRush-Linux-v1.0.tar.gz`
3. Recipients extract and run `./play.sh`

No installation needed - it just works!

---

## 🎮 Enjoy Playing!

Start panning for gold and build your fortune!

For more details, see [INSTALL.md](INSTALL.md) or [README.md](README.md)
