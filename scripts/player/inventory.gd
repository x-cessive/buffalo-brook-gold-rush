extends Node

## Inventory system for Buffalo Brook Gold Rush
## Uses dictionaries to store items and gold, with methods for adding, removing, and managing inventory
## Now includes tools with durability and upgrade levels
## Includes save/load functionality to JSON

# Load tool data
const ToolDataScript = preload("res://scripts/tools/tool_data.gd")

# Signals for inventory events
signal inventory_updated
signal item_added(item_type, amount)
signal item_removed(item_type, amount)
signal gold_changed(new_amount)
signal tool_added(tool_type)
signal tool_removed(tool_type)
signal tool_durability_changed(tool_type, old_durability, new_durability)
signal save_success
signal save_failed
signal load_success
signal load_failed

# Dictionary to store regular items: {item_type: quantity}
var items: Dictionary = {}

# Dictionary to store tools: {tool_type: ToolData}
var tools: Dictionary = {}

# Gold amount
var gold: int = 0

# Maximum number of different items that can be stored (for non-tool items)
var max_item_capacity: int = 30

# Maximum number of tools that can be stored
var max_tool_capacity: int = 20

# Item types definition
enum ItemType {
	GOLD_FLAKES,
	GOLD_NUGGET,
	CRYSTAL,
	AMETHYST,
	QUARTZ,
	HISTORICAL_ARTIFACT,
	NET_BUG,
	NET_FISH,
	ROPE,
	MAP_VENTURE,
	MAP_SECRET,
	PLANK,
	ROCK_SAMPLE,
	FEATHER,
	BONE,
	LEATHER,
	COIN_ANCIENT,
	COIN_FOREIGN
}

func _ready():
	## Initialize the inventory
	print("Inventory system initialized with " + str(gold) + " gold")
	
	# Add some starting tools for testing
	# add_tool(ToolDataScript.create_basic_pan())
	# add_tool(ToolDataScript.create_basic_shovel())

func add_item(item_type: String, amount: int = 1) -> bool:
	## Adds items to inventory, returns true if successful
	if amount <= 0:
		return false
	
	# Check if we have space for a new item type
	if not items.has(item_type) and get_total_item_types() >= max_item_capacity:
		print("Inventory is full, cannot add new item type: " + item_type)
		return false
	
	# Add the items to inventory
	if items.has(item_type):
		items[item_type] += amount
	else:
		items[item_type] = amount
	
	# Emit signal for the added items
	emit_signal("item_added", item_type, amount)
	emit_signal("inventory_updated")
	
	print("Added " + str(amount) + "x " + item_type + "(s) to inventory")
	return true

func remove_item(item_type: String, amount: int = 1) -> bool:
	## Removes items from inventory, returns true if successful
	if not items.has(item_type) or items[item_type] < amount or amount <= 0:
		return false
	
	items[item_type] -= amount
	
	if items[item_type] <= 0:
		items.erase(item_type)
	
	emit_signal("item_removed", item_type, amount)
	emit_signal("inventory_updated")
	
	print("Removed " + str(amount) + "x " + item_type + "(s) from inventory")
	return true

func add_tool(tool: ToolDataScript.ToolData) -> bool:
	## Adds a tool to inventory, returns true if successful
	if tools.size() >= max_tool_capacity:
		print("Tool inventory is full, cannot add new tool: " + tool.name)
		return false
	
	# If tool already exists, we might want to handle it differently
	# For now, we'll replace the existing tool
	var tool_key = str(tool.tool_type)
	tools[tool_key] = tool
	
	emit_signal("tool_added", tool.tool_type)
	emit_signal("inventory_updated")
	
	print("Added tool: " + tool.name + " to inventory")
	return true

func remove_tool(tool_type: int) -> bool:
	## Removes a tool from inventory by tool type ID, returns true if successful
	var tool_key = str(tool_type)
	if not tools.has(tool_key):
		return false
	
	var removed_tool = tools[tool_key]
	tools.erase(tool_key)
	
	emit_signal("tool_removed", tool_type)
	emit_signal("inventory_updated")
	
	print("Removed tool: " + removed_tool.name + " from inventory")
	return true

func get_tool(tool_type: int) -> ToolDataScript.ToolData:
	## Returns the tool of the specified type, or null if not found
	var tool_key = str(tool_type)
	return tools.get(tool_key, null)

