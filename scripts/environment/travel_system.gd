extends Node

## Travel system for Buffalo Brook Gold Rush
## Manages travel between different locations and handles travel-related mechanics

# Load location data
const LocationDataScript = preload("res://scripts/environment/location_data.gd")

# Signals for travel events
signal travel_started(from_location, to_location, travel_time)
signal travel_in_progress(progress, time_remaining)
signal travel_completed(from_location, to_location)
signal location_changed(new_location)

# Current player location
var current_location: LocationDataScript.LocationID = LocationDataScript.LocationID.BUFFALO_BROOK

# Travel state variables
var is_traveling: bool = false
var travel_destination: LocationDataScript.LocationID = LocationDataScript.LocationID.BUFFALO_BROOK
var travel_start_time: float = 0.0
var total_travel_time: float = 0.0

# Travel costs (if any)
var travel_cost: int = 0  # Cost in gold to travel (optional)

func _ready():
	## Initialize the travel system
	print("Travel system initialized. Current location: " + str(current_location))

func travel_to_location(destination: LocationDataScript.LocationID) -> bool:
	## Starts travel to a new location
	# Check if destination is connected to current location
	var connected_locations = LocationDataScript.get_connected_locations(current_location)
	if not connected_locations.has(destination):
		print("Cannot travel to " + LocationDataScript.get_location_by_id(destination).name + 
		      " from current location. No direct path.")
		return false
	
	# Check if player can afford travel (if there's a cost)
	if travel_cost > 0:
		# Assuming we have access to inventory system
		var inventory = _get_inventory_system()
		if inventory and inventory.get_gold() < travel_cost:
			print("Not enough gold to travel. Need: " + str(travel_cost) + ", Have: " + str(inventory.get_gold()))
			return false
	
	# Get travel time for this route
	var travel_time_minutes = LocationDataScript.get_travel_time(current_location, destination)
	if travel_time_minutes <= 0:
		print("Invalid travel time to destination")
		return false
	
	# Convert to seconds for game processing
	total_travel_time = travel_time_minutes * 60.0
	travel_start_time = Time.get_ticks_msec() / 1000.0
	travel_destination = destination
	is_traveling = true
	
	emit_signal("travel_started", current_location, destination, total_travel_time)
	
	# If there's an inventory system, remove travel cost
	if travel_cost > 0 and inventory:
		inventory.remove_gold(travel_cost)
	
	print("Travel started to " + LocationDataScript.get_location_by_id(destination).name + 
	      " (ETA: " + str(travel_time_minutes) + " minutes)")
	
	return true

func _process(_delta: float):
	## Process travel during gameplay
	if is_traveling:
		var current_time = Time.get_ticks_msec() / 1000.0
		var elapsed_time = current_time - travel_start_time
		var remaining_time = max(0.0, total_travel_time - elapsed_time)
		
		# Calculate progress (0.0 to 1.0)
		var progress = min(1.0, elapsed_time / total_travel_time)
		
		emit_signal("travel_in_progress", progress, remaining_time)
		
		if elapsed_time >= total_travel_time:
			complete_travel()

func complete_travel():
	## Completes the travel and updates player location
	if is_traveling:
		var previous_location = current_location
		current_location = travel_destination
		
		is_traveling = false
		travel_destination = LocationDataScript.LocationID.BUFFALO_BROOK  # Reset
		
		# Update any location-specific systems
		emit_signal("travel_completed", previous_location, current_location)
		emit_signal("location_changed", current_location)
		
		print("Travel completed! Arrived at " + LocationDataScript.get_location_by_id(current_location).name)

func cancel_travel():
	## Cancels the current travel
	if is_traveling:
		is_traveling = false
		emit_signal("travel_in_progress", 0.0, 0.0)  # Reset progress
		print("Travel cancelled")

func get_current_location() -> LocationDataScript.LocationID:
	## Returns the current location ID
	return current_location

func get_current_location_name() -> String:
	## Returns the current location name
	var location_data = LocationDataScript.get_location_by_id(current_location)
	if location_data:
		return location_data.name
	return "Unknown Location"

func get_current_location_data() -> LocationDataScript.LocationData:
	## Returns the current location data
	return LocationDataScript.get_location_by_id(current_location)

func is_at_location(location_id: LocationDataScript.LocationID) -> bool:
	## Checks if the player is currently at a specific location
	return current_location == location_id

func force_location_change(new_location: LocationDataScript.LocationID):
	## Forces a location change without travel (for debug or special cases)
	if current_location != new_location:
		var old_location = current_location
		current_location = new_location
		emit_signal("location_changed", current_location)
		print("Location changed from " + LocationDataScript.get_location_by_id(old_location).name + 
		      " to " + LocationDataScript.get_location_by_id(new_location).name)

func get_connected_locations() -> Array[LocationDataScript.LocationID]:
	## Returns the locations connected to the current location
	return LocationDataScript.get_connected_locations(current_location)

func get_travel_progress() -> Dictionary:
	## Returns information about the current travel
	if not is_traveling:
		return {
			"is_traveling": false,
			"progress": 0.0,
			"time_remaining": 0.0,
			"destination": null
		}
	
	var current_time = Time.get_ticks_msec() / 1000.0
	var elapsed_time = current_time - travel_start_time
	var remaining_time = max(0.0, total_travel_time - elapsed_time)
	var progress = min(1.0, elapsed_time / total_travel_time)
	
	return {
		"is_traveling": true,
		"progress": progress,
		"time_remaining": remaining_time,
		"destination": travel_destination,
		"destination_name": LocationDataScript.get_location_by_id(travel_destination).name
	}

func _get_inventory_system() -> Node:
	## Helper function to get the inventory system
	if "Inventory" in get_tree().root:
		return get_tree().root.get_node("Inventory")
	elif has_node("/root/Main/Inventory"):
		return get_node("/root/Main/Inventory")
	else:
		print("WARNING: Could not find inventory system for travel cost deduction")
		return null

func set_travel_cost(cost: int):
	## Sets the gold cost for traveling
	travel_cost = cost
	print("Travel cost set to: " + str(cost) + " gold")

func get_location_description(location_id: LocationDataScript.LocationID) -> String:
	## Returns the description for a location
	var location_data = LocationDataScript.get_location_by_id(location_id)
	if location_data:
		return location_data.description
	return "No description available"

func get_location_travel_time(location_id: LocationDataScript.LocationID) -> int:
	## Returns the travel time to a location from current position
	return LocationDataScript.get_travel_time(current_location, location_id)

func can_travel_to_location(location_id: LocationDataScript.LocationID) -> bool:
	## Checks if the player can travel to a location
	var connected_locations = get_connected_locations()
	return connected_locations.has(location_id)

# Debug functions for testing
func debug_teleport_to_location(location_id: LocationDataScript.LocationID):
	## Debug function to instantly teleport to a location
	force_location_change(location_id)
	print("DEBUG: Teleported to " + LocationDataScript.get_location_by_id(location_id).name)