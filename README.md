# Buffalo Brook Gold Rush

<div align="center">

**A realistic gold panning simulation game built with Godot 4**

[Features](#features) • [Getting Started](#getting-started) • [Controls](#controls) • [Wiki](../../wiki) • [Demo](#demo)

[![Godot Engine](https://img.shields.io/badge/Godot-4.0+-blue.svg)](https://godotengine.org/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20Android-lightgrey.svg)]()

</div>

---

## Overview

Buffalo Brook Gold Rush is an immersive gold panning simulation game that brings the excitement of the California Gold Rush era to life. Experience realistic sediment separation mechanics, manage your tools and resources, and navigate a dynamic economy as you search for fortune in the streams and rivers of the American frontier.

## Features

### Core Gameplay
- **Realistic Gold Panning Mechanics** - Physics-based sediment separation with authentic panning techniques
- **Interactive Minigame System** - Engaging panning minigame with tilt, shake, and water management mechanics
- **Dynamic Detection Algorithm** - Gold detection based on separation effectiveness and location richness

### Tools & Equipment
- **Multiple Tool Types** - Unlock and upgrade various panning tools (Basic Pan, Gold Pan, Professional Pan, Sluice Box)
- **Durability System** - Tools wear down with use and require maintenance
- **Tool Specialization** - Each tool has unique effectiveness ratings and modifiers
- **Upgrade Paths** - Enhance your equipment to increase gold yield

### Economy & Progression
- **Dynamic Market System** - Gold prices fluctuate based on market conditions
- **Inventory Management** - Track your gold, tools, and resources
- **Shop System** - Buy new tools, upgrades, and supplies
- **Economic Simulation** - Realistic price variations affect your profits

### Environment & Locations
- **Multiple Mining Locations** - Explore different streams and rivers with varying richness levels
- **Time & Weather System** - Dynamic time of day and weather conditions affect gameplay
- **Environmental Effects** - Weather impacts sediment amount and panning difficulty
- **Travel System** - Move between different mining locations

### Technical Features
- **Performance Monitoring** - Built-in FPS tracking and error detection
- **Save System** - Persistent game state across sessions
- **Audio Management** - Dynamic sound effects and atmospheric music
- **Cross-Platform Support** - Runs on Windows, Linux, and Android

## Getting Started

### Prerequisites

- **Godot Engine 4.0+** - [Download here](https://godotengine.org/download)
- **Git** (optional) - For cloning the repository

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/x-cessive/Buffalo-Brook-Gold-Rush.git
   cd Buffalo-Brook-Gold-Rush
   ```

2. **Open in Godot**
   - Launch Godot Engine
   - Click "Import"
   - Navigate to the project folder
   - Select `project.godot`
   - Click "Import & Edit"

3. **Run the game**
   - Press `F5` or click the Play button in the Godot editor
   - Or use the "Run Project" option from the Project menu

### Quick Start for Players

If you just want to play the game without the editor:

1. Download the latest release from the [Releases](../../releases) page
2. Extract the archive
3. Run the executable for your platform:
   - **Windows**: `BuffaloBrookGoldRush.exe`
   - **Linux**: `BuffaloBrookGoldRush.x86_64`
   - **Android**: Install the `.apk` file

## Controls

| Action | Key/Button | Description |
|--------|-----------|-------------|
| **Move** | WASD / Arrow Keys | Navigate the game world |
| **Interact** | E | Start panning for gold when near water |
| **Pan Left** | J | Tilt pan to the left during minigame |
| **Pan Right** | K | Tilt pan to the right during minigame |
| **Shake Pan** | Spacebar | Shake the pan to separate sediment |
| **Panning Controls** | Q/E | Additional panning movements |
| **Pause** | ESC | Pause the game / Open pause menu |
| **Debug Gold** | F1 | Debug feature (development only) |

## Project Structure

```
Buffalo-Brook-Gold-Rush/
├── scenes/              # Game scenes and scene scripts
│   ├── menu.tscn       # Main menu scene
│   ├── main.tscn       # Main game container
│   ├── main_game.tscn  # Core gameplay scene
│   └── effects/        # Visual effect scenes
├── scripts/            # GDScript source files
│   ├── player/         # Player controller and inventory
│   ├── panning/        # Gold panning mechanics
│   ├── ui/             # User interface scripts
│   ├── economy/        # Economic system
│   ├── environment/    # Time, weather, and travel
│   └── tools/          # Tool definitions and logic
├── autoload/           # Singleton/autoload scripts
│   ├── audio_manager.gd
│   ├── economy.gd
│   ├── save_manager.gd
│   ├── time.gd
│   └── weather.gd
├── resources/          # Game resources and data
│   └── data/           # Game data files
├── audio/              # Sound effects and music
├── shaders/            # Custom shaders
├── docs/               # Documentation and wiki
├── project.godot       # Godot project file
├── export_presets.cfg  # Export configurations
└── README.md          # This file
```

## Development

### Building from Source

1. Make sure you have Godot 4.0+ installed
2. Clone the repository
3. Open the project in Godot
4. Make your changes
5. Test thoroughly using F5 to run

### Exporting the Game

The project includes export presets for multiple platforms:

```bash
# Export for Windows
godot --export "Windows Desktop" builds/windows/BuffaloBrookGoldRush.exe

# Export for Linux
godot --export "Linux/X11" builds/linux/BuffaloBrookGoldRush.x86_64

# Export for Android
godot --export "Android" builds/android/BuffaloBrookGoldRush.apk
```

Or use the provided build scripts:
- `build_windows.sh` - Build for Windows
- `build_linux.sh` - Build for Linux
- `build_android.sh` - Build for Android
- `build_master.sh` - Build for all platforms

### Code Style

This project follows standard GDScript conventions:
- Use tabs for indentation
- Snake_case for functions and variables
- PascalCase for class names
- Document functions with `##` comments
- Keep lines under 100 characters when possible

## Documentation

For detailed documentation, visit our [Wiki](../../wiki):

- [Game Mechanics](../../wiki/Game-Mechanics)
- [Tool System](../../wiki/Tool-System)
- [Economy Guide](../../wiki/Economy-Guide)
- [Development Guide](../../wiki/Development-Guide)
- [API Reference](../../wiki/API-Reference)

## Demo

See [DEMO.md](DEMO.md) for a walkthrough of the game's features and how to experience the full gameplay loop.

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details on:
- How to submit issues
- How to propose features
- Code contribution guidelines
- Pull request process

## Design Documents

For deeper insight into the game design:
- [Gameplay Design](gameplay_design.md) - Core mechanics and game loop
- [Art Design Guide](art_design_guide.md) - Visual style and asset guidelines
- [Feature Priority](features_by_priority.md) - Development roadmap
- [Project Organization](project_organization.md) - Code architecture

## Optimization

The game includes optimization configurations for various hardware:
- `optimizations_quadro_2000m.cfg` - Settings for older GPUs
- `godot_project_settings_old_gpu.txt` - Legacy GPU configurations

## Performance Monitoring

Built-in performance tools:
- FPS logging and display
- Memory usage tracking
- Error detection and reporting
- `launch_game_monitor.sh` - Development monitoring script

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Credits

**Development Team**
- Game Design & Programming
- Art & Animation
- Sound Design & Music

**Built With**
- [Godot Engine](https://godotengine.org/) - Open source game engine
- GDScript - Programming language

**Special Thanks**
- The Godot community for excellent documentation and support
- Alpha testers and contributors

## Support

- **Issues**: Report bugs via [GitHub Issues](../../issues)
- **Discussions**: Join our [Discussions](../../discussions) for questions and ideas
- **Wiki**: Check the [Wiki](../../wiki) for comprehensive guides

---

<div align="center">

**Made with ❤️ using Godot Engine**

[⬆ Back to Top](#buffalo-brook-gold-rush)

</div>
