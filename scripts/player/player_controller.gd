extends CharacterBody2D

## Player controller script for Buffalo Brook Gold Rush
## Handles player movement, state management, and interaction with the panning minigame
## Now includes tool type management and location difficulty tracking

# Load probability tables
const ToolTables = preload("res://resources/data/tool_probability_tables.gd")
const LocationTables = preload("res://resources/data/location_probability_tables.gd")

# Reference to global inventory system
var inventory: Node = null

# Signals that communicate player state changes to other systems
signal panning_started()  # Emitted when player begins the panning minigame
signal panning_ended()    # Emitted when player exits the panning minigame
signal gold_found(amount) # Emitted when player finds gold during panning
signal location_changed(new_location)  # Emitted when player moves to new location
signal stamina_changed(value)          # Emitted when player stamina changes
signal tool_changed(new_tool)          # Emitted when player changes tools

# Player movement variables
var speed: float = 200.0  # Movement speed in pixels per second
var max_stamina: float = 100.0  # Maximum stamina value
var stamina: float = 100.0      # Current stamina (affects panning duration)
var stamina_regeneration_rate: float = 5.0  # Stamina regenerates when not panning

# Panning-related variables
var is_panning: bool = false  # Tracks whether player is currently panning
var current_location: String  # Current panning location name
var pan_equipped: bool = true  # Whether player has pan equipped

# Tool management variables
var current_tool: ToolTables.ToolType = ToolTables.ToolType.BASIC_PAN  # Current tool being used
var owned_tools: Array[ToolTables.ToolType] = [ToolTables.ToolType.BASIC_PAN]  # Tools player owns

# Location difficulty tracking
var current_location_difficulty: LocationTables.LocationDifficulty = LocationTables.LocationDifficulty.MODERATE

# Input handling variables
var _target_velocity: Vector2 = Vector2.ZERO  # Internal velocity vector

# Reference to travel system
var travel_system: Node = null

# Reference to weather system
var weather_system: Node = null

func _ready():
	## Called when the node enters the scene tree for the first time
	# Player starts at full stamina
	stamina = max_stamina
	print("Player controller initialized")
	
	# Initialize with basic pan
	current_tool = ToolTables.ToolType.BASIC_PAN
	
	# Connect to global inventory system
	_connect_to_inventory()
	
	# Connect to travel system
	_connect_to_travel_system()
	
	# Connect to weather system
	_connect_to_weather_system()

func _connect_to_inventory():
	## Connects to the global inventory system
	if has_node("/root/Main/Inventory"):  # Adjust path based on your scene structure
		inventory = get_node("/root/Main/Inventory")
		print("Player controller connected to inventory system")
	elif "Inventory" in get_tree().root:  # If inventory is autoloaded
		inventory = get_tree().root.get_node("Inventory")
		print("Player controller connected to autoloaded inventory")
	else:
		print("WARNING: Player controller could not connect to inventory system")

func _connect_to_travel_system():
	## Connects to the travel system
	if "TravelSystem" in get_tree().root:
		travel_system = get_tree().root.get_node("TravelSystem")
		print("Player controller connected to travel system")
	elif has_node("/root/Main/TravelSystem"):
		travel_system = get_node("/root/Main/TravelSystem")
		print("Player controller connected to travel system")
	else:
		print("WARNING: Player controller could not connect to travel system")

func _connect_to_weather_system():
	## Connects to the weather system
	if "Weather" in get_tree().root:  # Autoloaded weather system
		weather_system = get_tree().root.get_node("Weather")
		if weather_system and weather_system.has_method("get_weather_system"):
			weather_system = weather_system.get_weather_system()  # Get actual weather system from autoload
		print("Player controller connected to weather system")
	elif has_node("/root/Main/WeatherSystem"):
		weather_system = get_node("/root/Main/WeatherSystem")
		print("Player controller connected to weather system")
	else:
		print("WARNING: Player controller could not connect to weather system")

func get_current_location_id() -> int:
	## Returns the current location ID
	if travel_system and travel_system.has_method("get_current_location"):
		return travel_system.get_current_location()
	else:
		print("Travel system not available, returning default location")
		return 0  # Default to first location

func get_current_location_name() -> String:
	## Returns the current location name
	if travel_system and travel_system.has_method("get_current_location_name"):
		return travel_system.get_current_location_name()
	else:
		return "Unknown Location"

func get_current_weather() -> int:
	## Returns the current weather state
	if weather_system and weather_system.has_method("get_current_weather"):
		return weather_system.get_current_weather()
	else:
		print("Weather system not available, returning default (sunny)")
		return 0  # Default to sunny

