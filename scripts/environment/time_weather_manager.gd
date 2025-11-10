extends Node2D

## Time and weather system manager for Buffalo Brook Gold Rush
## Sets up and manages time-based lighting and weather effects for the 2D game

# Reference to the time-based lighting system
var time_lighting: CanvasModulate = null

func _ready():
	## Initialize the time and weather management
	_setup_time_lighting()
	_connect_weather_effects()

func _setup_time_lighting():
	## Sets up the time-based lighting using CanvasModulate
	# Create or find the CanvasModulate node
	time_lighting = CanvasModulate.new()
	time_lighting.name = "TimeLightingModulator"
	
	# Add it to the scene tree (it will affect all child nodes)
	add_child(time_lighting)
	
	print("Time-based lighting system set up")

func _connect_weather_effects():
	## Connects weather effects to modify lighting based on weather
	# Try to connect to weather system to modify lighting based on weather
	if "Weather" in get_tree().root:
		var weather_autoload = get_tree().root.get_node("Weather")
		if weather_autoload and weather_autoload.has_method("get_weather_system"):
			var weather_system = weather_autoload.get_weather_system()
			if weather_system and weather_system.has_signal("weather_changed"):
				weather_system.weather_changed.connect(_on_weather_changed)
				print("Connected to weather system for lighting adjustments")
	elif has_node("/root/Main/WeatherSystem"):
		var weather_system = get_node("/root/Main/WeatherSystem")
		if weather_system and weather_system.has_signal("weather_changed"):
			weather_system.weather_changed.connect(_on_weather_changed)
			print("Connected to weather system for lighting adjustments")

func _on_weather_changed(_old_weather, _new_weather):
	## Adjusts lighting when weather changes
	if "Weather" in get_tree().root:
		var weather_autoload = get_tree().root.get_node("Weather")
		if weather_autoload and weather_autoload.has_method("get_weather_system"):
			var weather_system = weather_autoload.get_weather_system()
			if weather_system and weather_system.has_method("get_current_weather"):
				var current_weather = weather_system.get_current_weather()
				_apply_weather_lighting(current_weather)

func _apply_weather_lighting(weather_state: int):
	## Applies lighting adjustments based on weather
	if not time_lighting:
		return
	
	# Adjust the lighting based on weather state
	# Weather state: 0=Sunny, 1=Rainy, 2=Foggy
	match weather_state:
		0:  # Sunny - no adjustment needed, use time-based lighting
			print("Sunny weather - using time-based lighting")
		1:  # Rainy - make everything slightly darker and more blue/grey
			var current_color = time_lighting.color
			time_lighting.color = Color(
				current_color.r * 0.8,  # Darken slightly
				current_color.g * 0.8,
				current_color.b * 0.9,  # Add slight blue tint
				current_color.a
			)
			print("Rainy weather - adjusted lighting")
		2:  # Foggy - make everything more muted and grey
			var current_color = time_lighting.color
			var grey_factor = 0.7
			var brightness_factor = 0.6
			time_lighting.color = Color(
				lerp(current_color.r, 0.5, grey_factor) * brightness_factor,
				lerp(current_color.g, 0.5, grey_factor) * brightness_factor,
				lerp(current_color.b, 0.5, grey_factor) * brightness_factor,
				current_color.a
			)
			print("Foggy weather - adjusted lighting")

func _process(_delta: float):
	## This could be used for additional time-based effects if needed
	pass