func get_all_tools() -> Dictionary:
	## Returns a copy of the tools dictionary
	return tools.duplicate(true)

func has_tool(tool_type: int) -> bool:
	## Checks if the inventory has a tool of the specified type
	var tool_key = str(tool_type)
	return tools.has(tool_key)

func get_tool_count() -> int:
	## Returns the number of tools in inventory
	return tools.size()

func get_item_count(item_type: String) -> int:
	## Returns the count of a specific item type in inventory
	return items.get(item_type, 0)

func has_item(item_type: String, amount: int = 1) -> bool:
	## Checks if the inventory has at least the specified amount of an item
	return get_item_count(item_type) >= amount

func add_gold(amount: int) -> bool:
	## Adds gold to inventory, returns true if successful
	if amount <= 0:
		return false
	
	gold += amount
	emit_signal("gold_changed", gold)
	
	print("Added " + str(amount) + " gold. Total: " + str(gold))
	return true

func remove_gold(amount: int) -> bool:
	## Removes gold from inventory, returns true if successful
	if amount <= 0 or gold < amount:
		return false
	
	gold -= amount
	emit_signal("gold_changed", gold)
	
	print("Removed " + str(amount) + " gold. Remaining: " + str(gold))
	return true

func get_gold() -> int:
	## Returns the current amount of gold
	return gold

func set_gold(amount: int):
	## Sets the gold amount directly
	gold = amount
	emit_signal("gold_changed", gold)
	
	print("Gold set to: " + str(gold))

func get_total_item_types() -> int:
	## Returns the number of different regular item types in inventory
	return items.size()

func get_total_items() -> int:
	## Returns the total number of regular items in inventory (including stacks)
	var total = 0
	for count in items.values():
		total += count
	return total

func is_full() -> bool:
	## Checks if the inventory is at maximum capacity for different item types
	return get_total_item_types() >= max_item_capacity

func get_space_remaining() -> int:
	## Returns the number of additional item types that can be added
	return max_item_capacity - get_total_item_types()

func is_tool_inventory_full() -> bool:
	## Checks if the tool inventory is at maximum capacity
	return get_tool_count() >= max_tool_capacity

func get_tool_space_remaining() -> int:
	## Returns the number of additional tools that can be added
	return max_tool_capacity - get_tool_count()

func clear_inventory():
	## Removes all items, tools, and gold from inventory
	items.clear()
	tools.clear()
	gold = 0
	emit_signal("inventory_updated")
	emit_signal("gold_changed", gold)
	
	print("Inventory cleared")

func get_all_items() -> Dictionary:
	## Returns a copy of the items dictionary
	return items.duplicate(true)

func can_add_item_type() -> bool:
	## Checks if there's space for a new item type
	return get_total_item_types() < max_item_capacity

func can_add_items(item_type: String, amount: int) -> bool:
	## Checks if items can be added to inventory
	if amount <= 0:
		return false
	
	# If the item type doesn't exist yet, check if we have space for a new type
	if not items.has(item_type) and get_total_item_types() >= max_item_capacity:
		return false
	
	return true

func can_add_tool() -> bool:
	## Checks if there's space for a new tool
	return get_tool_count() < max_tool_capacity

func get_inventory_info() -> Dictionary:
	## Returns information about the inventory state
	return {
		"gold": gold,
		"item_count": get_total_items(),
		"item_types_count": get_total_item_types(),
		"tool_count": get_tool_count(),
		"capacity_remaining": get_space_remaining(),
		"tool_capacity_remaining": get_tool_space_remaining(),
		"is_full": is_full(),
		"is_tool_inventory_full": is_tool_inventory_full()
	}

