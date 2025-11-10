extends CanvasLayer

## Inventory UI script for Buffalo Brook Gold Rush
## Manages the display and interaction with collected items (gold, gems, artifacts)
## This script handles both the inventory logic and UI elements

# Signals that communicate inventory events to other systems
signal inventory_opened()         # Emitted when inventory UI is opened
signal inventory_closed()         # Emitted when inventory UI is closed
signal item_added(item_type, amount)  # Emitted when items are added to inventory
signal item_removed(item_type, amount)  # Emitted when items are removed from inventory
signal gold_updated(new_amount)   # Emitted when gold total changes
signal sell_item_requested(item_type, amount, price)  # Emitted when player wants to sell items

# Inventory data variables
var gold_amount: int = 0              # Current gold in the player's inventory
var inventory_items: Dictionary = {}  # Dictionary storing collected items and their quantities
var max_inventory_slots: int = 20     # Maximum number of different items that can be stored

# UI element references (assigned via @onready)
@onready var gold_label = $Panel/GoldDisplay/GoldAmount
@onready var inventory_list = $Panel/ItemList
@onready var close_button = $Panel/CloseButton
@onready var sell_button = $Panel/SellButton

# Item type definitions for consistency
enum ItemType {
	GOLD_FLAKE,
	GOLD_NUGGET,
	GEM,
	ARTIFACT,
	PAN_UPGRADE,
	ACCESSORY
}

func _ready():
	## Called when the node enters the scene tree for the first time
	# Initialize inventory UI
	_update_gold_display()
	_setup_inventory_slots()
	
	# Connect UI button signals
	close_button.pressed.connect(_on_close_pressed)
	sell_button.pressed.connect(_on_sell_pressed)
	
	print("Inventory UI initialized")

func _setup_inventory_slots():
	## Creates empty inventory slots for displaying items
	for i in range(max_inventory_slots):
		var item_slot = _create_item_slot(i)
		inventory_list.add_child(item_slot)

func _create_item_slot(slot_index: int):
	## Creates a single inventory slot with proper UI elements
	var hbox = HBoxContainer.new()
	hbox.name = "Slot" + str(slot_index)
	
	var item_icon = TextureRect.new()
	item_icon.name = "Icon"
	item_icon.size = Vector2(32, 32)
	item_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
	var item_name = Label.new()
	item_name.name = "Name"
	item_name.text = "Empty"
	
	var item_count = Label.new()
	item_count.name = "Count"
	item_count.text = "0"
	
	var sell_button = Button.new()
	sell_button.name = "Sell"
	sell_button.text = "Sell"
	
	hbox.add_child(item_icon)
	hbox.add_child(item_name)
	hbox.add_child(item_count)
	hbox.add_child(sell_button)
	
	return hbox

func add_gold(amount: int):
	## Adds gold to inventory and updates display
	if amount > 0:
		gold_amount += amount
		_update_gold_display()
		gold_updated.emit(gold_amount)
		item_added.emit("gold", amount)

func remove_gold(amount: int):
	## Removes gold from inventory (for purchases)
	if amount > 0 and gold_amount >= amount:
		gold_amount -= amount
		_update_gold_display()
		gold_updated.emit(gold_amount)
		item_removed.emit("gold", amount)
		return true
	return false

func add_item(item_type: String, amount: int = 1):
	## Adds an item to the inventory or increases existing quantity
	if inventory_items.has(item_type):
		inventory_items[item_type] += amount
	else:
		inventory_items[item_type] = amount
	
	# Update UI to reflect the new item
	_update_inventory_display()
	item_added.emit(item_type, amount)
	
	# Play sound effect for item pickup
	# AudioManager.play_sfx("item_pickup")

func remove_item(item_type: String, amount: int = 1):
	## Removes an item from inventory
	if inventory_items.has(item_type) and inventory_items[item_type] >= amount:
		inventory_items[item_type] -= amount
		if inventory_items[item_type] <= 0:
			inventory_items.erase(item_type)
		
		_update_inventory_display()
		item_removed.emit(item_type, amount)
		return true
	return false