func get_current_weather_name() -> String:
	## Returns the current weather name
	if weather_system and weather_system.has_method("get_current_weather_name"):
		return weather_system.get_current_weather_name()
	else:
		return "Unknown Weather"

func _physics_process(delta: float):
	## Called every physics frame to handle movement and state updates
	_apply_stamina_regeneration(delta)
	
	if not is_panning:
		_handle_movement(delta)
		_move_player(delta)

func _handle_movement(delta: float):
	## Processes player input for movement
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	# Calculate target velocity based on input and speed
	_target_velocity = input_vector * speed

func _move_player(delta: float):
	## Applies movement to the player character
	velocity = _target_velocity
	move_and_slide()

func _apply_stamina_regeneration(delta: float):
	## Regenerates stamina when not panning
	if not is_panning and stamina < max_stamina:
		stamina = min(stamina + (stamina_regeneration_rate * delta), max_stamina)
		stamina_changed.emit(stamina)

func start_panning():
	## Initiates the panning minigame and updates player state
	if stamina > 0 and not is_panning and pan_equipped:
		is_panning = true
		panning_started.emit()
		# Lower stamina when starting panning
		stamina = max(0, stamina - 5)

func end_panning():
	## Ends the panning minigame and updates player state
	if is_panning:
		is_panning = false
		panning_ended.emit()

func set_location(location_name: String, difficulty: LocationTables.LocationDifficulty = LocationTables.LocationDifficulty.MODERATE):
	## Updates current location and difficulty, emits signal
	if current_location != location_name:
		current_location = location_name
		current_location_difficulty = difficulty
		location_changed.emit(location_name)

func add_gold(amount: int):
	## Adds gold to player's inventory and emits signal
	if inventory:
		inventory.add_gold(amount)
	else:
		print("WARNING: No inventory system connected, adding to local gold")
		# Fallback to local tracking if no inventory system
		_gold_found_fallback(amount)
	gold_found.emit(amount)
	print("Added " + str(amount) + " gold.")

func _gold_found_fallback(amount: int):
	## Fallback for when inventory system is not available
	# This would be a local tracking system if needed
	pass

func consume_stamina(amount: float):
	## Reduces player stamina and checks for exhaustion
	stamina = max(0, stamina - amount)
	stamina_changed.emit(stamina)

func can_pan():
	## Checks if player has the required stamina and equipment to pan
	return stamina > 0 and pan_equipped and not is_panning

func get_gold_count() -> int:
	## Returns the player's current gold count from inventory system
	if inventory:
		return inventory.get_gold()
	else:
		# Fallback if no inventory system is connected
		return 0

func remove_gold(amount: int) -> bool:
	## Removes gold from player's inventory (for purchases)
	if inventory:
		return inventory.remove_gold(amount)
	else:
		print("WARNING: No inventory system connected, cannot remove gold")
		return false

func set_tool(tool_type: ToolTables.ToolType) -> bool:
	## Sets the current tool if player owns it
	if owned_tools.has(tool_type):
		current_tool = tool_type
		tool_changed.emit(tool_type)
		print("Tool changed to: " + str(tool_type))
		return true
	else:
		print("Player doesn't own tool: " + str(tool_type))
		return false

func get_current_tool() -> ToolTables.ToolType:
	## Returns the current tool being used
	return current_tool

func get_current_location_difficulty() -> LocationTables.LocationDifficulty:
	## Returns the current location difficulty
	return current_location_difficulty

func add_tool(tool_type: ToolTables.ToolType):
	## Adds a tool to the player's inventory
	if not owned_tools.has(tool_type):
		owned_tools.append(tool_type)
		print("Added tool to inventory: " + str(tool_type))

func get_tool_probability_multiplier() -> float:
	## Returns the probability multiplier for the current tool
	return ToolTables.TOOL_PROBABILITY_TABLE[current_tool]

func get_tool_efficiency_multiplier() -> float:
	## Returns the efficiency multiplier for the current tool
	return ToolTables.TOOL_EFFICIENCY_TABLE[current_tool]

func get_location_probability_multiplier() -> float:
	## Returns the probability multiplier for the current location
	return LocationTables.LOCATION_PROBABILITY_TABLE[current_location_difficulty]

func get_location_sediment_multiplier() -> float:
	## Returns the sediment density multiplier for the current location
	return LocationTables.LOCATION_SEDIMENT_DENSITY_TABLE[current_location_difficulty]