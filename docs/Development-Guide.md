# Development Guide

Comprehensive guide for developers contributing to Buffalo Brook Gold Rush. Covers setup, architecture, workflows, and best practices.

## Table of Contents

- [Getting Started](#getting-started)
- [Project Architecture](#project-architecture)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Building and Deployment](#building-and-deployment)

---

## Getting Started

### Development Environment Setup

**Required Software:**
```bash
# Godot Engine 4.0+
Download from: https://godotengine.org/download

# Git
Windows: https://git-scm.com/download/win
Linux: sudo apt-get install git
MacOS: brew install git

# Text Editor (Optional but recommended)
- VSCode with Godot Tools extension
- Sublime Text
- Atom
```

**Installation:**
```bash
# 1. Fork the repository on GitHub
# 2. Clone your fork
git clone https://github.com/YOUR-USERNAME/Buffalo-Brook-Gold-Rush.git
cd Buffalo-Brook-Gold-Rush

# 3. Add upstream remote
git remote add upstream https://github.com/x-cessive/Buffalo-Brook-Gold-Rush.git

# 4. Verify remotes
git remote -v
```

**First Run:**
```bash
# Open in Godot
1. Launch Godot
2. Click "Import"
3. Select project.godot
4. Click "Import & Edit"

# Test the game
Press F5 or click Play button
```

---

## Project Architecture

### Directory Structure

```
Buffalo-Brook-Gold-Rush/
├── .git/                   # Git version control
├── .gitignore             # Git ignore rules
├── autoload/              # Singleton scripts
│   ├── audio_manager.gd   # Audio system
│   ├── economy.gd         # Economic simulation
│   ├── save_manager.gd    # Save/load system
│   ├── time.gd            # Time management
│   └── weather.gd         # Weather system
├── scenes/                # Game scenes
│   ├── effects/           # Visual effects
│   ├── main.tscn          # Main game container
│   ├── main.gd            # Main scene script
│   ├── main_game.tscn     # Core gameplay scene
│   ├── main_game.gd       # Core gameplay logic
│   ├── menu.tscn          # Main menu
│   └── menu.gd            # Menu logic
├── scripts/               # Game logic scripts
│   ├── economy/           # Economic systems
│   ├── environment/       # Time, weather, location
│   ├── panning/           # Panning mechanics
│   ├── player/            # Player systems
│   ├── tools/             # Tool definitions
│   └── ui/                # UI components
├── resources/             # Game resources
│   └── data/              # Data files
├── audio/                 # Sound and music
│   ├── music/            # Background music
│   └── sfx/              # Sound effects
├── shaders/              # Custom shaders
├── docs/                 # Documentation (wiki)
├── project.godot         # Godot project file
├── export_presets.cfg    # Export configurations
├── README.md             # Project README
├── DEMO.md               # Demo guide
├── CONTRIBUTING.md       # Contribution guidelines
└── design docs/          # Design documentation
```

### System Architecture

**Core Systems:**

```
┌─────────────────────────────────────┐
│         Autoload Singletons         │
│  (Audio, Economy, Save, Time, etc.) │
└─────────────┬───────────────────────┘
              │
┌─────────────┴───────────────────────┐
│          Main Game Scene            │
│     (Orchestrates everything)       │
└─────────────┬───────────────────────┘
              │
     ┌────────┴────────┐
     │                 │
┌────┴─────┐    ┌─────┴──────┐
│   UI     │    │  Gameplay  │
│ System   │    │  Systems   │
└──────────┘    └─────┬──────┘
                      │
         ┌────────────┼────────────┐
         │            │            │
    ┌────┴───┐  ┌────┴───┐  ┌────┴────┐
    │ Player │  │Panning │  │  Tools  │
    │ System │  │ System │  │ System  │
    └────────┘  └────────┘  └─────────┘
```

### Key Components

**Autoload Singletons:**
- Global systems accessible from anywhere
- Handle cross-cutting concerns
- Initialize on game start
- Persist throughout game session

**Scene Hierarchy:**
```
Main (Node2D)
├── GameUI (CanvasLayer)
│   ├── HUD (Control)
│   └── PauseMenu (Panel)
└── MainGame (Node2D)
    ├── Player (CharacterBody2D)
    ├── Environment (Node2D)
    └── Panning Area (Area2D)
```

---

## Development Workflow

### Feature Development

**1. Create Feature Branch:**
```bash
git checkout main
git pull upstream main
git checkout -b feature/your-feature-name
```

**2. Implement Feature:**
- Write code
- Test functionality
- Add documentation
- Update related files

**3. Commit Changes:**
```bash
git add .
git commit -m "feat: add feature description"
```

**4. Push and Create PR:**
```bash
git push origin feature/your-feature-name
# Create Pull Request on GitHub
```

### Bug Fixing

**1. Create Bugfix Branch:**
```bash
git checkout -b bugfix/issue-description
```

**2. Fix Bug:**
- Identify root cause
- Implement fix
- Test thoroughly
- Verify no regressions

**3. Commit and Push:**
```bash
git commit -m "fix: resolve issue description"
git push origin bugfix/issue-description
```

### Updating Documentation

**1. Create Docs Branch:**
```bash
git checkout -b docs/update-description
```

**2. Update Documentation:**
- Edit markdown files
- Update code comments
- Add missing documentation

**3. Commit and Push:**
```bash
git commit -m "docs: update documentation"
git push origin docs/update-description
```

---

## Coding Standards

### GDScript Style Guide

**File Structure:**
```gdscript
# 1. Class name and extends
class_name ClassName
extends BaseClass

# 2. Documentation
## Brief description of class/script
## Additional details

# 3. Signals
signal event_occurred(data: Variant)

# 4. Enums
enum State { IDLE, ACTIVE, DISABLED }

# 5. Constants
const MAX_VALUE: int = 100

# 6. Exported variables
@export var value: float = 1.0

# 7. Public variables
var public_var: int = 0

# 8. Private variables
var _private_var: bool = false

# 9. Onready variables
@onready var node: Node = $NodePath

# 10. Virtual methods (_ready, _process, etc.)
func _ready() -> void:
	pass

# 11. Public methods
func public_method() -> void:
	pass

# 12. Private methods
func _private_method() -> void:
	pass
```

**Naming Conventions:**
```gdscript
# snake_case for variables and functions
var player_health: int = 100
func calculate_damage() -> int:

# UPPER_SNAKE_CASE for constants
const MAX_HEALTH: int = 100
const GRAVITY: float = 9.8

# PascalCase for classes and enums
class_name PlayerController
enum ItemType { TOOL, CONSUMABLE }

# _prefix for private/internal
var _internal_state: bool
func _internal_helper() -> void:
```

**Type Hints:**
```gdscript
# Always use type hints
var gold_count: int = 0
var tool_name: String = "Basic Pan"
var is_active: bool = true
var position: Vector2 = Vector2.ZERO

# Function parameters and returns
func add_gold(amount: int) -> void:
	gold_count += amount

func get_tool_effectiveness() -> float:
	return 1.0
```

**Comments:**
```gdscript
## Documentation comments use double ##
## Describe function purpose, params, and return
func documented_function(param: int) -> String:
	# Inline comments explain complex logic
	var result = param * 2
	return str(result)
```

### Best Practices

**Code Organization:**
- One class per file
- Related functions grouped together
- Logical ordering (lifecycle → public → private)
- Clear separation of concerns

**Error Handling:**
```gdscript
func load_data(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		push_error("File not found: " + path)
		return {}

	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open file: " + path)
		return {}

	var data = file.get_var()
	file.close()
	return data
```

**Resource Management:**
```gdscript
func _exit_tree() -> void:
	# Clean up resources
	if timer:
		timer.queue_free()

	# Disconnect signals
	if signal_connected:
		disconnect_signal()
```

---

## Testing

### Manual Testing

**Test Checklist:**
- [ ] Feature works as intended
- [ ] No console errors
- [ ] No performance issues
- [ ] UI responsive
- [ ] No visual glitches
- [ ] Save/load works
- [ ] Cross-scene compatibility

**Testing Procedure:**
1. Start game fresh
2. Test specific feature
3. Test related systems
4. Check for regressions
5. Test edge cases
6. Verify error handling

### Debug Tools

**Godot Debugger:**
- Set breakpoints
- Inspect variables
- Step through code
- View call stack

**Print Debugging:**
```gdscript
print("Debug: variable value = ", variable)
print_debug("Stack trace included")
push_warning("Warning message")
push_error("Error message")
```

**Performance Profiling:**
- Use Godot's built-in profiler
- Monitor FPS
- Check memory usage
- Identify bottlenecks

---

## Building and Deployment

### Export Configuration

**Export Presets:**
Located in `export_presets.cfg`

- Windows Desktop
- Linux/X11
- Android

**Export Settings:**
- Platform-specific options
- Resource inclusion
- Optimization settings
- Icon and metadata

### Building

**Command Line Export:**
```bash
# Windows
godot --export "Windows Desktop" builds/windows/Game.exe

# Linux
godot --export "Linux/X11" builds/linux/Game.x86_64

# Android
godot --export "Android" builds/android/Game.apk
```

**Using Build Scripts:**
```bash
# Individual platforms
./build_windows.sh
./build_linux.sh
./build_android.sh

# All platforms
./build_master.sh
```

### Version Control

**Semantic Versioning:**
```
MAJOR.MINOR.PATCH

Example: 1.2.3
- 1 = Major version
- 2 = Minor version
- 3 = Patch version
```

**When to Increment:**
- MAJOR: Breaking changes
- MINOR: New features
- PATCH: Bug fixes

---

## Advanced Topics

### Signal System

**Defining Signals:**
```gdscript
signal gold_found(amount: int)
signal tool_changed(tool_name: String, effectiveness: float)
```

**Emitting Signals:**
```gdscript
gold_found.emit(5)
tool_changed.emit("Gold Pan", 1.3)
```

**Connecting Signals:**
```gdscript
# In code
gold_system.gold_found.connect(_on_gold_found)

# Function
func _on_gold_found(amount: int) -> void:
	print("Found ", amount, " gold!")
```

### Autoload Systems

**Creating Autoload:**
1. Create singleton script
2. Add to Project → Project Settings → Autoload
3. Set node name
4. Access globally

**Example:**
```gdscript
# economy.gd (autoload as Economy)
extends Node

var gold_price: float = 10.0

func get_price() -> float:
	return gold_price

# Accessible from anywhere:
# Economy.get_price()
```

---

## Resources

### Documentation Links

- [Godot Documentation](https://docs.godotengine.org/)
- [GDScript Style Guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)
- [Project Wiki](../../wiki)

### Community

- [Godot Forums](https://godotengine.org/community)
- [Godot Discord](https://discord.gg/godot)
- [GitHub Discussions](../../discussions)

---

[← Back: Economy Guide](Economy-Guide.md) | [Next: API Reference →](API-Reference.md)
