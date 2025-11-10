extends Node

## Time clock autoload for Buffalo Brook Gold Rush
## Makes the time system globally accessible

# Singleton instance of time clock
var time_clock: Node = null

func _ready():
	## Initialize the time clock autoload
	_initialize_time_clock()

func _initialize_time_clock():
	## Creates and initializes the time clock system
	time_clock = preload("res://scripts/environment/time_clock.tscn").instantiate()
	if time_clock:
		add_child(time_clock)
		print("Time clock system loaded and initialized")
	else:
		print("ERROR: Could not load time clock system")

func get_time_clock() -> Node:
	## Returns the time clock instance
	return time_clock

# Proxy methods to make time functions easily accessible
func get_formatted_time() -> String:
	## Returns the current time in HH:MM format
	if time_clock and time_clock.has_method("get_formatted_time"):
		return time_clock.get_formatted_time()
	return "00:00"

func get_current_hour() -> int:
	## Returns the current hour
	if time_clock and time_clock.has_method("get_current_hour"):
		return time_clock.get_current_hour()
	return 0

func get_current_minute() -> int:
	## Returns the current minute
	if time_clock and time_clock.has_method("get_current_minute"):
		return time_clock.get_current_minute()
	return 0

func get_current_time_of_day() -> int:
	## Returns the current time of day
	if time_clock and time_clock.has_method("get_current_time_of_day"):
		return time_clock.get_current_time_of_day()
	return 0

func get_day_number() -> int:
	## Returns the current day number
	if time_clock and time_clock.has_method("get_day_number"):
		return time_clock.get_day_number()
	return 1

func is_daytime() -> bool:
	## Returns whether it's currently daytime
	if time_clock and time_clock.has_method("is_daytime"):
		return time_clock.is_daytime()
	return true

func is_nighttime() -> bool:
	## Returns whether it's currently nighttime
	if time_clock and time_clock.has_method("is_nighttime"):
		return time_clock.is_nighttime()
	return false

func get_time_of_day_name() -> String:
	## Returns the name of the current time of day
	if time_clock and time_clock.has_method("get_time_of_day_name"):
		return time_clock.get_time_of_day_name()
	return "Unknown"

func get_time_percentage() -> float:
	## Returns the current time as a percentage of the day
	if time_clock and time_clock.has_method("get_time_percentage"):
		return time_clock.get_time_percentage()
	return 0.0

func set_time_speed(speed: float):
	## Sets the speed of time passage
	if time_clock and time_clock.has_method("set_time_speed"):
		time_clock.set_time_speed(speed)

func pause_time():
	## Pauses the in-game time
	if time_clock and time_clock.has_method("pause_time"):
		time_clock.pause_time()

func resume_time():
	## Resumes the in-game time
	if time_clock and time_clock.has_method("resume_time"):
		time_clock.resume_time()