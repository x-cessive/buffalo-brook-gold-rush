## 24-hour in-game clock for Buffalo Brook Gold Rush
## Manages the game time and signals time-based events

extends Node
class_name TimeClock

# Time-related enums and constants
enum TimeOfDay {
	MIDNIGHT = 0,      # 0:00 - 2:59
	DAWN = 1,          # 3:00 - 5:59
	MORNING = 2,       # 6:00 - 8:59
	MIDDAY = 3,        # 9:00 - 11:59
	AFTERNOON = 4,     # 12:00 - 14:59
	PM = 5,            # 15:00 - 17:59
	EVENING = 6,       # 18:00 - 20:59
	NIGHT = 7          # 21:00 - 23:59
}

# Clock speed multiplier (1.0 = real-time, higher = faster)
const DEFAULT_SPEED = 1.0
const DAY_DURATION_IN_SECONDS = 600.0  # 10 minutes for a full day in the game (adjustable)

# Signals for time events
signal time_changed(old_time, new_time)
signal hour_changed(old_hour, new_hour)
signal day_advanced(day_number)
signal time_of_day_changed(time_of_day)

# Current time tracking
var current_hour: int = 8  # Start at 8 AM
var current_minute: int = 0
var current_second: float = 0.0
var day_number: int = 1

# Time progression settings
var time_speed: float = DEFAULT_SPEED
var is_paused: bool = false

# Time of day tracking
var current_time_of_day: TimeOfDay = TimeOfDay.MORNING

# Time tracking for delta calculations
var last_update_time: float = 0.0

func _ready():
	## Initialize the clock system
	last_update_time = Time.get_ticks_msec() / 1000.0
	print("Clock system initialized. Time: " + get_formatted_time())

func _process(delta: float):
	## Update the game time if not paused
	if not is_paused:
		_update_time(delta * time_speed)

func _update_time(delta: float):
	## Updates the current game time based on delta
	var seconds_to_add = delta
	current_second += seconds_to_add
	
	# Convert seconds to minutes if needed
	while current_second >= 60.0:
		current_second -= 60.0
		current_minute += 1
		
		# Convert minutes to hours if needed
		if current_minute >= 60:
			var old_hour = current_hour
			var old_time_of_day = current_time_of_day
			
			current_minute = 0
			current_hour = (current_hour + 1) % 24
			
			# Emit signal if hour changed
			emit_signal("hour_changed", old_hour, current_hour)
			
			# Update time of day
			_update_time_of_day()
			
			# If we've completed a full day
			if current_hour == 0 and old_hour == 23:
				day_number += 1
				emit_signal("day_advanced", day_number)

	# Emit time change signal periodically (every 15 seconds in game time)
	if int(current_second) % 15 == 0:
		var old_time = str(old_hour) + ":" + str(old_minute).pad_zeros(2) if 'old_hour' in get_script().get_script_property_list() else get_formatted_time()
		emit_signal("time_changed", old_time, get_formatted_time())

func _update_time_of_day():
	## Updates the time of day based on the current hour
	var new_time_of_day = get_time_of_day_from_hour(current_hour)
	
	if new_time_of_day != current_time_of_day:
		var old_time_of_day = current_time_of_day
		current_time_of_day = new_time_of_day
		emit_signal("time_of_day_changed", old_time_of_day, new_time_of_day)

static func get_time_of_day_from_hour(hour: int) -> TimeOfDay:
	## Returns the time of day based on the given hour
	if hour >= 21 or hour <= 2:  # 9 PM to 2 AM (Night)
		return TimeOfDay.NIGHT
	elif hour >= 3 and hour <= 5:  # 3 AM to 5 AM (Dawn)
		return TimeOfDay.DAWN
	elif hour >= 6 and hour <= 8:  # 6 AM to 8 AM (Morning)
		return TimeOfDay.MORNING
	elif hour >= 9 and hour <= 11:  # 9 AM to 11 AM (Midday)
		return TimeOfDay.MIDDAY
	elif hour >= 12 and hour <= 14:  # 12 PM to 2 PM (Afternoon)
		return TimeOfDay.AFTERNOON
	elif hour >= 15 and hour <= 17:  # 3 PM to 5 PM (PM)
		return TimeOfDay.PM
	elif hour >= 18 and hour <= 20:  # 6 PM to 8 PM (Evening)
		return TimeOfDay.EVENING
	else:  # Fallback
		return TimeOfDay.NIGHT