# Save/Load functionality
func save_inventory(file_path: String) -> bool:
	## Saves the inventory to a JSON file, returns true if successful
	var items_data = {}
	for item_type in items:
		items_data[item_type] = items[item_type]
	
	var tools_data = {}
	for tool_key in tools:
		var tool = tools[tool_key]
		tools_data[tool_key] = {
			"tool_type": tool.tool_type,
			"name": tool.name,
			"description": tool.description,
			"durability": tool.durability,
			"max_durability": tool.max_durability,
			"upgrade_level": tool.upgrade_level,
			"max_upgrade_level": tool.max_upgrade_level,
			"rarity": tool.rarity,
			"efficiency": tool.efficiency,
			"durability_degradation_rate": tool.durability_degradation_rate,
			"cost": tool.cost,
			"upgrade_costs": tool.upgrade_costs
		}
	
	var save_data = {
		"gold": gold,
		"items": items_data,
		"tools": tools_data
	}
	
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()
		
		emit_signal("save_success")
		print("Inventory saved to: " + file_path)
		return true
	else:
		print("ERROR: Could not save inventory to: " + file_path)
		emit_signal("save_failed")
		return false

func load_inventory(file_path: String) -> bool:
	## Loads the inventory from a JSON file, returns true if successful
	if not FileAccess.file_exists(file_path):
		print("ERROR: Save file does not exist: " + file_path)
		emit_signal("load_failed")
		return false
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		print("ERROR: Could not open save file: " + file_path)
		emit_signal("load_failed")
		return false
	
	var content = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(content)
	if parse_result != OK:
		print("ERROR: Could not parse JSON: " + str(parse_result))
		emit_signal("load_failed")
		return false
	
	var save_data = json.data
	if not save_data is Dictionary:
		print("ERROR: Invalid save data format")
		emit_signal("load_failed")
		return false
	
	# Load gold
	if save_data.has("gold"):
		gold = save_data["gold"]
	
	# Load items
	if save_data.has("items"):
		items.clear()
		for item_type in save_data["items"]:
			items[item_type] = save_data["items"][item_type]
	
	# Load tools
	if save_data.has("tools"):
		tools.clear()
		for tool_key in save_data["tools"]:
			var tool_data = save_data["tools"][tool_key]
			
			# Create a new ToolData instance and set its properties
			var tool = _create_tool_from_data(tool_data)
			if tool:
				tools[tool_key] = tool
	
	emit_signal("load_success")
	emit_signal("inventory_updated")
	emit_signal("gold_changed", gold)
	
	print("Inventory loaded from: " + file_path + " (Gold: " + str(gold) + 
	      ", Items: " + str(get_total_item_types()) + ", Tools: " + str(get_tool_count()) + ")")
	return true

func _create_tool_from_data(tool_data: Dictionary) -> ToolDataScript.ToolData:
	## Creates a tool from saved data
	# Create a new tool based on type
	var new_tool: ToolDataScript.ToolData
	match tool_data["tool_type"]:
		ToolDataScript.ToolType.BASIC_PAN:
			new_tool = ToolDataScript.create_basic_pan()
		ToolDataScript.ToolType.WOODEN_PAN:
			new_tool = ToolDataScript.create_wooden_pan()
		ToolDataScript.ToolType.PROFESSIONAL_PAN:
			new_tool = ToolDataScript.create_professional_pan()
		ToolDataScript.ToolType.SLUICE_BOX:
			new_tool = ToolDataScript.create_sluice_box()
		ToolDataScript.ToolType.GOLD_MINE_KIT:
			new_tool = ToolDataScript.create_gold_mine_kit()
		ToolDataScript.ToolType.SHOVEL_BASIC:
			new_tool = ToolDataScript.create_basic_shovel()
		ToolDataScript.ToolType.SHOVEL_STURDY:
			new_tool = ToolDataScript.create_sturdy_shovel()
		_:
			print("Unknown tool type: " + str(tool_data["tool_type"]))
			return null
	
	# Set the tool properties from saved data
	new_tool.durability = tool_data["durability"]
	new_tool.max_durability = tool_data["max_durability"]
	new_tool.upgrade_level = tool_data["upgrade_level"]
	new_tool.max_upgrade_level = tool_data["max_upgrade_level"]
	new_tool.rarity = tool_data["rarity"]
	new_tool.efficiency = tool_data["efficiency"]
	new_tool.durability_degradation_rate = tool_data["durability_degradation_rate"]
	new_tool.cost = tool_data["cost"]
	new_tool.upgrade_costs = tool_data["upgrade_costs"]
	
	return new_tool

