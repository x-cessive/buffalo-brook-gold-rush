extends Node

## Economy system for Buffalo Brook Gold Rush
## Handles daily price fluctuations and market dynamics

# Signals for economy events
signal day_advanced(new_day)
signal prices_changed

# Base prices for items (in gold)
var BASE_PRICES = {
	"Gold Flake": 5,
	"Gold Nugget": 20,
	"Crystal": 15,
	"Amethyst": 25,
	"Basic Pan": 25,
	"Wooden Pan": 50,
	"Repair Kit": 30,
	"Upgrade Component": 40,
	"Quartz": 10,
	"Historical Artifact": 100
}

# Price fluctuation parameters
const FLUCTUATION_FACTOR = 0.3  # 30% max fluctuation
const SEASONAL_FACTOR = 0.2     # 20% seasonal influence
const DEMAND_FACTOR = 0.15      # 15% demand/supply influence

# Current day and market state
var current_day: int = 1
var current_prices: Dictionary = {}
var market_history: Array[Dictionary] = []  # Store price history for analysis

# Random number generator for price fluctuations
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	## Initialize the economy system
	rng.randomize()
	_generate_daily_prices()
	print("Economy system initialized - Day " + str(current_day))

func advance_day():
	## Advances to the next day and recalculates prices
	current_day += 1
	
	# Store yesterday's prices in history
	var yesterday_prices = current_prices.duplicate(true)
	market_history.append({
		"day": current_day - 1,
		"prices": yesterday_prices,
		"timestamp": Time.get_unix_time_from_system()
	})
	
	# Limit history to last 30 days to prevent memory issues
	if market_history.size() > 30:
		market_history.pop_front()
	
	# Generate new prices for the day
	_generate_daily_prices()
	
	emit_signal("day_advanced", current_day)
	emit_signal("prices_changed")
	
	print("Advanced to day " + str(current_day) + ", prices updated")

func _generate_daily_prices():
	## Generates new daily prices based on base prices and fluctuations
	current_prices.clear()
	
	for item_name in BASE_PRICES:
		current_prices[item_name] = _calculate_item_price(item_name, BASE_PRICES[item_name])

func _calculate_item_price(item_name: String, base_price: int) -> int:
	## Calculates the current price for an item based on various factors
	var fluctuation = _generate_price_fluctuation(item_name)
	
	# Apply seasonal variations (could be based on season data if connected to seasonal system)
	var seasonal_modifier = _get_seasonal_modifier(item_name)
	
	# Apply demand/supply factors (simplified - in a full game, this would track supply and demand)
	var demand_modifier = _get_demand_modifier(item_name, base_price)
	
	# Calculate final price
	var final_price = base_price * (1.0 + fluctuation) * seasonal_modifier * demand_modifier
	
	# Ensure minimum price of 1
	return max(1, int(final_price))

func _generate_price_fluctuation(item_name: String) -> float:
	## Generates random price fluctuation for an item
	# Use the item name for consistent fluctuations (same item will have similar fluctuations each day if we used a fixed seed)
	var seed = hash(item_name + str(current_day))
	rng.seed = seed
	
	# Generate fluctuation within bounds
	var fluctuation = rng.randfn(0.0, FLUCTUATION_FACTOR)
	
	# Randomly make it positive or negative
	if rng.randf() < 0.5:
		fluctuation = -fluctuation
	
	return fluctuation

func _get_seasonal_modifier(item_name: String) -> float:
	## Returns seasonal modifier for an item (in a full game, this would be connected to seasonal system)
	# For now, using a simple seasonal pattern based on day
	var season_cycle = float(current_day % 365) / 365.0 * 2 * PI
	var seasonal_factor = 1.0 + (SEASONAL_FACTOR * sin(season_cycle))
	return seasonal_factor

func _get_demand_modifier(item_name: String, base_price: int) -> float:
	## Returns demand/supply modifier for an item (simplified version)
	# In a full game, this would track actual demand and supply
	var demand_factor = 1.0 + (DEMAND_FACTOR * (rng.randf() - 0.5))
	return demand_factor

func get_item_price(item_name: String, is_buying: bool = true) -> int:
	## Returns the current price for an item (buying or selling price)
	var base_price = current_prices.get(item_name, BASE_PRICES.get(item_name, 10))
	
	# If selling, apply a lower price (shop buy-back rate)
	if not is_buying:
		return int(base_price * 0.7)  # Shop buys back at 70% of selling price
	
	return base_price

func get_current_day() -> int:
	## Returns the current day
	return current_day

func get_current_prices() -> Dictionary:
	## Returns a copy of the current prices
	return current_prices.duplicate(true)

func get_base_price(item_name: String) -> int:
	## Returns the base (unmodified) price for an item
	return BASE_PRICES.get(item_name, 10)

func get_price_history(item_name: String, days: int = 7) -> Array:
	## Returns price history for an item for the specified number of days
	var history = []
	var days_to_check = min(days, market_history.size())
	
	for i in range(days_to_check):
		var day_data = market_history[market_history.size() - 1 - i]
		if day_data.prices.has(item_name):
			history.append({
				"day": day_data.day,
				"price": day_data.prices[item_name],
				"timestamp": day_data.timestamp
			})
	
	return history

func get_price_trend(item_name: String, days: int = 7) -> float:
	## Returns the price trend for an item over specified days (positive = rising, negative = falling)
	var history = get_price_history(item_name, days)
	if history.size() < 2:
		return 0.0  # Not enough data
	
	var first_price = history[0].price
	var last_price = history[history.size() - 1].price
	
	if first_price == 0:
		return 0.0
	
	return (float(last_price - first_price) / first_price) * 100

func get_market_volatility() -> float:
	## Returns overall market volatility based on recent price changes
	if market_history.size() < 2:
		return 0.0
	
	var total_volatility = 0.0
	var day_count = 0
	
	for i in range(1, market_history.size()):
		var prev_day = market_history[i-1]
		var curr_day = market_history[i]
		
		var day_volatility = 0.0
		for item_name in BASE_PRICES:
			if prev_day.prices.has(item_name) and curr_day.prices.has(item_name):
				var prev_price = prev_day.prices[item_name]
				var curr_price = curr_day.prices[item_name]
				
				if prev_price > 0:
					day_volatility += abs(float(curr_price - prev_price) / prev_price)
		
		total_volatility += day_volatility
		day_count += 1
	
	if day_count > 0:
		return (total_volatility / day_count) * 100
	else:
		return 0.0

func reset_market():
	## Resets the market to day 1 with original prices
	current_day = 1
	market_history.clear()
	_generate_daily_prices()
	emit_signal("day_advanced", current_day)
	emit_signal("prices_changed")
	print("Market reset to day 1")

func force_price_update():
	## Forces an immediate price update without advancing the day
	_generate_daily_prices()
	emit_signal("prices_changed")
	print("Prices updated without advancing day")

func get_market_summary() -> Dictionary:
	## Returns a summary of market conditions
	return {
		"day": current_day,
		"volatility": get_market_volatility(),
		"total_items_tracked": BASE_PRICES.size(),
		"active_history_days": market_history.size()
	}

# This method allows external systems to add new items to the market
func add_item_to_market(item_name: String, base_price: int):
	## Adds a new item to the market with a base price
	if not BASE_PRICES.has(item_name):
		BASE_PRICES[item_name] = base_price
		print("Added " + item_name + " to market with base price " + str(base_price))