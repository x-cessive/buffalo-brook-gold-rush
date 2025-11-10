extends Node

## Weather autoload for Buffalo Brook Gold Rush
## Makes the weather system globally accessible

# Singleton instance of weather system
var weather_system: Node = null

func _ready():
	## Initialize the weather autoload
	_initialize_weather_system()

func _initialize_weather_system():
	## Creates and initializes the weather system
	var WeatherSystemScript = load("res://scripts/environment/weather_system.gd")
	if WeatherSystemScript:
		weather_system = WeatherSystemScript.new()
		add_child(weather_system)
		print("Weather system loaded and initialized")
	else:
		print("ERROR: Could not load weather system")

func get_weather_system() -> Node:
	## Returns the weather system instance
	return weather_system

# Proxy methods to make weather functions easily accessible
func get_current_weather() -> int:
	## Returns the current weather state
	if weather_system and weather_system.has_method("get_current_weather"):
		return weather_system.get_current_weather()
	return 0

func get_current_weather_name() -> String:
	## Returns the name of the current weather
	if weather_system and weather_system.has_method("get_current_weather_name"):
		return weather_system.get_current_weather_name()
	return "Unknown"

func get_gold_visibility_multiplier() -> float:
	## Returns the gold visibility multiplier
	if weather_system and weather_system.has_method("get_gold_visibility_multiplier"):
		return weather_system.get_gold_visibility_multiplier()
	return 1.0

func get_panning_difficulty_multiplier() -> float:
	## Returns the panning difficulty multiplier
	if weather_system and weather_system.has_method("get_panning_difficulty_multiplier"):
		return weather_system.get_panning_difficulty_multiplier()
	return 1.0

func get_ambient_sound_multiplier() -> float:
	## Returns the ambient sound multiplier
	if weather_system and weather_system.has_method("get_ambient_sound_multiplier"):
		return weather_system.get_ambient_sound_multiplier()
	return 1.0

func is_raining() -> bool:
	## Returns whether it's currently raining
	if weather_system and weather_system.has_method("is_raining"):
		return weather_system.is_raining()
	return false

func is_foggy() -> bool:
	## Returns whether it's currently foggy
	if weather_system and weather_system.has_method("is_foggy"):
		return weather_system.is_foggy()
	return false

func is_sunny() -> bool:
	## Returns whether it's currently sunny
	if weather_system and weather_system.has_method("is_sunny"):
		return weather_system.is_sunny()
	return false

func force_weather_change():
	## Forces a weather change (for debugging)
	if weather_system and weather_system.has_method("force_weather_change"):
		weather_system.force_weather_change()