## Tool data structure for Buffalo Brook Gold Rush
## Defines the properties for tools including durability and upgrade levels

# Tool types definition
enum ToolType {
	BASIC_PAN = 0,
	WOODEN_PAN = 1,
	PROFESSIONAL_PAN = 2,
	SLUICE_BOX = 3,
	GOLD_MINE_KIT = 4,
	SHOVEL_BASIC = 5,
	SHOVEL_STURDY = 6,
	SIEVE_FINE = 7,
	SIEVE_COARSE = 8
}

# Tool rarity levels
enum ToolRarity {
	COMMON = 0,
	UNCOMMON = 1,
	RARE = 2,
	EPIC = 3,
	LEGENDARY = 4
}

## Tool data class
class ToolData:
	var tool_type: ToolType
	var name: String
	var description: String
	var durability: int  # Current durability (0-100)
	var max_durability: int  # Maximum durability
	var upgrade_level: int  # Current upgrade level (1-10)
	var max_upgrade_level: int = 10  # Maximum possible upgrade level
	var rarity: ToolRarity
	var efficiency: float  # How effective the tool is (affects panning success)
	var durability_degradation_rate: float  # How fast durability decreases
	var cost: int  # Base cost in gold
	
	# Upgrade costs for each level (index corresponds to upgrade level)
	var upgrade_costs: Array[int] = []
	
	## Constructor
	func _init(p_tool_type: ToolType, p_name: String, p_description: String, p_max_durability: int, p_efficiency: float, p_rarity: ToolRarity, p_cost: int):
		tool_type = p_tool_type
		name = p_name
		description = p_description
		durability = p_max_durability
		max_durability = p_max_durability
		upgrade_level = 1
		efficiency = p_efficiency
		durability_degradation_rate = 1.0 / p_max_durability  # Base degradation rate
		rarity = p_rarity
		cost = p_cost
		
		# Calculate upgrade costs based on base cost and upgrade level
		for level in range(1, max_upgrade_level + 1):
			# Upgrade cost increases exponentially with level
			var level_cost = int(p_cost * (1.5 + (level * 0.3)))
			upgrade_costs.append(level_cost)

	## Returns current durability as a percentage (0-100)
	func get_durability_percentage() -> float:
		return (durability / max_durability) * 100.0

	## Applies damage to the tool (decreases durability)
	func apply_damage(amount: int) -> bool:
		durability = max(0, durability - amount)
		return durability > 0  # Returns true if tool is still usable

	## Repairs the tool (increases durability)
	func repair(amount: int) -> int:
		var old_durability = durability
		durability = min(max_durability, durability + amount)
		return durability - old_durability  # Returns amount repaired

	## Upgrades the tool (increases upgrade level and improves stats)
	func upgrade() -> bool:
		if upgrade_level >= max_upgrade_level:
			return false  # Already at max level
		
		upgrade_level += 1
		
		# Improve stats with each upgrade
		max_durability = int(max_durability * 1.1)  # 10% more durability per level
		durability = max_durability  # Fully repair when upgraded
		efficiency = efficiency * 1.05  # 5% more efficiency per level
		
		return true

	## Gets the cost to upgrade to the next level
	func get_upgrade_cost() -> int:
		if upgrade_level >= max_upgrade_level:
			return -1  # Already maxed out
		return upgrade_costs[upgrade_level]

	## Checks if the tool is broken (durability at 0)
	func is_broken() -> bool:
		return durability <= 0

	## Gets tool condition string (BROKEN, POOR, FAIR, GOOD, EXCELLENT)
	func get_condition() -> String:
		var percentage = get_durability_percentage()
		if percentage <= 0:
			return "BROKEN"
		elif percentage <= 25:
			return "POOR"
		elif percentage <= 50:
			return "FAIR"
		elif percentage <= 75:
			return "GOOD"
		else:
			return "EXCELLENT"

## Tool creation functions
static func create_basic_pan() -> ToolData:
	return ToolData.new(
		ToolType.BASIC_PAN,
		"Basic Pan",
		"A simple metal pan for gold panning. Good for beginners.",
		50,     # max durability
		1.0,    # efficiency
		ToolRarity.COMMON,
		10      # cost in gold
	)

static func create_wooden_pan() -> ToolData:
	return ToolData.new(
		ToolType.WOODEN_PAN,
		"Wooden Pan",
		"A traditional wooden pan. Lighter than metal but less durable.",
		40,     # max durability
		1.2,    # efficiency
		ToolRarity.UNCOMMON,
		25      # cost in gold
	)

static func create_professional_pan() -> ToolData:
	return ToolData.new(
		ToolType.PROFESSIONAL_PAN,
		"Professional Pan",
		"A refined metal pan with improved design for better gold separation.",
		75,     # max durability
		1.5,    # efficiency
		ToolRarity.RARE,
		50      # cost in gold
	)

static func create_sluice_box() -> ToolData:
	return ToolData.new(
		ToolType.SLUICE_BOX,
		"Sluice Box",
		"Processes large amounts of sediment for gold. Requires more skill.",
		100,    # max durability
		2.0,    # efficiency
		ToolRarity.EPIC,
		100     # cost in gold
	)

static func create_gold_mine_kit() -> ToolData:
	return ToolData.new(
		ToolType.GOLD_MINE_KIT,
		"Gold Mine Kit",
		"A premium professional kit with all the tools needed for serious gold panning.",
		150,    # max durability
		2.5,    # efficiency
		ToolRarity.LEGENDARY,
		200     # cost in gold
	)

static func create_basic_shovel() -> ToolData:
	return ToolData.new(
		ToolType.SHOVEL_BASIC,
		"Basic Shovel",
		"A simple shovel for digging up sediment.",
		60,     # max durability
		1.0,    # efficiency
		ToolRarity.COMMON,
		15      # cost in gold
	)

static func create_sturdy_shovel() -> ToolData:
	return ToolData.new(
		ToolType.SHOVEL_STURDY,
		"Sturdy Shovel",
		"A reinforced shovel for more demanding digging tasks.",
		90,     # max durability
		1.3,    # efficiency
		ToolRarity.UNCOMMON,
		40      # cost in gold
	)

## Sample usage:
# var pan = ToolData.create_professional_pan()
# print(pan.name + " - Durability: " + str(pan.durability) + "/" + str(pan.max_durability))