## Global weather system for Buffalo Brook Gold Rush
## Manages weather states and their effects on gameplay

# Weather states
enum WeatherState {
	SUNNY = 0,
	RAINY = 1,
	FOGGY = 2
}

## Weather data class
class WeatherData:
	var state: WeatherState
	var name: String
	var description: String
	var effect_on_gold_visibility: float  # Multiplier for how well gold can be seen (1.0 = normal)
	var effect_on_panning_difficulty: float  # Multiplier for panning difficulty (1.0 = normal)
	var ambient_sound_multiplier: float  # Multiplier for ambient water sounds
	var visibility_range: float  # How far the player can see (in foggy conditions)
	var precipitation_intensity: float  # How heavy the rain is (0.0-1.0)
	
	## Constructor
	func _init(p_state: WeatherState, p_name: String, p_description: String):
		state = p_state
		name = p_name
		description = p_description
		
		# Default values for sunny weather (baseline)
		effect_on_gold_visibility = 1.0
		effect_on_panning_difficulty = 1.0
		ambient_sound_multiplier = 1.0
		visibility_range = 100.0  # Full visibility
		precipitation_intensity = 0.0

## Global weather system
extends Node

# Signals for weather events
signal weather_changed(old_weather, new_weather)
signal weather_transition_started(from_weather, to_weather, transition_time)
signal weather_effect_applied(weather_state)

# Current weather state
var current_weather: WeatherState = WeatherState.SUNNY
var current_weather_data: WeatherData = null

# Weather state information
var weather_states: Dictionary = {}

# Random number generator for weather changes
var weather_rng: RandomNumberGenerator = RandomNumberGenerator.new()

# Weather transition effects
var is_transitioning: bool = false
var transition_start_time: float = 0.0
var transition_duration: float = 5.0  # 5 seconds for weather transition

# Reference to economy system
var economy_system: Node = null

func _ready():
	## Initialize the weather system
	weather_rng.randomize()
	_initialize_weather_states()
	current_weather_data = weather_states[current_weather]
	
	# Start with sunny weather
	_set_weather(WeatherState.SUNNY)
	
	# Connect to economy system to change weather with each new day
	_connect_to_economy_system()
	
	print("Weather system initialized. Current weather: " + current_weather_data.name)

func _connect_to_economy_system():
	## Connects to the economy system to trigger weather changes on new days
	if "Economy" in get_tree().root:
		economy_system = get_tree().root.get_node("Economy")
		if economy_system and economy_system.has_signal("day_advanced"):
			economy_system.day_advanced.connect(_on_new_day)
			print("Weather system connected to economy system")
	elif has_node("/root/Main/Economy"):
		economy_system = get_node("/root/Main/Economy")
		if economy_system and economy_system.has_signal("day_advanced"):
			economy_system.day_advanced.connect(_on_new_day)
			print("Weather system connected to economy system")
	else:
		print("WARNING: Weather system could not connect to economy system")
		# If no economy system is available, try the time system
		_connect_to_time_system()

func _connect_to_time_system():
	## Connects to the time system as an alternative trigger for weather changes
	if "TimeClock" in get_tree().root:
		var time_system = get_tree().root.get_node("TimeClock")
		if time_system and time_system.has_signal("day_advanced"):
			time_system.day_advanced.connect(_on_new_day)
			print("Weather system connected to time system")
	elif has_node("/root/Main/TimeClock"):
		var time_system = get_node("/root/Main/TimeClock")
		if time_system and time_system.has_signal("day_advanced"):
			time_system.day_advanced.connect(_on_new_day)
			print("Weather system connected to time system")
	else:
		print("WARNING: Weather system could not connect to time system")
		# If no time system is available either, use a timer for testing
		_start_test_timer()

func _start_test_timer():
	## Starts a test timer to change weather every 30 seconds (for testing without economy system)
	var test_timer = Timer.new()
	test_timer.wait_time = 30.0  # Change weather every 30 seconds for testing
	test_timer.timeout.connect(_on_test_timer_timeout)
	add_child(test_timer)
	test_timer.start()

func _on_test_timer_timeout():
	## Called by test timer to change weather
	_change_weather_randomly()

func _on_new_day(new_day: int):
	## Called when a new day starts in the economy system
	_change_weather_randomly()
	print("New day " + str(new_day) + ": Weather changed to " + current_weather_data.name)

func _change_weather_randomly():
	## Changes to a random weather state different from the current one
	var new_weather = get_random_weather_state()
	_set_weather(new_weather)