func export_to_json() -> String:
	## Exports the current inventory state to a JSON string
	var items_data = {}
	for item_type in items:
		items_data[item_type] = items[item_type]
	
	var tools_data = {}
	for tool_key in tools:
		var tool = tools[tool_key]
		tools_data[tool_key] = {
			"tool_type": tool.tool_type,
			"name": tool.name,
			"description": tool.description,
			"durability": tool.durability,
			"max_durability": tool.max_durability,
			"upgrade_level": tool.upgrade_level,
			"max_upgrade_level": tool.max_upgrade_level,
			"rarity": tool.rarity,
			"efficiency": tool.efficiency,
			"durability_degradation_rate": tool.durability_degradation_rate,
			"cost": tool.cost,
			"upgrade_costs": tool.upgrade_costs
		}
	
	var save_data = {
		"gold": gold,
		"items": items_data,
		"tools": tools_data,
		"timestamp": Time.get_unix_time_from_system()
	}
	
	return JSON.stringify(save_data)

func import_from_json(json_string: String) -> bool:
	## Imports inventory state from a JSON string, returns true if successful
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result != OK:
		print("ERROR: Could not parse JSON: " + str(parse_result))
		return false
	
	var save_data = json.data
	if not save_data is Dictionary:
		print("ERROR: Invalid save data format")
		return false
	
	# Load gold
	if save_data.has("gold"):
		gold = save_data["gold"]
	
	# Load items
	if save_data.has("items"):
		items.clear()
		for item_type in save_data["items"]:
			items[item_type] = save_data["items"][item_type]
	
	# Load tools
	if save_data.has("tools"):
		tools.clear()
		for tool_key in save_data["tools"]:
			var tool_data = save_data["tools"][tool_key]
			
			# Create a new ToolData instance and set its properties
			var tool = _create_tool_from_data(tool_data)
			if tool:
				tools[tool_key] = tool
	
	emit_signal("inventory_updated")
	emit_signal("gold_changed", gold)
	
	print("Inventory imported from JSON string")
	return true

# Tool-specific functions
func apply_tool_damage(tool_type: int, amount: int) -> bool:
	## Applies damage to a tool, returns true if tool is still usable
	var tool = get_tool(tool_type)
	if not tool:
		return false
	
	var old_durability = tool.durability
	var is_usable = tool.apply_damage(amount)
	var new_durability = tool.durability
	
	# Emit signal for durability change
	emit_signal("tool_durability_changed", tool_type, old_durability, new_durability)
	emit_signal("inventory_updated")
	
	if not is_usable:
		print("Tool " + tool.name + " has broken!")
	
	return is_usable

func repair_tool(tool_type: int, amount: int = -1) -> int:
	## Repairs a tool (amount: specific amount to repair, -1 for full repair)
	var tool = get_tool(tool_type)
	if not tool:
		return 0
	
	if amount == -1:
		amount = tool.max_durability - tool.durability  # Repair to full
	
	var repair_amount = tool.repair(amount)
	emit_signal("tool_durability_changed", tool_type, tool.durability - repair_amount, tool.durability)
	emit_signal("inventory_updated")
	
	return repair_amount

func repair_tool_with_items(tool_type: int, repair_item_type: String, item_count: int = 1) -> bool:
	## Repairs a tool using specific repair items from inventory
	var tool = get_tool(tool_type)
	if not tool:
		return false
	
	# Check if player has the required items
	if get_item_count(repair_item_type) < item_count:
		print("Not enough " + repair_item_type + " to repair tool")
		return false
	
	# Calculate repair amount based on items (for example, 10 durability per repair item)
	var repair_amount = item_count * 10
	
	# Remove repair items from inventory
	remove_item(repair_item_type, item_count)
	
	# Apply repair to tool
	tool.repair(repair_amount)
	
	emit_signal("tool_durability_changed", tool_type, tool.durability - repair_amount, tool.durability)
	emit_signal("inventory_updated")
	
	print("Repaired tool using " + str(item_count) + "x " + repair_item_type)
	return true

func repair_tool_with_gold(tool_type: int, gold_amount: int) -> bool:
	## Repairs a tool using gold (pay to repair at shop)
	var tool = get_tool(tool_type)
	if not tool:
		return false
	
	# Check if player has enough gold
	if gold < gold_amount:
		print("Not enough gold to repair tool. Need: " + str(gold_amount) + ", Have: " + str(gold))
		return false
	
	# Calculate repair amount based on gold spent (for example, 1 durability per gold)
	var repair_amount = gold_amount
	
	# Remove gold from inventory
	remove_gold(gold_amount)
	
	# Apply repair to tool
	tool.repair(repair_amount)
	
	emit_signal("tool_durability_changed", tool_type, tool.durability - repair_amount, tool.durability)
	emit_signal("inventory_updated")
	
	print("Repaired tool using " + str(gold_amount) + " gold")
	return true