func get_formatted_time() -> String:
	## Returns the current time in HH:MM format
	return str(current_hour).pad_zeros(2) + ":" + str(current_minute).pad_zeros(2)

func get_time_percentage() -> float:
	## Returns the current time as a percentage of the day (0.0 to 1.0)
	# 0% = 0:00, 50% = 12:00, 100% = 23:59
	return (current_hour * 60 + current_minute) / (24.0 * 60.0)

func get_total_minutes() -> int:
	## Returns the total minutes since day 0
	return (day_number - 1) * 24 * 60 + current_hour * 60 + current_minute

func get_current_time_of_day() -> TimeOfDay:
	## Returns the current time of day
	return current_time_of_day

func pause_time():
	## Pauses the in-game time
	is_paused = true

func resume_time():
	## Resumes the in-game time
	is_paused = false

func set_time_speed(speed: float):
	## Sets the speed of time passage
	time_speed = speed

func get_time_speed() -> float:
	## Returns the current time speed
	return time_speed

func advance_time(hours: int, minutes: int = 0):
	## Manually advances the time by the specified amount (for testing)
	var total_minutes = hours * 60 + minutes
	for i in range(total_minutes):
		current_minute += 1
		if current_minute >= 60:
			current_minute = 0
			current_hour = (current_hour + 1) % 24
			_update_time_of_day()
			
			# If we've completed a full day
			if current_hour == 0 and hours != 0:
				day_number += 1
	
	emit_signal("time_changed", get_formatted_time(), get_formatted_time())

func set_time(hour: int, minute: int = 0):
	## Sets the time to a specific value (for testing/debugging)
	if hour >= 0 and hour < 24:
		var old_hour = current_hour
		var old_time_of_day = current_time_of_day
		
		current_hour = hour
		current_minute = minute
		_update_time_of_day()
		
		# Emit appropriate signals
		if old_hour != current_hour:
			emit_signal("hour_changed", old_hour, current_hour)
		
		var new_time_of_day = current_time_of_day
		if old_time_of_day != new_time_of_day:
			emit_signal("time_of_day_changed", old_time_of_day, new_time_of_day)
		
		emit_signal("time_changed", str(old_hour).pad_zeros(2) + ":" + str(minute).pad_zeros(2), get_formatted_time())

func get_current_hour() -> int:
	## Returns the current hour
	return current_hour

func get_current_minute() -> int:
	## Returns the current minute
	return current_minute

func get_day_number() -> int:
	## Returns the current day number
	return day_number

func is_daytime() -> bool:
	## Returns whether it's currently daytime (6 AM to 8 PM)
	return current_hour >= 6 and current_hour < 21

func is_nighttime() -> bool:
	## Returns whether it's currently nighttime (8 PM to 6 AM)
	return current_hour >= 21 or current_hour < 6

func get_time_of_day_name() -> String:
	## Returns the name of the current time of day
	match current_time_of_day:
		TimeOfDay.MIDNIGHT: return "Midnight"
		TimeOfDay.DAWN: return "Dawn"
		TimeOfDay.MORNING: return "Morning"
		TimeOfDay.MIDDAY: return "Midday"
		TimeOfDay.AFTERNOON: return "Afternoon"
		TimeOfDay.PM: return "PM"
		TimeOfDay.EVENING: return "Evening"
		TimeOfDay.NIGHT: return "Night"
		_: return "Unknown"

# Debug functions
func debug_advance_hour():
	## Debug function to advance time by one hour
	advance_time(1)

func debug_set_dawn():
	## Debug function to set time to dawn (5 AM)
	set_time(5, 0)

func debug_set_noon():
	## Debug function to set time to noon (12 PM)
	set_time(12, 0)

func debug_set_dusk():
	## Debug function to set time to dusk (7 PM)
	set_time(19, 0)

func debug_set_midnight():
	## Debug function to set time to midnight (12 AM)
	set_time(0, 0)