func _initialize_weather_states():
	## Initializes data for each weather state
	# Sunny weather - optimal conditions
	var sunny_data = WeatherData.new(WeatherState.SUNNY, "Sunny", "Clear skies with good visibility for panning.")
	sunny_data.effect_on_gold_visibility = 1.0
	sunny_data.effect_on_panning_difficulty = 1.0
	sunny_data.ambient_sound_multiplier = 1.0
	sunny_data.visibility_range = 100.0
	weather_states[WeatherState.SUNNY] = sunny_data

	# Rainy weather - reduces visibility, increases ambiance
	var rainy_data = WeatherData.new(WeatherState.RAINY, "Rainy", "Rain reduces visibility but adds to the natural ambiance.")
	rainy_data.effect_on_gold_visibility = 0.6  # 40% reduction in visibility
	rainy_data.effect_on_panning_difficulty = 1.2  # 20% increase in difficulty
	rainy_data.ambient_sound_multiplier = 2.0  # Double the ambient water sounds
	rainy_data.visibility_range = 30.0  # Reduced visibility
	rainy_data.precipitation_intensity = 0.8  # Heavy rain
	weather_states[WeatherState.RAINY] = rainy_data

	# Foggy weather - greatly reduced visibility
	var foggy_data = WeatherData.new(WeatherState.FOGGY, "Foggy", "Thick fog reduces visibility but creates a mysterious atmosphere.")
	foggy_data.effect_on_gold_visibility = 0.4  # 60% reduction in visibility
	foggy_data.effect_on_panning_difficulty = 1.3  # 30% increase in difficulty
	foggy_data.ambient_sound_multiplier = 0.7  # Slightly muffled sounds
	foggy_data.visibility_range = 15.0  # Very limited visibility
	foggy_data.precipitation_intensity = 0.2  # Light precipitation
	weather_states[WeatherState.FOGGY] = foggy_data

func get_current_weather() -> WeatherState:
	## Returns the current weather state
	return current_weather

func get_current_weather_name() -> String:
	## Returns the name of the current weather
	return current_weather_data.name

func get_current_weather_description() -> String:
	## Returns the description of the current weather
	return current_weather_data.description

func get_weather_data(weather_state: WeatherState) -> WeatherData:
	## Returns the data for a specific weather state
	return weather_states.get(weather_state, null)

func get_gold_visibility_multiplier() -> float:
	## Returns the multiplier for gold visibility based on current weather
	return current_weather_data.effect_on_gold_visibility

func get_panning_difficulty_multiplier() -> float:
	## Returns the multiplier for panning difficulty based on current weather
	return current_weather_data.effect_on_panning_difficulty

func get_ambient_sound_multiplier() -> float:
	## Returns the multiplier for ambient sounds based on current weather
	return current_weather_data.ambient_sound_multiplier

func get_visibility_range() -> float:
	## Returns the visibility range based on current weather
	return current_weather_data.visibility_range

func get_precipitation_intensity() -> float:
	## Returns the precipitation intensity based on current weather
	return current_weather_data.precipitation_intensity

func is_raining() -> bool:
	## Returns whether it's currently raining
	return current_weather == WeatherState.RAINY

func is_foggy() -> bool:
	## Returns whether it's currently foggy
	return current_weather == WeatherState.FOGGY

func is_sunny() -> bool:
	## Returns whether it's currently sunny
	return current_weather == WeatherState.SUNNY

func set_weather(new_weather: WeatherState):
	## Sets the weather to a specific state (for debugging or story events)
	if weather_states.has(new_weather):
		_set_weather(new_weather)

func _set_weather(new_weather: WeatherState):
	## Internal function to set the weather and trigger associated events
	if new_weather == current_weather:
		return  # No change
	
	var old_weather = current_weather
	current_weather = new_weather
	current_weather_data = weather_states[current_weather]
	
	# Emit signal for weather change
	emit_signal("weather_changed", old_weather, current_weather)
	emit_signal("weather_effect_applied", current_weather)
	
	print("Weather changed from " + weather_states[old_weather].name + " to " + current_weather_data.name)

func get_random_weather_state() -> WeatherState:
	## Returns a random weather state (excluding current weather to prevent same state)
	var possible_states = [WeatherState.SUNNY, WeatherState.RAINY, WeatherState.FOGGY]
	possible_states.erase(current_weather)
	
	# Randomly select from remaining states
	var random_index = weather_rng.randi() % possible_states.size()
	return possible_states[random_index]

func get_all_weather_states() -> Array:
	## Returns an array of all possible weather states
	return [WeatherState.SUNNY, WeatherState.RAINY, WeatherState.FOGGY]

func get_weather_state_name(weather_state: WeatherState) -> String:
	## Returns the name of a weather state
	var data = weather_states.get(weather_state, null)
	return data.name if data else "Unknown"

func get_weather_transition_progress() -> Dictionary:
	## Returns information about any ongoing weather transition
	if not is_transitioning:
		return {
			"is_transitioning": false,
			"progress": 0.0,
			"from_weather": null,
			"to_weather": null
		}
	
	var current_time = Time.get_ticks_msec() / 1000.0
	var elapsed_time = current_time - transition_start_time
	var progress = min(1.0, elapsed_time / transition_duration)
	
	return {
		"is_transitioning": true,
		"progress": progress,
		"from_weather": null,  # Would need to track this separately
		"to_weather": current_weather
	}

# Debug/cheat functions
func force_weather_change():
	## Forces a weather change for testing
	var new_weather = get_random_weather_state()
	_set_weather(new_weather)

func debug_set_weather_sunny():
	## Debug function to set weather to sunny
	set_weather(WeatherState.SUNNY)

func debug_set_weather_rainy():
	## Debug function to set weather to rainy
	set_weather(WeatherState.RAINY)

func debug_set_weather_foggy():
	## Debug function to set weather to foggy
	set_weather(WeatherState.FOGGY)