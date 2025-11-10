## Location properties data structure for Buffalo Brook Gold Rush
## Contains information about each location including difficulty, name, and other properties

# Load location probability tables
const LocationTables = preload("res://resources/data/location_probability_tables.gd")

## Location data structure
class LocationData:
	var name: String
	var difficulty: LocationTables.LocationDifficulty
	var description: String
	var gold_density: float  # Base gold density (0.0 to 1.0)
	var special_finds_rate: float  # Probability of finding special items (0.0 to 1.0)
	var accessibility: int  # Difficulty level for reaching the location (1-5)
	var unique_features: Array[String]  # Special features of this location
	var seasonal_modifiers: Dictionary  # Modifiers for different seasons
	
	func _init(p_name: String, p_difficulty: LocationTables.LocationDifficulty, p_description: String):
		name = p_name
		difficulty = p_difficulty
		description = p_description
		gold_density = LocationTables.LOCATION_PROBABILITY_TABLE[difficulty] / 1.8  # Normalize to 0-1
		special_finds_rate = LocationTables.LOCATION_SPECIAL_FIND_TABLE[difficulty]
		accessibility = difficulty as int + 1  # Convert enum to int-based accessibility
		unique_features = []
		seasonal_modifiers = {}

## Predefined locations for the game
var LOCATIONS = {
	"brookside_camp": LocationData.new(
		"Brookside Camp", 
		LocationTables.LocationDifficulty.VERY_EASY,
		"A beginner-friendly spot near the old campsite. Abundant gold deposits with less sediment to sift through."
	),
	
	"maple_ridge_stream": LocationData.new(
		"Maple Ridge Stream",
		LocationTables.LocationDifficulty.EASY,
		"A pleasant location with good gold density. Marked by large maple trees that provide shade during panning."
	),
	
	"granite_falls": LocationData.new(
		"Granite Falls",
		LocationTables.LocationDifficulty.MODERATE,
		"A more challenging location with moderate gold density. Features a small waterfall and rocky terrain."
	),
	
	"cedar_creek": LocationData.new(
		"Cedar Creek",
		LocationTables.LocationDifficulty.DIFFICULT,
		"A difficult location with rocky terrain and lower gold density. Requires patience and good technique."
	),
	
	"hidden_valley": LocationData.new(
		"Hidden Valley",
		LocationTables.LocationDifficulty.VERY_DIFFICULT,
		"The most challenging location with the lowest gold density. But the gold found here is of exceptional quality."
	)
}

## Function to get a location by name
func get_location_by_name(name: String) -> LocationData:
	return LOCATIONS.get(name, null)

## Function to get all location names
func get_all_location_names() -> Array:
	return LOCATIONS.keys()

## Function to get locations by difficulty range
func get_locations_by_difficulty(min_difficulty: LocationTables.LocationDifficulty, 
                                max_difficulty: LocationTables.LocationDifficulty) -> Array:
	var matching_locations = []
	for location_name in LOCATIONS:
		var location = LOCATIONS[location_name]
		if location.difficulty >= min_difficulty and location.difficulty <= max_difficulty:
			matching_locations.append(location_name)
	return matching_locations

## Example usage:
# var location_data = LOCATIONS["brookside_camp"]
# print("Location: " + location_data.name)
# print("Difficulty: " + str(location_data.difficulty))
# print("Gold density: " + str(location_data.gold_density))