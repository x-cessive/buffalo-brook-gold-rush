extends Node

## Economy autoload for Buffalo Brook Gold Rush
## Makes the economy system globally accessible

# Singleton instance of economy system
var economy_system: Node = null

func _ready():
	## Initialize the economy autoload
	_initialize_economy_system()

func _initialize_economy_system():
	## Creates and initializes the economy system
	economy_system = preload("res://scripts/economy/economy_system.tscn").instantiate()
	if economy_system:
		add_child(economy_system)
		print("Economy system loaded and initialized")
	else:
		print("ERROR: Could not load economy system")

func get_economy_system() -> Node:
	## Returns the economy system instance
	return economy_system

# Proxy methods to make economy functions easily accessible
func advance_day():
	## Advances to the next day and recalculates prices
	if economy_system and economy_system.has_method("advance_day"):
		economy_system.advance_day()

func get_item_price(item_name: String, is_buying: bool = true) -> int:
	## Returns the current price for an item
	if economy_system and economy_system.has_method("get_item_price"):
		return economy_system.get_item_price(item_name, is_buying)
	return 10  # Default price if system not available

func get_current_day() -> int:
	## Returns the current day
	if economy_system and economy_system.has_method("get_current_day"):
		return economy_system.get_current_day()
	return 1

func get_current_prices() -> Dictionary:
	## Returns a copy of the current prices
	if economy_system and economy_system.has_method("get_current_prices"):
		return economy_system.get_current_prices()
	return {}

func get_price_history(item_name: String, days: int = 7) -> Array:
	## Returns price history for an item
	if economy_system and economy_system.has_method("get_price_history"):
		return economy_system.get_price_history(item_name, days)
	return []

func get_price_trend(item_name: String, days: int = 7) -> float:
	## Returns the price trend for an item
	if economy_system and economy_system.has_method("get_price_trend"):
		return economy_system.get_price_trend(item_name, days)
	return 0.0

func get_market_volatility() -> float:
	## Returns overall market volatility
	if economy_system and economy_system.has_method("get_market_volatility"):
		return economy_system.get_market_volatility()
	return 0.0