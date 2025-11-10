extends Node

## Panning integration manager for Buffalo Brook Gold Rush
## Manages the connection between panning minigame and player gold system
## Now includes location-based parameters

# Reference to player character
@onready var player = get_parent().get_node("Player") as CharacterBody2D

# Reference to panning minigame
@onready var panning_minigame = get_parent().get_node("PanningMinigame") as Node2D

# Reference to panning interaction area
@onready var panning_interaction = get_parent().get_node("PanningInteraction") as Area2D

# Reference to travel system
var travel_system: Node = null

# Reference to weather system
var weather_system: Node = null

# Variable to track gold found in current session
var gold_found_current_session: int = 0

func _ready():
	## Connect all necessary signals for communication between systems
	_connect_signals()
	_connect_to_travel_system()
	_connect_to_weather_system()

func _connect_signals():
	## Connect signals between panning minigame and player system
	if panning_minigame:
		panning_minigame.panning_success.connect(_on_panning_success)
		panning_minigame.panning_ended.connect(_on_panning_ended)
		panning_minigame.gold_found.connect(_on_gold_found)
	
	if panning_interaction:
		panning_interaction.panning_started.connect(_on_panning_started)

func _connect_to_travel_system():
	## Connects to the travel system to get location-specific parameters
	if "TravelSystem" in get_tree().root:
		travel_system = get_tree().root.get_node("TravelSystem")
		print("Panning integration connected to travel system")
	elif has_node("/root/Main/TravelSystem"):
		travel_system = get_node("/root/Main/TravelSystem")
		print("Panning integration connected to travel system")
	else:
		print("WARNING: Panning integration could not connect to travel system")

func _connect_to_weather_system():
	## Connects to the weather system to get weather-specific parameters
	if "Weather" in get_tree().root:  # Autoloaded weather system
		weather_system = get_tree().root.get_node("Weather")
		if weather_system and weather_system.has_method("get_weather_system"):
			weather_system = weather_system.get_weather_system()  # Get actual weather system from autoload
		print("Panning integration connected to weather system")
	elif has_node("/root/Main/WeatherSystem"):
		weather_system = get_node("/root/Main/WeatherSystem")
		print("Panning integration connected to weather system")
	else:
		print("WARNING: Panning integration could not connect to weather system")

func _on_panning_started():
	## Handle when panning starts
	print("Panning session started")
	
	# Pass location and weather information to the panning minigame
	_update_panning_location_parameters()
	_update_panning_weather_parameters()
	
	# Disable player movement while panning
	if player:
		player.start_panning()

func _update_panning_location_parameters():
	## Updates the panning minigame with location-specific parameters
	if not travel_system or not panning_minigame:
		return
	
	var current_location = travel_system.get_current_location()
	if current_location == null:
		return
	
	# Set location difficulty based on location data
	var location_data = load("res://scripts/environment/location_data.gd").get_location_by_id(current_location)
	if location_data:
		# Pass location-specific parameters to the minigame
		# This requires updating the panning_minigame to accept location parameters
		if panning_minigame.has_method("set_location_difficulty"):
			# Use location difficulty to set appropriate parameters
			var difficulty_enum = load("res://resources/data/location_probability_tables.gd").LocationDifficulty.MODERATE
			# Map location difficulty (1-10) to our enum
			if location_data.difficulty <= 3:
				difficulty_enum = load("res://resources/data/location_probability_tables.gd").LocationDifficulty.EASY
			elif location_data.difficulty <= 6:
				difficulty_enum = load("res://resources/data/location_probability_tables.gd").LocationDifficulty.MODERATE
			elif location_data.difficulty <= 8:
				difficulty_enum = load("res://resources/data/location_probability_tables.gd").LocationDifficulty.DIFFICULT
			else:
				difficulty_enum = load("res://resources/data/location_probability_tables.gd").LocationDifficulty.VERY_DIFFICULT
				
			panning_minigame.set_location_difficulty(difficulty_enum)

func _on_panning_success(gold_found: int):
	## Handle successful panning result
	print("Panning session successful! Found: " + str(gold_found) + " gold")
	gold_found_current_session = gold_found

func _on_panning_ended():
	## Handle the end of panning session and update player gold
	if player and gold_found_current_session > 0:
		# Add the gold found to the player's inventory via the player controller
		# (the actual gold transfer happens in the minigame itself)
		player.add_gold(gold_found_current_session)
		
		# Alternative: if the minigame doesn't handle gold transfer, do it here:
		# player.add_gold(gold_found_current_session)
		
		# Reset session gold counter
		gold_found_current_session = 0
		
		# Enable player movement again
		if player.has_method("end_panning"):
			player.end_panning()
	
	# In a full implementation, this might also trigger UI updates,
	# achievements, or other game systems

func _on_gold_found(amount: int):
	## Handle when individual gold particles are found during panning
	# This could be used for real-time feedback to the player
	print("Found " + str(amount) + " gold particle(s)")

func _update_panning_weather_parameters():
	## Updates the panning minigame with weather-specific parameters
	if not weather_system or not panning_minigame:
		return
	
	# Get current weather state
	var current_weather = -1
	if weather_system.has_method("get_current_weather"):
		current_weather = weather_system.get_current_weather()
	
	if current_weather == -1:
		return
	
	# Get weather data
	var gold_visibility_mult = 1.0
	if weather_system.has_method("get_gold_visibility_multiplier"):
		gold_visibility_mult = weather_system.get_gold_visibility_multiplier()
	
	# In a real implementation, you might want to pass this to the minigame
	# However, the panning_minigame already accounts for this through the check_for_gold_revelation function
	# This would be more useful if we needed to adjust other parameters based on weather
	print("Applied weather effects: gold visibility multiplier = " + str(gold_visibility_mult))

func start_panning_session():
	## Public method to start a panning session from other systems
	if panning_minigame:
		_update_panning_location_parameters()
		_update_panning_weather_parameters()
		panning_minigame.start_panning_minigame()

func get_session_gold_count() -> int:
	## Returns gold found in current session
	return gold_found_current_session

func force_end_panning():
	## Forces end of panning session (for error recovery or special cases)
	if panning_minigame:
		panning_minigame.end_panning_minigame()