func repair_all_tools() -> int:
	## Repairs all tools to full durability, returns total repair cost in gold
	var total_cost = 0
	
	for tool_key in tools:
		var tool = tools[tool_key]
		var repair_amount = tool.max_durability - tool.durability
		if repair_amount > 0:
			tool.repair(repair_amount)
			# In this implementation, we'll assume it costs 1 gold per durability point to repair
			total_cost += repair_amount
	end
	
	if total_cost > 0:
		if gold >= total_cost:
			remove_gold(total_cost)
			emit_signal("inventory_updated")
			print("Repaired all tools for " + str(total_cost) + " gold")
			return total_cost
		else:
			print("Not enough gold to repair all tools. Need: " + str(total_cost) + ", Have: " + str(gold))
			return -1  # Not enough gold
	else:
		print("All tools are already at full durability")
		return 0

func repair_tools_by_type(tool_type: ToolDataScript.ToolType) -> int:
	## Repairs all tools of a specific type, returns total cost in gold
	var total_cost = 0
	
	for tool_key in tools:
		var tool = tools[tool_key]
		if tool.tool_type == tool_type:
			var repair_amount = tool.max_durability - tool.durability
			if repair_amount > 0:
				tool.repair(repair_amount)
				# Cost: 1 gold per durability point
				total_cost += repair_amount
	end
	
	if total_cost > 0:
		if gold >= total_cost:
			remove_gold(total_cost)
			emit_signal("inventory_updated")
			print("Repaired all " + str(tool_type) + " tools for " + str(total_cost) + " gold")
			return total_cost
		else:
			print("Not enough gold to repair tools. Need: " + str(total_cost) + ", Have: " + str(gold))
			return -1  # Not enough gold
	else:
		print("All tools of type " + str(tool_type) + " are already at full durability")
		return 0

func upgrade_tool(tool_type: int) -> bool:
	## Upgrades a tool, returns true if successful
	var tool = get_tool(tool_type)
	if not tool:
		return false
	
	if tool.upgrade_level >= tool.max_upgrade_level:
		print("Tool is already at max upgrade level")
		return false
	
	# Check if player has enough gold for the upgrade
	var upgrade_cost = tool.get_upgrade_cost()
	if gold < upgrade_cost:
		print("Not enough gold to upgrade tool. Need: " + str(upgrade_cost) + ", Have: " + str(gold))
		return false
	
	# Deduct gold and upgrade the tool
	remove_gold(upgrade_cost)
	var success = tool.upgrade()
	
	if success:
		emit_signal("inventory_updated")
		print("Tool upgraded successfully!")
	
	return success

func can_upgrade_tool(tool_type: int) -> bool:
	## Checks if a tool can be upgraded (has available level and sufficient gold)
	var tool = get_tool(tool_type)
	if not tool:
		return false
	
	if tool.upgrade_level >= tool.max_upgrade_level:
		return false  # Already at max level
	
	var upgrade_cost = tool.get_upgrade_cost()
	return gold >= upgrade_cost

func get_tool_upgrade_cost(tool_type: int) -> int:
	## Returns the cost to upgrade a tool to the next level
	var tool = get_tool(tool_type)
	if not tool:
		return -1  # Tool doesn't exist
	
	return tool.get_upgrade_cost()

func get_tool_upgrade_info(tool_type: int) -> Dictionary:
	## Returns upgrade information for a tool
	var tool = get_tool(tool_type)
	if not tool:
		return {}
	
	return {
		"current_level": tool.upgrade_level,
		"max_level": tool.max_upgrade_level,
		"upgrade_cost": tool.get_upgrade_cost(),
		"can_upgrade": can_upgrade_tool(tool_type),
		"efficiency": tool.efficiency,
		"max_durability": tool.max_durability
	}

