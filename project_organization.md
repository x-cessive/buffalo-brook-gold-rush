# Buffalo Brook Gold Rush - Project Organization

## Project Structure Overview

This document outlines the complete folder structure, scene hierarchy, and modular GDScript architecture for the 2D gold panning game.

## Folder Structure

```
Buffalo Brook Gold Rush/
├── assets/
│   ├── sprites/
│   │   ├── characters/
│   │   │   └── player/
│   │   ├── environment/
│   │   │   ├── streams/
│   │   │   ├── trees/
│   │   │   ├── rocks/
│   │   │   └── wildlife/
│   │   ├── ui/
│   │   │   ├── icons/
│   │   │   ├── buttons/
│   │   │   └── backgrounds/
│   │   ├── tools/
│   │   │   ├── pans/
│   │   │   └── accessories/
│   │   └── items/
│   │       ├── gold/
│   │       ├── gems/
│   │       └── artifacts/
│   ├── animations/
│   │   ├── characters/
│   │   ├── environment/
│   │   └── effects/
│   ├── audio/
│   │   ├── sfx/
│   │   │   ├── panning/
│   │   │   ├── environment/
│   │   │   └── ui/
│   │   └── music/
│   └── fonts/
├── scenes/
│   ├── main/
│   │   ├── main.tscn
│   │   ├── game.tscn
│   │   └── menu.tscn
│   ├── player/
│   │   ├── player.tscn
│   │   └── player.gd
│   ├── environment/
│   │   ├── world.tscn
│   │   ├── stream.tscn
│   │   ├── location.tscn
│   │   └── seasonal_manager.tscn
│   ├── panning/
│   │   ├── panning_minigame.tscn
│   │   ├── pan.tscn
│   │   └── particle_separator.tscn
│   ├── ui/
│   │   ├── hud.tscn
│   │   ├── inventory.tscn
│   │   ├── shop.tscn
│   │   ├── calendar.tscn
│   │   └── settings.tscn
│   └── game_systems/
│       ├── economy.tscn
│       ├── weather_system.tscn
│       ├── achievement_manager.tscn
│       └── save_manager.tscn
├── scripts/
│   ├── core/
│   │   ├── game_manager.gd
│   │   ├── scene_manager.gd
│   │   └── event_bus.gd
│   ├── player/
│   │   ├── player_controller.gd
│   │   ├── inventory.gd
│   │   └── skill_tree.gd
│   ├── panning/
│   │   ├── panning_controller.gd
│   │   ├── pan_physics.gd
│   │   ├── particle_system.gd
│   │   └── gold_detector.gd
│   ├── environment/
│   │   ├── location_manager.gd
│   │   ├── seasonal_manager.gd
│   │   ├── weather_controller.gd
│   │   └── ecosystem.gd
│   ├── economy/
│   │   ├── market_manager.gd
│   │   ├── currency.gd
│   │   └── shop_system.gd
│   ├── ui/
│   │   ├── hud_manager.gd
│   │   ├── inventory_ui.gd
│   │   ├── shop_ui.gd
│   │   └── calendar_ui.gd
│   └── data/
│       ├── save_data.gd
│       ├── item_database.gd
│       ├── location_database.gd
│       └── achievement_database.gd
├── resources/
│   ├── data/
│   │   ├── items.tres
│   │   ├── locations.tres
│   │   ├── tools.tres
│   │   └── achievements.tres
│   └── settings/
│       └── game_config.tres
├── autoload/
│   ├── globals.gd
│   ├── audio_manager.gd
│   └── save_manager.gd
└── export/
    └── templates/
```

## Scene Hierarchy

### Main.tscn (Root Scene)
```
Main
├── World (Node2D)
│   ├── Background (Sprite2D)
│   ├── Locations (Node2D)
│   │   ├── Location1 (Location.tscn)
│   │   ├── Location2 (Location.tscn)
│   │   └── Location3 (Location.tscn)
│   ├── Player (Player.tscn)
│   ├── WeatherSystem (WeatherSystem.tscn)
│   └── SeasonalManager (SeasonalManager.tscn)
├── UI (CanvasLayer)
│   ├── HUD (HUD.tscn)
│   ├── InventoryUI (Inventory.tscn)
│   └── CalendarUI (Calendar.tscn)
├── GameSystems (Node)
│   ├── Economy (Economy.tscn)
│   ├── AchievementManager (AchievementManager.tscn)
│   └── SaveManager (SaveManager.tscn)
└── AudioManager (AudioStreamPlayer)
```

### Player.tscn
```
Player
├── CollisionShape2D
├── Sprite2D
├── AnimationPlayer
├── PanningArm (Node2D)
│   └── Pan (Pan.tscn)
├── Inventory (Inventory.gd - autoload)
└── PlayerController (PlayerController.gd)
```

### Pan.tscn (Panning Minigame)
```
Pan
├── CollisionShape2D
├── Sprite2D
├── Particles2D (for sediment)
├── PanningController (PanningController.gd)
├── PanPhysics (PanPhysics.gd)
├── ParticleSystem (ParticleSystem.gd)
└── GoldDetector (GoldDetector.gd)
```

