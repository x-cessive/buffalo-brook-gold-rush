extends Node

## Environment-specific parameters for Buffalo Brook Gold Rush
## Handles location-based modifiers for panning difficulty, gold discovery, and other gameplay elements

# Load location data
const LocationDataScript = preload("res://scripts/environment/location_data.gd")

# Reference to travel system to know current location
var travel_system: Node = null

# Cached location parameters to avoid repeated calculations
var _cached_location_params: Dictionary = {}
var _last_location_update: int = 0

func _ready():
	## Initialize the environment parameters system
	_connect_to_travel_system()
	_update_location_parameters()

func _connect_to_travel_system():
	## Connects to the travel system to get location updates
	if "TravelSystem" in get_tree().root:
		travel_system = get_tree().root.get_node("TravelSystem")
		if travel_system:
			travel_system.location_changed.connect(_on_location_changed)
			print("Environment parameters connected to travel system")
	elif has_node("/root/Main/TravelSystem"):
		travel_system = get_node("/root/Main/TravelSystem")
		if travel_system:
			travel_system.location_changed.connect(_on_location_changed)
			print("Environment parameters connected to travel system")
	else:
		print("WARNING: Could not connect to travel system for location updates")

func _on_location_changed(new_location: int):
	## Updates parameters when the player changes location
	_update_location_parameters()
	print("Location changed, environment parameters updated")

func _update_location_parameters():
	## Updates cached parameters based on current location
	if not travel_system:
		_connect_to_travel_system()
		if not travel_system:
			return
	
	var current_location = travel_system.get_current_location()
	
	# Get location data
	var location_data = LocationDataScript.get_location_by_id(current_location)
	if not location_data:
		print("ERROR: Could not get location data for ID: " + str(current_location))
		return
	
	# Calculate location-specific parameters
	var params = {}
	params.location_id = current_location
	params.gold_rarity_multiplier = location_data.gold_rarity
	params.difficulty_modifier = float(location_data.difficulty) / 10.0  # Normalize to 0-1 scale
	params.panning_time_modifier = 1.0 + (float(location_data.difficulty) / 20.0)  # More difficult locations take longer
	params.weather_resistance = 1.0 - (float(location_data.difficulty) / 30.0)  # Higher difficulty = more weather resistant
	params.special_item_bonus = float(location_data.special_items.size()) / 5.0  # Bonus for locations with more special items
	
	# Cache the parameters
	_cached_location_params[current_location] = params
	_last_location_update = Time.get_ticks_msec()

func get_current_location_params() -> Dictionary:
	## Returns the current location parameters
	if not travel_system:
		return {}
	
	var current_location = travel_system.get_current_location()
	if _cached_location_params.has(current_location):
		return _cached_location_params[current_location].duplicate()
	
	# If not cached, try to update
	_update_location_parameters()
	return _cached_location_params.get(current_location, {})

func get_gold_rarity_multiplier() -> float:
	## Returns the gold rarity multiplier for the current location
	var params = get_current_location_params()
	return params.get("gold_rarity_multiplier", 1.0)

func get_difficulty_modifier() -> float:
	## Returns the difficulty modifier for the current location
	var params = get_current_location_params()
	return params.get("difficulty_modifier", 0.5)  # Default to medium difficulty

func get_panning_time_modifier() -> float:
	## Returns the panning time modifier for the current location
	var params = get_current_location_params()
	return params.get("panning_time_modifier", 1.0)

func get_weather_resistance() -> float:
	## Returns the weather resistance for the current location
	var params = get_current_location_params()
	return params.get("weather_resistance", 0.8)

func get_special_item_bonus() -> float:
	## Returns the special item bonus for the current location
	var params = get_current_location_params()
	return params.get("special_item_bonus", 0.0)

func get_location_name() -> String:
	## Returns the name of the current location
	if travel_system and travel_system.has_method("get_current_location_name"):
		return travel_system.get_current_location_name()
	
	var params = get_current_location_params()
	var location_data = LocationDataScript.get_location_by_id(params.get("location_id", LocationDataScript.LocationID.BUFFALO_BROOK))
	return location_data.name if location_data else "Unknown Location"

func get_location_description() -> String:
	## Returns the description of the current location
	if travel_system:
		var current_location = travel_system.get_current_location()
		var location_data = LocationDataScript.get_location_by_id(current_location)
		return location_data.description if location_data else "No description available"
	
	return "No description available"

func force_update_params():
	## Forces an update of location parameters
	_update_location_parameters()

func get_location_ambient_sound() -> String:
	## Returns the ambient sound for the current location
	if travel_system:
		var current_location = travel_system.get_current_location()
		var location_data = LocationDataScript.get_location_by_id(current_location)
		return location_data.ambient_sound if location_data else ""
	
	return ""

func get_location_water_color() -> Color:
	## Returns the water color for the current location
	if travel_system:
		var current_location = travel_system.get_current_location()
		var location_data = LocationDataScript.get_location_by_id(current_location)
		return location_data.water_color if location_data else Color(0.3, 0.6, 1.0)
	
	return Color(0.3, 0.6, 1.0)

func get_location_special_items() -> Array:
	## Returns special items available at the current location
	if travel_system:
		var current_location = travel_system.get_current_location()
		var location_data = LocationDataScript.get_location_by_id(current_location)
		return location_data.special_items if location_data else []
	
	return []