func upgrade_all_tools_of_type(tool_type: ToolDataScript.ToolType) -> int:
	## Attempts to upgrade all tools of a specific type as much as possible
	var total_cost = 0
	
	for tool_key in tools:
		var tool = tools[tool_key]
		if tool.tool_type == tool_type:
			# Keep upgrading while possible
			while can_upgrade_tool(tool.tool_type):
				var upgrade_cost = get_tool_upgrade_cost(tool.tool_type)
				if gold >= upgrade_cost:
					remove_gold(upgrade_cost)
					tool.upgrade()
					total_cost += upgrade_cost
					emit_signal("inventory_updated")
				else:
					break  # Can't afford the next upgrade
	
	print("Upgraded all " + str(tool_type) + " tools for a total of " + str(total_cost) + " gold")
	return total_cost

func upgrade_tool_with_items(tool_type: int, upgrade_item_type: String, item_count: int = 1) -> bool:
	## Upgrades a tool using specific upgrade items from inventory
	var tool = get_tool(tool_type)
	if not tool:
		return false
	
	# Check if player has the required items
	if get_item_count(upgrade_item_type) < item_count:
		print("Not enough " + upgrade_item_type + " to upgrade tool")
		return false
	
	# In this implementation, each upgrade item can be used instead of gold
	# Check if this would exceed max level
	if tool.upgrade_level >= tool.max_upgrade_level:
		print("Tool is already at max upgrade level")
		return false
	
	# Remove upgrade items from inventory
	remove_item(upgrade_item_type, item_count)
	
	# Upgrade the tool
	var success = tool.upgrade()
	
	if success:
		emit_signal("inventory_updated")
		print("Upgraded tool using " + str(item_count) + "x " + upgrade_item_type)
	
	return success

func get_tool_condition(tool_type: int) -> String:
	## Returns the condition string of a tool
	var tool = get_tool(tool_type)
	if not tool:
		return "NOT FOUND"
	
	return tool.get_condition()

func get_tool_durability_percentage(tool_type: int) -> float:
	## Returns the durability percentage of a tool
	var tool = get_tool(tool_type)
	if not tool:
		return 0.0
	
	return tool.get_durability_percentage()

func is_tool_broken(tool_type: int) -> bool:
	## Checks if a tool is broken (durability at 0)
	var tool = get_tool(tool_type)
	if not tool:
		return true  # If tool doesn't exist, treat as broken
	
	return tool.is_broken()

# Tool decay functions
func apply_tool_decay(tool_type: int, usage_count: int = 1) -> bool:
	## Applies decay to a tool based on usage, returns true if tool is still usable
	var tool = get_tool(tool_type)
	if not tool:
		return false
	
	# Calculate damage based on usage count and degradation rate
	var damage_amount = int(tool.durability_degradation_rate * 10 * usage_count)
	
	return apply_tool_damage(tool_type, damage_amount)

func apply_all_tools_decay(multiplier: float = 1.0):
	## Applies decay to all tools in inventory
	for tool_key in tools:
		var tool = tools[tool_key]
		var damage_amount = int(tool.durability_degradation_rate * 10 * multiplier)
		apply_tool_damage(tool.tool_type, damage_amount)

func apply_tool_decay_by_type(tool_type: ToolDataScript.ToolType, usage_count: int = 1) -> bool:
	## Applies decay to all tools of a specific type
	var success = false
	for tool_key in tools:
		var tool = tools[tool_key]
		if tool.tool_type == tool_type:
			var damage_amount = int(tool.durability_degradation_rate * 10 * usage_count)
			success = apply_tool_damage(tool.tool_type, damage_amount) or success
	
	return success

func decay_tool_over_time(tool_type: int, time_hours: float) -> bool:
	## Applies decay to a tool based on time elapsed (in hours)
	var tool = get_tool(tool_type)
	if not tool:
		return false
	
	# Calculate damage based on time and degradation rate
	var damage_amount = int(tool.durability_degradation_rate * 5 * time_hours)
	
	return apply_tool_damage(tool_type, damage_amount)

func decay_all_tools_over_time(time_hours: float):
	## Applies time-based decay to all tools in inventory
	for tool_key in tools:
		var tool = tools[tool_key]
		var damage_amount = int(tool.durability_degradation_rate * 5 * time_hours)
		apply_tool_damage(tool.tool_type, damage_amount)