### Location.tscn (Environment)
```
Location
├── TileMap (for terrain)
├── Stream (Stream.tscn)
│   ├── AnimatedSprite2D (for water flow)
│   ├── Particles2D (for water effects)
│   └── CollisionShape2D (for interaction)
├── Trees (Node2D)
├── Rocks (Node2D)
├── Wildlife (Node2D)
├── LocationManager (LocationManager.gd)
└── PanningSpot (Area2D)
    └── PanningInteraction (Signal for starting minigame)
```

### Inventory.tscn
```
Inventory
├── VBoxContainer
│   ├── ItemList
│   │   ├── GoldFlakeSlot (ItemSlot.tscn)
│   │   ├── NuggetSlot (ItemSlot.tscn)
│   │   ├── GemSlot (ItemSlot.tscn)
│   │   └── ArtifactSlot (ItemSlot.tscn)
│   ├── InfoPanel
│   └── CloseButton
└── InventoryUI (InventoryUI.gd)
```

### Shop.tscn
```
Shop
├── VBoxContainer
│   ├── ShopTitle
│   ├── ToolList
│   │   ├── PanUpgrade1 (ShopItem.tscn)
│   │   ├── PanUpgrade2 (ShopItem.tscn)
│   │   └── Accessories (ShopItem.tscn)
│   ├── CurrentGoldDisplay
│   ├── PurchaseButton
│   └── ExitButton
└── ShopUI (ShopUI.gd)
```

### HUD.tscn
```
HUD
├── VBoxContainer
│   ├── TopBar
│   │   ├── GoldCounter
│   │   ├── LocationName
│   │   ├── WeatherIcon
│   │   └── SeasonIcon
│   ├── MiddleSection
│   │   ├── StaminaBar
│   │   └── ToolCondition
│   └── BottomBar
│       ├── InventoryButton
│       ├── CalendarButton
│       └── SettingsButton
└── HUDManager (HUDManager.gd)
```

## Modular GDScript Architecture

### Core System Scripts
- **GameManager.gd**: Manages the overall game state, transitions between scenes, and global game flow
- **SceneManager.gd**: Handles scene loading, unloading, and transitions
- **EventBus.gd**: Central event system for communication between different systems

### Player System Scripts
- **PlayerController.gd**: Handles player input, movement, and state management
- **Inventory.gd**: Manages collected items, gold, and inventory operations (autoloaded)
- **SkillTree.gd**: Tracks and manages player progression and skill unlocks

### Panning System Scripts
- **PanningController.gd**: Main controller for the panning minigame logic
- **PanPhysics.gd**: Handles the physics of the panning process (particle separation, water flow)
- **ParticleSystem.gd**: Manages sediment and material particles during panning
- **GoldDetector.gd**: Detects when gold particles are successfully separated

### Environment System Scripts
- **LocationManager.gd**: Handles different panning locations and their properties
- **SeasonalManager.gd**: Manages seasonal changes and their effects on gameplay
- **WeatherController.gd**: Controls weather patterns and their impact on panning
- **Ecosystem.gd**: Manages environmental elements and wildlife behavior

### Economy System Scripts
- **MarketManager.gd**: Handles gold prices, market fluctuations, and trading
- **Currency.gd**: Manages player's gold and financial transactions
- **ShopSystem.gd**: Controls shop inventory, pricing, and purchase logic

### UI System Scripts
- **HUDManager.gd**: Controls the heads-up display information
- **InventoryUI.gd**: Manages the inventory interface and interactions
- **ShopUI.gd**: Controls the shop interface display and functionality
- **CalendarUI.gd**: Manages the seasonal calendar and date information

### Data Management Scripts
- **SaveData.gd**: Handles saving and loading game progress
- **ItemDatabase.gd**: Contains information about all collectible items
- **LocationDatabase.gd**: Contains properties and settings for all locations
- **AchievementDatabase.gd**: Defines all available achievements

### Autoload Scripts
- **Globals.gd**: Global constants, settings, and utility functions
- **AudioManager.gd**: Manages all game audio (music, SFX, volume control)
- **SaveManager.gd**: Handles saving game state to disk (autoloaded)

## Key Design Principles

1. **Modularity**: Each system is self-contained and can be developed/tested independently
2. **Separation of Concerns**: UI, logic, and data are kept separate
3. **Autoload Usage**: Critical systems like Inventory, AudioManager, and SaveManager are autoloaded
4. **Event-Driven Architecture**: Systems communicate through signals/events to maintain loose coupling
5. **Data-Driven Design**: Game parameters are stored in Tres files rather than hardcoded
6. **Scalability**: The architecture allows adding new locations, tools, and features without major refactoring

## Development Workflow

1. Start with core systems (GameManager, SceneManager)
2. Implement player controller and basic movement
3. Build the panning minigame mechanics
4. Add environment and locations
5. Implement economy and shop systems
6. Create UI systems
7. Add advanced features (seasons, weather, achievements)
8. Optimize and polish

This architecture provides a solid foundation for developing the gold panning simulation game with room for expansion and modifications.