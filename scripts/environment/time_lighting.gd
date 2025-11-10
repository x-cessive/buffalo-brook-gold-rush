extends CanvasModulate

## Time-based lighting system for Buffalo Brook Gold Rush
## Fades lighting and changes ambient colors based on in-game time

# Load the time clock
const TimeClock = preload("res://scripts/environment/time_clock.gd")

# Reference to the time system
var time_system: Node = null

# Lighting parameters for different times of day
# Format: [brightness_multiplier, r, g, b] - where brightness is 0.0 to 1.0 and RGB are 0.0 to 1.0
const LIGHTING_BY_TIME_OF_DAY = {
	TimeClock.TimeOfDay.MIDNIGHT: [0.2, 0.1, 0.1, 0.3],      # Dark blue-tinted night
	TimeClock.TimeOfDay.DAWN: [0.4, 0.4, 0.3, 0.6],          # Purple/blue dawn
	TimeClock.TimeOfDay.MORNING: [0.7, 0.8, 0.7, 0.4],        # Warm morning light
	TimeClock.TimeOfDay.MIDDAY: [1.0, 1.0, 1.0, 1.0],         # Full bright daylight
	TimeClock.TimeOfDay.AFTERNOON: [0.95, 0.95, 0.85, 0.7],   # Slightly warm afternoon
	TimeClock.TimeOfDay.PM: [0.8, 0.9, 0.7, 0.5],             # Warm afternoon
	TimeClock.TimeOfDay.EVENING: [0.5, 0.8, 0.5, 0.2],        # Orange evening
	TimeClock.TimeOfDay.NIGHT: [0.25, 0.2, 0.2, 0.4]          # Dark blue-tinted night
}

# Current lighting values
var current_brightness: float = 1.0
var current_color: Color = Color.WHITE

# Smooth transition parameters
var transition_speed: float = 0.5  # How fast lighting changes (lower = smoother)
var target_brightness: float = 1.0
var target_color: Color = Color.WHITE

# For smooth transitions
var lerp_factor: float = 0.0

func _ready():
	## Initialize the time-based lighting system
	_connect_to_time_system()
	
	# Set initial lighting based on current time
	_update_lighting_for_current_time()

func _connect_to_time_system():
	## Connects to the time system to get time updates
	if "TimeClock" in get_tree().root:
		time_system = get_tree().root.get_node("TimeClock")
		if time_system:
			time_system.time_of_day_changed.connect(_on_time_of_day_changed)
			time_system.time_changed.connect(_on_time_changed)
			print("Time-based lighting connected to time system")
	elif has_node("/root/Main/TimeClock"):
		time_system = get_node("/root/Main/TimeClock")
		if time_system:
			time_system.time_of_day_changed.connect(_on_time_of_day_changed)
			time_system.time_changed.connect(_on_time_changed)
			print("Time-based lighting connected to time system")
	else:
		print("WARNING: Time-based lighting could not connect to time system")

func _on_time_of_day_changed(_old_time_of_day, new_time_of_day):
	## Called when the time of day changes
	_update_target_lighting(new_time_of_day)

func _on_time_changed(_old_time, _new_time):
	## Called when the time changes (for smooth transitions)
	# This can be used for gradual lighting changes throughout the hour
	pass

func _update_target_lighting(time_of_day: int):
	## Updates the target lighting based on the time of day
	if LIGHTING_BY_TIME_OF_DAY.has(time_of_day):
		var lighting_data = LIGHTING_BY_TIME_OF_DAY[time_of_day]
		target_brightness = lighting_data[0]
		target_color = Color(lighting_data[1], lighting_data[2], lighting_data[3], 1.0)
		
		print("Time of day changed, updating lighting: Brightness=" + str(target_brightness) + 
		      ", Color=" + str(target_color))

func _update_lighting_for_current_time():
	## Updates lighting based on the current time of day
	if not time_system:
		_connect_to_time_system()
		if not time_system:
			return
	
	var current_time_of_day = TimeClock.get_time_of_day_from_hour(time_system.get_current_hour())
	_update_target_lighting(current_time_of_day)
	
	# Set immediately for the first update
	current_brightness = target_brightness
	current_color = target_color
	_apply_lighting()

func _process(_delta: float):
	## Smoothly transitions between lighting states
	# Lerp toward target values
	current_brightness = lerp(current_brightness, target_brightness, _delta * transition_speed)
	current_color = current_color.lerp(target_color, _delta * transition_speed)
	
	_apply_lighting()

func _apply_lighting():
	## Applies the current lighting to the CanvasModulate node
	var final_color = Color(
		current_color.r * current_brightness,
		current_color.g * current_brightness, 
		current_color.b * current_brightness,
		current_color.a
	)
	
	self.color = final_color

# Public methods to adjust lighting parameters
func set_transition_speed(speed: float):
	## Sets how fast lighting changes (lower = smoother)
	transition_speed = speed

func get_current_lighting_info() -> Dictionary:
	## Returns current lighting information
	return {
		"brightness": current_brightness,
		"color": current_color,
		"target_brightness": target_brightness,
		"target_color": target_color
	}

# Additional methods for fine-tuning
func adjust_brightness_for_weather(weather_state: int) -> float:
	## Adjusts brightness based on current weather (can be called from weather system)
	# Weather state: 0=Sunny, 1=Rainy, 2=Foggy
	match weather_state:
		1:  # Rainy
			return current_brightness * 0.8  # Reduce brightness by 20%
		2:  # Foggy
			return current_brightness * 0.6  # Reduce brightness by 40%
		_:  # Sunny or other
			return current_brightness

func apply_weather_adjustment(weather_state: int):
	## Applies weather-based lighting adjustment
	var adjusted_brightness = adjust_brightness_for_weather(weather_state)
	self.color = Color(
		current_color.r * adjusted_brightness,
		current_color.g * adjusted_brightness, 
		current_color.b * adjusted_brightness,
		current_color.a
	)