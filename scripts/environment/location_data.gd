## Environment data structure for Buffalo Brook Gold Rush
## Defines properties for each location including gold rarity, difficulty, and travel connections

# Location IDs for easy reference
enum LocationID {
	BUFFALO_BROOK = 0,
	BROAD_BROOK = 1,
	METTAWEE_RIVER = 2
}

## Location data class
class LocationData:
	var id: LocationID
	var name: String
	var description: String
	var gold_rarity: float  # Gold rarity factor (1.0 = normal, >1.0 = more rare, <1.0 = more common)
	var difficulty: int     # Difficulty level (1-10)
	var travel_time: int    # Time in minutes to travel to this location
	var base_panning_time: float  # Base time for a panning session (seconds)
	var special_items: Array[String]  # Special items that can be found in this location
	var weather_effects: Dictionary  # Weather multipliers for this location
	var connections: Array[LocationID]  # Connected locations that can be traveled to
	
	# Visual and environmental properties
	var background_texture: String
	var water_color: Color
	var ambient_sound: String
	var season_variations: Dictionary  # Season-specific properties
	
	## Constructor
	func _init(p_id: LocationID, p_name: String, p_description: String):
		id = p_id
		name = p_name
		description = p_description
		gold_rarity = 1.0  # Default to normal
		difficulty = 5     # Default to medium
		travel_time = 10   # Default 10 minutes to travel
		base_panning_time = 30.0  # Default 30 seconds base panning time
		special_items = []
		weather_effects = {}
		connections = []
		background_texture = ""
		water_color = Color(0.3, 0.6, 1.0)  # Default blue water
		ambient_sound = ""
		season_variations = {}

## Predefined locations for the game
static func get_all_locations() -> Dictionary:
	var locations = {}
	
	# Buffalo Brook - Starting location, easier to find gold
	var buffalo_brook = LocationData.new(
		LocationID.BUFFALO_BROOK,
		"Buffalo Brook",
		"A beginner-friendly location with moderate gold density. Good for learning the panning techniques."
	)
	buffalo_brook.gold_rarity = 0.8  # More common gold (easier to find)
	buffalo_brook.difficulty = 3     # Easier difficulty
	buffalo_brook.travel_time = 5    # Quick travel from most locations
	buffalo_brook.special_items = ["Quartz", "Crystal"]
	buffalo_brook.water_color = Color(0.4, 0.7, 0.9)
	buffalo_brook.connections = [LocationID.BROAD_BROOK, LocationID.METTAWEE_RIVER]
	buffalo_brook.ambient_sound = "buffalo_brook_ambience"
	
	# Broad Brook - Moderate difficulty with good gold rewards
	var broad_brook = LocationData.new(
		LocationID.BROAD_BROOK,
		"Broad Brook",
		"A more challenging location with rocky terrain but better gold yields for experienced panners."
	)
	broad_brook.gold_rarity = 1.0  # Normal gold rarity
	broad_brook.difficulty = 5     # Medium difficulty
	broad_brook.travel_time = 12   # Moderate travel time
	broad_brook.special_items = ["Amethyst", "Historical Artifact"]
	broad_brook.water_color = Color(0.2, 0.5, 0.8)
	broad_brook.connections = [LocationID.BUFFALO_BROOK, LocationID.METTAWEE_RIVER]
	broad_brook.ambient_sound = "broad_brook_ambience"
	
	# Mettawee River - Most challenging with highest rewards
	var mettawee_river = LocationData.new(
		LocationID.METTAWEE_RIVER,
		"Mettawee River",
		"The most challenging location with the highest potential rewards for expert gold panners."
	)
	mettawee_river.gold_rarity = 1.5  # Less common gold (harder to find) but higher value when found
	mettawee_river.difficulty = 8     # High difficulty
	mettawee_river.travel_time = 20   # Longer travel time
	mettawee_river.special_items = ["Rare Crystal", "Ancient Coin", "Gem"]
	mettawee_river.water_color = Color(0.1, 0.4, 0.7)
	mettawee_river.connections = [LocationID.BUFFALO_BROOK, LocationID.BROAD_BROOK]
	mettawee_river.ambient_sound = "mettawee_river_ambience"
	
	locations[LocationID.BUFFALO_BROOK] = buffalo_brook
	locations[LocationID.BROAD_BROOK] = broad_brook
	locations[LocationID.METTAWEE_RIVER] = mettawee_river
	
	return locations

## Get a location by ID
static func get_location_by_id(location_id: LocationID) -> LocationData:
	var locations = get_all_locations()
	return locations.get(location_id, null)

## Get travel time between two locations
static func get_travel_time(from_location: LocationID, to_location: LocationID) -> int:
	var locations = get_all_locations()
	var from_data = locations.get(from_location, null)
	
	if from_data and from_data.connections.has(to_location):
		return from_data.travel_time
	else:
		return -1  # No direct path between locations

## Get connected locations
static func get_connected_locations(location_id: LocationID) -> Array[LocationID]:
	var locations = get_all_locations()
	var location_data = locations.get(location_id, null)
	
	if location_data:
		return location_data.connections
	else:
		return []

## Get gold rarity multiplier for a location
static func get_gold_rarity_multiplier(location_id: LocationID) -> float:
	var locations = get_all_locations()
	var location_data = locations.get(location_id, null)
	
	if location_data:
		return location_data.gold_rarity
	else:
		return 1.0  # Default if location not found

## Get difficulty for a location
static func get_difficulty(location_id: LocationID) -> int:
	var locations = get_all_locations()
	var location_data = locations.get(location_id, null)
	
	if location_data:
		return location_data.difficulty
	else:
		return 5  # Default if location not found