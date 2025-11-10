# API Reference

Technical documentation for Buffalo Brook Gold Rush systems, scripts, and APIs.

## Table of Contents

- [Autoload Systems](#autoload-systems)
- [Core Scripts](#core-scripts)
- [Player Systems](#player-systems)
- [Panning Systems](#panning-systems)
- [Tool Systems](#tool-systems)
- [UI Systems](#ui-systems)
- [Signal Reference](#signal-reference)

---

## Autoload Systems

Global singleton systems accessible from anywhere in the game.

### AudioManager

**Path:** `autoload/audio_manager.gd`
**Autoload Name:** `AudioManager`

**Purpose:** Manages all game audio including music and sound effects.

**Properties:**
```gdscript
var music_volume: float = 0.8
var sfx_volume: float = 1.0
var master_volume: float = 1.0
```

**Methods:**
```gdscript
func play_music(track_name: String) -> void:
	## Plays background music track
	## @param track_name: Name of music file (without extension)

func stop_music() -> void:
	## Stops currently playing music

func play_sfx(sound_name: String, pitch_variation: float = 0.0) -> void:
	## Plays a sound effect
	## @param sound_name: Name of sound file
	## @param pitch_variation: Random pitch variation (0.0 to 1.0)

func set_music_volume(volume: float) -> void:
	## Sets music volume
	## @param volume: Volume level (0.0 to 1.0)

func set_sfx_volume(volume: float) -> void:
	## Sets sound effects volume
	## @param volume: Volume level (0.0 to 1.0)
```

**Example Usage:**
```gdscript
# Play background music
AudioManager.play_music("main_theme")

# Play sound effect with variation
AudioManager.play_sfx("gold_found", 0.2)

# Adjust volumes
AudioManager.set_music_volume(0.5)
```

---

### Economy

**Path:** `autoload/economy.gd`
**Autoload Name:** `Economy`

**Purpose:** Manages economic simulation and gold pricing.

**Properties:**
```gdscript
var base_gold_price: float = 10.0
var current_gold_price: float = 10.0
var market_trend: String = "stable"
var price_history: Array = []
```

**Methods:**
```gdscript
func get_gold_price() -> float:
	## Returns current gold price per unit
	## @return: Current price in currency

func update_market() -> void:
	## Updates market prices based on time and conditions
	## Called automatically every 30 game minutes

func sell_gold(amount: int) -> int:
	## Sells gold at current market price
	## @param amount: Number of gold pieces to sell
	## @return: Total currency received

func get_market_trend() -> String:
	## Returns current market trend
	## @return: "crash", "bear", "stable", "bull", or "boom"

func calculate_supply_effect(amount: int) -> float:
	## Calculates price impact of selling amount
	## @param amount: Number of gold pieces
	## @return: Price modifier (0.0 to 1.0)
```

**Signals:**
```gdscript
signal price_changed(new_price: float)
signal market_trend_changed(new_trend: String)
```

**Example Usage:**
```gdscript
# Check current price
var price = Economy.get_gold_price()
print("Gold is worth ", price, " currency")

# Sell gold
var earnings = Economy.sell_gold(10)
print("Sold for ", earnings, " currency")

# Monitor price changes
Economy.price_changed.connect(_on_price_changed)
```

---

### SaveManager

**Path:** `autoload/save_manager.gd`
**Autoload Name:** `SaveManager`

**Purpose:** Handles game save/load operations.

**Properties:**
```gdscript
const SAVE_PATH: String = "user://savegame.save"
var current_save_data: Dictionary = {}
```

**Methods:**
```gdscript
func save_game(data: Dictionary) -> bool:
	## Saves game data to file
	## @param data: Dictionary containing game state
	## @return: true if successful, false otherwise

func load_game() -> Dictionary:
	## Loads game data from file
	## @return: Dictionary with game state, empty if none exists

func save_exists() -> bool:
	## Checks if a save file exists
	## @return: true if save file exists

func delete_save() -> void:
	## Deletes the current save file

func get_save_metadata() -> Dictionary:
	## Returns metadata about save (timestamp, version, etc.)
	## @return: Dictionary with save metadata
```

**Save Data Structure:**
```gdscript
{
	"version": "1.0.0",
	"timestamp": 1234567890,
	"player": {
		"gold": 150,
		"position": Vector2(100, 200)
	},
	"inventory": {
		"tools": [...],
		"items": [...]
	},
	"progression": {
		"total_gold_collected": 500,
		"locations_discovered": [...]
	}
}
```

**Example Usage:**
```gdscript
# Save game
var save_data = {
	"player": {"gold": player.gold_count},
	"inventory": inventory.get_save_data()
}
SaveManager.save_game(save_data)

# Load game
if SaveManager.save_exists():
	var data = SaveManager.load_game()
	player.gold_count = data.player.gold
```

---

### Time

**Path:** `autoload/time.gd`
**Autoload Name:** `Time`

**Purpose:** Manages in-game time and day/night cycles.

**Properties:**
```gdscript
var current_hour: int = 8
var current_minute: int = 0
var day_count: int = 1
var time_scale: float = 1.0
```

**Methods:**
```gdscript
func get_time_string() -> String:
	## Returns formatted time string
	## @return: Time in format "HH:MM"

func get_time_of_day() -> String:
	## Returns current time period
	## @return: "morning", "afternoon", "evening", or "night"

func advance_time(minutes: int) -> void:
	## Advances game time by specified minutes
	## @param minutes: Number of game minutes to advance

func set_time_scale(scale: float) -> void:
	## Sets time progression speed
	## @param scale: Speed multiplier (1.0 = normal)
```

**Signals:**
```gdscript
signal hour_changed(new_hour: int)
signal day_changed(new_day: int)
signal time_of_day_changed(period: String)
```

**Example Usage:**
```gdscript
# Get current time
var time = Time.get_time_string()
print("Current time: ", time)

# Check time of day
if Time.get_time_of_day() == "morning":
	print("Good morning!")

# Listen for hour changes
Time.hour_changed.connect(_on_hour_changed)
```

---

### Weather

**Path:** `autoload/weather.gd`
**Autoload Name:** `Weather`

**Purpose:** Manages weather conditions and effects.

**Properties:**
```gdscript
var current_weather: String = "clear"
var weather_duration: int = 60
var weather_intensity: float = 1.0
```

**Methods:**
```gdscript
func get_current_weather() -> String:
	## Returns current weather type
	## @return: "clear", "overcast", "rain", or "storm"

func get_weather_modifier() -> float:
	## Returns gameplay modifier for current weather
	## @return: Multiplier (0.5 to 1.5)

func change_weather(new_weather: String) -> void:
	## Manually changes weather
	## @param new_weather: Weather type to set

func update_weather() -> void:
	## Updates weather based on time and conditions
	## Called automatically
```

**Signals:**
```gdscript
signal weather_changed(new_weather: String)
```

**Example Usage:**
```gdscript
# Check current weather
var weather = Weather.get_current_weather()
if weather == "storm":
	print("Bad weather for panning!")

# Get gameplay modifier
var modifier = Weather.get_weather_modifier()
sediment_amount *= modifier
```

---

## Core Scripts

### MainGame

**Path:** `scenes/main_game.gd`
**Node:** `Main/MainGame`

**Purpose:** Core gameplay scene controller.

**Properties:**
```gdscript
var gold_count: int = 0
var current_tool: String = "Basic Pan"
var is_panning: bool = false
var panning_progress: float = 0.0
var panning_duration: float = 3.0
```

**Methods:**
```gdscript
func _initialize_game() -> void:
	## Initializes game state and UI

func _try_to_pan() -> void:
	## Attempts to start panning action

func _start_panning() -> void:
	## Begins panning minigame

func _complete_panning() -> void:
	## Completes panning and calculates results

func _calculate_gold_yield() -> int:
	## Calculates gold found based on factors
	## @return: Number of gold pieces found

func get_gold_count() -> int:
	## Returns current gold count
	## @return: Gold amount
```

**Signals:**
```gdscript
signal gold_found(amount: int)
signal tool_changed(tool_name: String)
signal game_started
signal game_ended
```

---

## Player Systems

### Inventory

**Path:** `scripts/player/inventory.gd`

**Purpose:** Manages player inventory (gold, tools, items).

**Properties:**
```gdscript
var gold: int = 0
var tools: Dictionary = {}
var current_tool: ToolDataScript = null
var max_gold_capacity: int = 1000
```

**Methods:**
```gdscript
func add_gold(amount: int) -> void:
	## Adds gold to inventory
	## @param amount: Amount to add

func remove_gold(amount: int) -> bool:
	## Removes gold from inventory
	## @param amount: Amount to remove
	## @return: true if successful, false if insufficient

func add_tool(tool: ToolDataScript) -> void:
	## Adds tool to inventory
	## @param tool: Tool object to add

func equip_tool(tool_id: String) -> void:
	## Equips a tool from inventory
	## @param tool_id: ID of tool to equip

func repair_tool(tool_id: String, amount: int) -> int:
	## Repairs a tool
	## @param tool_id: ID of tool
	## @param amount: Durability to restore
	## @return: Cost in gold

func get_tool_count() -> int:
	## Returns number of tools owned
	## @return: Tool count
```

**Signals:**
```gdscript
signal inventory_updated
signal tool_equipped(tool: ToolDataScript)
signal gold_changed(new_amount: int)
```

---

## Panning Systems

### PanningController

**Path:** `scripts/panning/panning_controller.gd`

**Purpose:** Handles gold panning minigame mechanics.

**Properties:**
```gdscript
var pan_contents: Array = []
var gold_count: int = 0
var sediment_count: int = 0
var pan_tilt_angle: float = 0.0
var water_amount: float = 100.0
var location_richness: float = 1.0
var success_threshold: float = 0.6
```

**Methods:**
```gdscript
func start_panning_minigame() -> void:
	## Initializes and starts panning minigame

func end_panning_minigame() -> void:
	## Ends panning and evaluates results

func tilt_pan(direction: float) -> void:
	## Tilts pan in specified direction
	## @param direction: -1.0 (left) to 1.0 (right)

func shake_pan() -> void:
	## Applies shaking motion to pan

func add_water() -> void:
	## Adds water to pan

func remove_water() -> void:
	## Removes water from pan

func calculate_separation_factor() -> float:
	## Calculates how well sediment is separated
	## @return: Factor from 0.0 to 1.0

func detect_gold() -> int:
	## Attempts to detect gold in pan
	## @return: Number of gold particles found
```

**Signals:**
```gdscript
signal panning_success(gold_found: int)
signal panning_failure
signal minigame_started
signal minigame_ended
signal sediment_removed(amount: int)
signal water_added
```

---

## Tool Systems

### ToolData

**Path:** `scripts/tools/tool_data.gd`

**Purpose:** Defines tool properties and behavior.

**Properties:**
```gdscript
var tool_name: String = ""
var tool_type: ToolType = ToolType.BASIC_PAN
var effectiveness: float = 1.0
var durability: int = 100
var max_durability: int = 100
var cost: int = 0
var repair_cost_per_point: float = 0.5
```

**Enums:**
```gdscript
enum ToolType {
	BASIC_PAN,
	GOLD_PAN,
	PROFESSIONAL_PAN,
	SLUICE_BOX
}
```

**Methods:**
```gdscript
func use_tool(amount: int = 1) -> void:
	## Uses tool, reducing durability
	## @param amount: Durability to consume

func repair(amount: int) -> void:
	## Repairs tool
	## @param amount: Durability to restore

func get_effectiveness_modifier() -> float:
	## Returns current effectiveness based on durability
	## @return: Modified effectiveness value

func is_broken() -> bool:
	## Checks if tool is broken
	## @return: true if durability <= 0
```

---

## Signal Reference

### Global Signals

**AudioManager:**
- `music_started(track_name: String)`
- `music_stopped()`
- `sfx_played(sound_name: String)`

**Economy:**
- `price_changed(new_price: float)`
- `market_trend_changed(new_trend: String)`
- `gold_sold(amount: int, earnings: int)`

**Time:**
- `hour_changed(new_hour: int)`
- `day_changed(new_day: int)`
- `time_of_day_changed(period: String)`

**Weather:**
- `weather_changed(new_weather: String)`
- `weather_intensity_changed(intensity: float)`

### Gameplay Signals

**MainGame:**
- `gold_found(amount: int)`
- `tool_changed(tool_name: String)`
- `game_started`
- `game_ended`

**Inventory:**
- `inventory_updated`
- `tool_equipped(tool: ToolDataScript)`
- `gold_changed(new_amount: int)`

**PanningController:**
- `panning_success(gold_found: int)`
- `panning_failure`
- `minigame_started`
- `minigame_ended`
- `sediment_removed(amount: int)`
- `water_added`

---

## Code Examples

### Example: Complete Panning Sequence

```gdscript
# In main game script
func start_gold_panning():
	# Initialize panning controller
	var panning = $PanningController

	# Set location richness
	panning.location_richness = current_location.richness

	# Connect signals
	panning.panning_success.connect(_on_panning_success)
	panning.panning_failure.connect(_on_panning_failure)

	# Start minigame
	panning.start_panning_minigame()

func _on_panning_success(gold_found: int):
	# Add gold to inventory
	Inventory.add_gold(gold_found)

	# Play success sound
	AudioManager.play_sfx("gold_found")

	# Update UI
	update_gold_display()

func _on_panning_failure():
	# Play failure sound
	AudioManager.play_sfx("panning_fail")

	# Show message
	show_message("No gold found")
```

### Example: Economic Transaction

```gdscript
# Selling gold
func sell_all_gold():
	var gold_amount = Inventory.gold
	if gold_amount > 0:
		# Check current price
		var price = Economy.get_gold_price()
		print("Selling at ", price, " per gold")

		# Execute sale
		var earnings = Economy.sell_gold(gold_amount)

		# Remove from inventory
		Inventory.remove_gold(gold_amount)

		# Add currency
		currency += earnings

		# Update UI
		update_displays()
```

### Example: Tool Management

```gdscript
# Equipping and using a tool
func use_tool_for_panning():
	# Get current tool
	var tool = Inventory.current_tool

	if tool:
		# Check durability
		if tool.durability > 0:
			# Use tool (consumes durability)
			tool.use_tool(2)

			# Get effectiveness modifier
			var effectiveness = tool.get_effectiveness_modifier()

			# Apply to gold calculation
			var gold_found = base_gold * effectiveness

			# Check if tool needs repair
			if tool.durability < 20:
				show_warning("Tool durability low!")
		else:
			show_error("Tool is broken!")
			prompt_repair()
```

---

## Constants Reference

### Global Constants

```gdscript
# Game
const GAME_VERSION: String = "1.0.0"
const SAVE_VERSION: int = 1

# Economy
const BASE_GOLD_PRICE: float = 10.0
const MIN_GOLD_PRICE: float = 7.0
const MAX_GOLD_PRICE: float = 15.0

# Time
const MINUTES_PER_HOUR: int = 60
const HOURS_PER_DAY: int = 24
const GAME_MINUTES_PER_REAL_SECOND: float = 2.0

# Panning
const MIN_SEDIMENT: int = 20
const MAX_SEDIMENT: int = 80
const MIN_GOLD: int = 0
const MAX_GOLD: int = 10

# Tools
const MAX_TOOLS_INVENTORY: int = 10
const BASIC_PAN_COST: int = 0
const GOLD_PAN_COST: int = 100
const PROFESSIONAL_PAN_COST: int = 250
const SLUICE_BOX_COST: int = 500
```

---

[← Back: Development Guide](Development-Guide.md) | [🏠 Back to Wiki Home](Home.md)