func _update_gold_display():
	## Updates the UI element showing gold amount
	if gold_label:
		gold_label.text = str(gold_amount)

func _update_inventory_display():
	## Updates all inventory slot displays to show current items
	var slot_index = 0
	for item_type in inventory_items:
		if slot_index < max_inventory_slots:
			var slot = inventory_list.get_child(slot_index)
			if slot:
				# Update the slot with item information
				var icon = slot.get_node("Icon") as TextureRect
				var name_label = slot.get_node("Name") as Label
				var count_label = slot.get_node("Count") as Label
				var sell_btn = slot.get_node("Sell") as Button
				
				# Set item name
				name_label.text = item_type
				
				# Set item count
				count_label.text = str(inventory_items[item_type])
				
				# Set item icon (would use actual textures in full implementation)
				# icon.texture = get_item_texture(item_type)
				
				# Connect sell button to sell function
				sell_btn.pressed.disconnect_all()
				sell_btn.pressed.connect(_on_sell_item.bind(item_type))
			
			slot_index += 1
	
	# Clear remaining slots
	while slot_index < max_inventory_slots:
		var slot = inventory_list.get_child(slot_index)
		if slot:
			var name_label = slot.get_node("Name") as Label
			var count_label = slot.get_node("Count") as Label
			var sell_btn = slot.get_node("Sell") as Button
			
			name_label.text = "Empty"
			count_label.text = "0"
			sell_btn.disabled = true
		
		slot_index += 1

func get_item_count(item_type: String) -> int:
	## Returns the quantity of a specific item in inventory
	return inventory_items.get(item_type, 0)

func can_add_item(item_type: String, amount: int = 1) -> bool:
	## Checks if there's space in inventory to add the specified item
	# For now, just checks if we have slots available
	# In a full implementation, might check if item type already exists or add to existing stack
	return (inventory_items.size() < max_inventory_slots) or inventory_items.has(item_type)

func calculate_item_value(item_type: String, amount: int = 1) -> int:
	## Calculates the selling price for an item based on type and market conditions
	var base_price = _get_base_price(item_type)
	
	# Apply market fluctuations (would be managed by MarketManager in full implementation)
	var market_factor = 1.0  # Would come from MarketManager
	
	return int(base_price * amount * market_factor)

func _get_base_price(item_type: String) -> int:
	## Returns the base price for different item types
	match item_type:
		"gold_flake": return 10
		"gold_nugget": return 50
		"gem": return 30
		"artifact": return 100
		_:
			if item_type.begins_with("gold"):
				return 10
			else:
				return 5  # Default value for unknown items

func _on_close_pressed():
	## Handles the close button press to hide inventory
	hide()
	inventory_closed.emit()

func _on_sell_pressed():
	## Handles the general sell button press (for selected items)
	# This would handle selling for all selected items
	# Implementation would depend on whether we have item selection
	pass

func _on_sell_item(item_type: String):
	## Handles selling of a specific item type
	var count = get_item_count(item_type)
	var total_value = calculate_item_value(item_type, count)
	
	# Remove items from inventory
	remove_item(item_type, count)
	
	# Add gold to inventory
	add_gold(total_value)
	
	# Emit signal about the sale
	sell_item_requested.emit(item_type, count, total_value)

func open_inventory():
	## Shows the inventory UI and updates displays
	show()
	_update_gold_display()
	_update_inventory_display()
	inventory_opened.emit()

func close_inventory():
	## Hides the inventory UI
	hide()
	inventory_closed.emit()

func is_inventory_open() -> bool:
	## Returns whether inventory UI is currently visible
	return visible

func get_total_inventory_value() -> int:
	## Calculates the total value of all items in inventory
	var total_value = gold_amount  # Include current gold
	
	for item_type in inventory_items:
		var count = inventory_items[item_type]
		total_value += calculate_item_value(item_type, count)
	
	return total_value