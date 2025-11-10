extends Node

## Weather audio manager for Buffalo Brook Gold Rush
## Handles ambient sound changes based on current weather conditions

# Reference to weather system
var weather_system: Node = null

# Audio players for different weather effects
@onready var rain_sound: AudioStreamPlayer = $RainSound
@onready var fog_sound: AudioStreamPlayer = $FogSound
@onready var general_ambience: AudioStreamPlayer = $GeneralAmbience

# Sound settings
var base_rain_volume: float = -15.0  # Base volume for rain (in dB)
var base_fog_volume: float = -20.0   # Base volume for fog ambience
var base_ambience_volume: float = -10.0  # Base volume for general ambience

# Current weather state
var current_weather_state: int = -1

func _ready():
	## Initialize the weather audio manager
	_connect_to_weather_system()
	_update_weather_sounds()

func _connect_to_weather_system():
	## Connects to the weather system to get weather change updates
	if "WeatherSystem" in get_tree().root:
		weather_system = get_tree().root.get_node("WeatherSystem")
		if weather_system and weather_system.has_signal("weather_changed"):
			weather_system.weather_changed.connect(_on_weather_changed)
			print("Weather audio manager connected to weather system")
			
			# Get initial weather state
			if weather_system.has_method("get_current_weather"):
				current_weather_state = weather_system.get_current_weather()
		elif weather_system and weather_system.has_signal("weather_effect_applied"):
			weather_system.weather_effect_applied.connect(_on_weather_changed_directly)
			print("Weather audio manager connected to weather system")
			
			# Get initial weather state
			if weather_system.has_method("get_current_weather"):
				current_weather_state = weather_system.get_current_weather()
	elif has_node("/root/Main/WeatherSystem"):
		weather_system = get_node("/root/Main/WeatherSystem")
		if weather_system and weather_system.has_signal("weather_changed"):
			weather_system.weather_changed.connect(_on_weather_changed)
			print("Weather audio manager connected to weather system")
			
			# Get initial weather state
			if weather_system.has_method("get_current_weather"):
				current_weather_state = weather_system.get_current_weather()
	else:
		print("WARNING: Weather audio manager could not connect to weather system")

func _on_weather_changed(_old_weather, new_weather):
	## Called when the weather system changes weather
	current_weather_state = new_weather
	_update_weather_sounds()

func _on_weather_changed_directly(weather_state):
	## Called when the weather system signals a weather effect
	current_weather_state = weather_state
	_update_weather_sounds()

func _update_weather_sounds():
	## Updates the ambient sounds based on current weather
	if not weather_system:
		_connect_to_weather_system()
		if not weather_system:
			return
	
	# Get weather sound multiplier from weather system
	var sound_multiplier = 1.0
	if weather_system.has_method("get_ambient_sound_multiplier"):
		sound_multiplier = weather_system.get_ambient_sound_multiplier()
	
	# Get precipitation intensity for rain effects
	var precipitation_intensity = 0.0
	if weather_system.has_method("get_precipitation_intensity"):
		precipitation_intensity = weather_system.get_precipitation_intensity()
	
	# Update sounds based on weather state
	match current_weather_state:
		0:  # SUNNY
			_set_rain_sound(false, 0.0)
			_set_fog_sound(false, 0.0)
			_set_general_ambience(true, base_ambience_volume)
		1:  # RAINY
			_set_rain_sound(true, base_rain_volume * sound_multiplier)
			_set_fog_sound(false, 0.0)
			_set_general_ambience(true, base_ambience_volume * 0.7)  # Slightly quieter during rain
		2:  # FOGGY
			_set_rain_sound(false, 0.0)  # Light precipitation is handled separately
			_set_fog_sound(true, base_fog_volume * sound_multiplier)
			_set_general_ambience(true, base_ambience_volume * 0.8)  # Muffled sounds in fog
	
	# Adjust rain intensity based on precipitation level
	if current_weather_state == 1 and precipitation_intensity > 0:
		var rain_volume = base_rain_volume * sound_multiplier * precipitation_intensity
		_set_rain_sound(true, rain_volume)

func _set_rain_sound(enabled: bool, volume_db: float):
	## Enables/disables rain sound and sets its volume
	if rain_sound:
		if enabled:
			rain_sound.volume_db = volume_db
			if not rain_sound.playing:
				rain_sound.play()
		else:
			rain_sound.stop()

func _set_fog_sound(enabled: bool, volume_db: float):
	## Enables/disables fog sound and sets its volume
	if fog_sound:
		if enabled:
			fog_sound.volume_db = volume_db
			if not fog_sound.playing:
				fog_sound.play()
		else:
			fog_sound.stop()

func _set_general_ambience(enabled: bool, volume_db: float):
	## Enables/disables general ambience and sets its volume
	if general_ambience:
		if enabled:
			general_ambience.volume_db = volume_db
			if not general_ambience.playing:
				general_ambience.play()
		else:
			general_ambience.stop()

func set_base_volumes(rain: float, fog: float, ambience: float):
	## Sets the base volumes for different weather sounds
	base_rain_volume = rain
	base_fog_volume = fog
	base_ambience_volume = ambience
	_update_weather_sounds()

func get_current_weather_state() -> int:
	## Returns the current weather state
	return current_weather_state

func is_raining() -> bool:
	## Returns whether it's currently raining
	return current_weather_state == 1

func is_foggy() -> bool:
	## Returns whether it's currently foggy
	return current_weather_state == 2

func is_sunny() -> bool:
	## Returns whether it's currently sunny
	return current_weather_state == 0