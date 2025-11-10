extends CanvasLayer

## Shop UI for Buffalo Brook Gold Rush
## Handles the interface for buying and selling items with fluctuating prices

# Signals for shop events
signal shop_opened
signal shop_closed
signal item_bought(item_type, amount, total_cost)
signal item_sold(item_type, amount, total_earning)

# Reference to inventory system
var inventory: Node = null

# UI elements
@onready var shop_panel: Panel = $ShopPanel
@onready var buy_section: VBoxContainer = $ShopPanel/BuySection
@onready var sell_section: VBoxContainer = $ShopPanel/SellSection
@onready var gold_display: Label = $ShopPanel/TopBar/GoldDisplay
@onready var day_display: Label = $ShopPanel/TopBar/DayDisplay
@onready var close_button: Button = $ShopPanel/CloseButton
@onready var refresh_button: Button = $ShopPanel/RefreshButton

# Economy system reference
var economy_system: Node = null

# Current items available for purchase
var buy_items: Array = []
var sell_items: Array = []

func _ready():
	## Initialize the shop UI
	hide_shop()
	
	# Connect button signals
	close_button.pressed.connect(hide_shop)
	refresh_button.pressed.connect(_refresh_shop_prices)
	
	# Connect to economy system if available
	_connect_to_economy_system()
	_connect_to_inventory_system()

func _connect_to_economy_system():
	## Connects to the economy system
	if "Economy" in get_tree().root:
		economy_system = get_tree().root.get_node("Economy")
		print("Shop UI connected to economy autoload system")
	elif has_node("/root/Main/Economy"):
		economy_system = get_node("/root/Main/Economy")
		print("Shop UI connected to economy system")
	else:
		print("WARNING: Shop UI could not connect to economy system")
		
	# If economy system has a method to get the actual system, use that
	if economy_system and economy_system.has_method("get_economy_system"):
		economy_system = economy_system.get_economy_system()

func _connect_to_inventory_system():
	## Connects to the inventory system
	if "Inventory" in get_tree().root:
		inventory = get_tree().root.get_node("Inventory")
		print("Shop UI connected to inventory system")
	elif has_node("/root/Main/Inventory"):
		inventory = get_node("/root/Main/Inventory")
		print("Shop UI connected to inventory system")
	else:
		print("WARNING: Shop UI could not connect to inventory system")

func show_shop():
	## Opens the shop UI
	if inventory:
		_update_gold_display()
	
	_refresh_shop_content()
	show()
	emit_signal("shop_opened")

func hide_shop():
	## Closes the shop UI
	hide()
	emit_signal("shop_closed")

func _refresh_shop_content():
	## Refreshes the shop content (items for sale, prices, etc.)
	_refresh_buy_section()
	_refresh_sell_section()
	_update_gold_display()
	_update_day_display()

func _refresh_buy_section():
	## Refreshes the buy section with available items
	# Clear existing items
	for child in buy_section.get_children():
		child.queue_free()
	
	# Add buyable items (in a real game, this would come from a data source)
	_add_buy_item("Gold Flake", 5, get_item_price("Gold Flake", true))
	_add_buy_item("Gold Nugget", 20, get_item_price("Gold Nugget", true))
	_add_buy_item("Crystal", 15, get_item_price("Crystal", true))
	_add_buy_item("Amethyst", 25, get_item_price("Amethyst", true))
	_add_buy_item("Basic Pan", 25, get_item_price("Basic Pan", true))
	_add_buy_item("Wooden Pan", 50, get_item_price("Wooden Pan", true))
	_add_buy_item("Repair Kit", 30, get_item_price("Repair Kit", true))
	_add_buy_item("Upgrade Component", 40, get_item_price("Upgrade Component", true))

func _add_buy_item(item_name: String, base_price: int, current_price: int):
	## Adds an item to the buy section
	var item_container = VBoxContainer.new()
	item_container.name = "BuyItem_" + item_name
	item_container.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	var item_label = Label.new()
	item_label.text = item_name + " - $" + str(current_price) + " (Base: $" + str(base_price) + ")"
	
	var controls_container = HBoxContainer.new()
	
	var amount_label = Label.new()
	amount_label.text = "Amount:"
	
	var amount_spinbox = SpinBox.new()
	amount_spinbox.min_value = 1
	amount_spinbox.max_value = 99
	amount_spinbox.value = 1
	
	var buy_button = Button.new()
	buy_button.text = "Buy"
	buy_button.pressed.connect(_on_buy_pressed.bind(item_name, current_price, amount_spinbox))
	
	controls_container.add_child(amount_label)
	controls_container.add_child(amount_spinbox)
	controls_container.add_child(buy_button)
	
	item_container.add_child(item_label)
	item_container.add_child(controls_container)
	
	buy_section.add_child(item_container)

func _refresh_sell_section():
	## Refreshes the sell section with player's items
	# Clear existing items
	for child in sell_section.get_children():
		child.queue_free()
	
	if not inventory:
		return
	
	# Add items from player's inventory that can be sold
	for item_type in inventory.items:
		var item_count = inventory.get_item_count(item_type)
		if item_count > 0:
			_add_sell_item(item_type, item_count, get_item_price(item_type, false))
	
	# Add tools that can be sold
	for tool_key in inventory.tools:
		var tool = inventory.tools[tool_key]
		_add_sell_tool(tool.name, tool.cost, get_item_price(tool.name, false))

func _add_sell_item(item_name: String, quantity: int, current_price: int):
	## Adds an item to the sell section
	var item_container = VBoxContainer.new()
	item_container.name = "SellItem_" + item_name
	item_container.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	var item_label = Label.new()
	item_label.text = item_name + " (Owned: " + str(quantity) + ") - $" + str(current_price) + " each"
	
	var controls_container = HBoxContainer.new()
	
	var amount_label = Label.new()
	amount_label.text = "Sell:"
	
	var amount_spinbox = SpinBox.new()
	amount_spinbox.min_value = 1
	amount_spinbox.max_value = quantity
	amount_spinbox.value = 1
	
	var sell_button = Button.new()
	sell_button.text = "Sell"
	sell_button.pressed.connect(_on_sell_pressed.bind(item_name, current_price, amount_spinbox))
	
	controls_container.add_child(amount_label)
	controls_container.add_child(amount_spinbox)
	controls_container.add_child(sell_button)
	
	item_container.add_child(item_label)
	item_container.add_child(controls_container)
	
	sell_section.add_child(item_container)

func _add_sell_tool(tool_name: String, base_price: int, current_price: int):
	## Adds a tool to the sell section
	var item_container = VBoxContainer.new()
	item_container.name = "SellTool_" + tool_name
	item_container.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	var item_label = Label.new()
	item_label.text = tool_name + " (Sell value: $" + str(current_price) + ")"
	
	var controls_container = HBoxContainer.new()
	
	var sell_button = Button.new()
	sell_button.text = "Sell Tool"
	sell_button.pressed.connect(_on_tool_sell_pressed.bind(tool_name, current_price))
	
	controls_container.add_child(sell_button)
	
	item_container.add_child(item_label)
	item_container.add_child(controls_container)
	
	sell_section.add_child(item_container)

func _on_buy_pressed(item_name: String, price: int, amount_spinbox: SpinBox):
	## Handles buy button press
	var amount = int(amount_spinbox.value)
	var total_cost = price * amount
	
	if inventory and inventory.get_gold() >= total_cost:
		# Perform the purchase
		inventory.remove_gold(total_cost)
		
		# Add item to inventory (for tools, we would need special handling)
		if item_name.begins_with("Pan") or item_name in ["Repair Kit", "Upgrade Component"]:
			# This is a tool item
			_add_tool_to_inventory(item_name)
		else:
			# This is a regular item
			inventory.add_item(item_name, amount)
		
		emit_signal("item_bought", item_name, amount, total_cost)
		print("Bought " + str(amount) + "x " + item_name + " for $" + str(total_cost))
		
		# Refresh display
		_refresh_shop_content()
	else:
		print("Not enough gold to buy " + item_name)

func _on_sell_pressed(item_name: String, price: int, amount_spinbox: SpinBox):
	## Handles sell button press for items
	var amount = int(amount_spinbox.value)
	var total_earning = price * amount
	
	if inventory and inventory.has_item(item_name, amount):
		# Perform the sale
		inventory.remove_item(item_name, amount)
		inventory.add_gold(total_earning)
		
		emit_signal("item_sold", item_name, amount, total_earning)
		print("Sold " + str(amount) + "x " + item_name + " for $" + str(total_earning))
		
		# Refresh display
		_refresh_shop_content()
	else:
		print("Don't have " + str(amount) + "x " + item_name + " to sell")

func _on_tool_sell_pressed(tool_name: String, price: int):
	## Handles sell button press for tools
	if inventory:
		# Find the tool in inventory and remove it
		for tool_key in inventory.tools:
			var tool = inventory.tools[tool_key]
			if tool.name == tool_name:
				# Remove tool from inventory
				inventory.tools.erase(tool_key)
				
				# Add gold to inventory
				inventory.add_gold(price)
				
				emit_signal("item_sold", tool_name, 1, price)
				print("Sold tool " + tool_name + " for $" + str(price))
				
				# Refresh display
				_refresh_shop_content()
				return

func _add_tool_to_inventory(tool_name: String):
	## Adds a purchased tool to inventory
	if not inventory:
		return
	
	# Find the appropriate tool creation function based on name
	var new_tool = null
	var tool_data_script = load("res://scripts/tools/tool_data.gd")
	
	match tool_name:
		"Basic Pan":
			new_tool = tool_data_script.create_basic_pan()
		"Wooden Pan":
			new_tool = tool_data_script.create_wooden_pan()
		"Repair Kit":
			# For items that aren't tools, just add as regular item
			inventory.add_item(tool_name, 1)
			return
		"Upgrade Component":
			# For items that aren't tools, just add as regular item
			inventory.add_item(tool_name, 1)
			return
		_:
			print("Unknown tool: " + tool_name)
			return
	
	if new_tool and inventory.can_add_tool():
		inventory.add_tool(new_tool)

func _update_gold_display():
	## Updates the gold display in the shop UI
	if inventory:
		gold_display.text = "Gold: " + str(inventory.get_gold())
	else:
		gold_display.text = "Gold: 0"

func _update_day_display():
	## Updates the day display (if connected to economy system)
	if economy_system and economy_system.has_method("get_current_day"):
		day_display.text = "Day: " + str(economy_system.get_current_day())
	elif economy_system and economy_system.has_method("get_day_count"):
		day_display.text = "Day: " + str(economy_system.get_day_count())
	else:
		day_display.text = "Day: 1"  # Default

func _refresh_shop_prices():
	## Refreshes all item prices based on current market conditions
	_refresh_shop_content()

func get_item_price(item_name: String, is_buying: bool) -> int:
	## Gets the current price for an item based on economy system
	if economy_system and economy_system.has_method("get_item_price"):
		return economy_system.get_item_price(item_name, is_buying)
	
	# Default pricing if no economy system is available
	match item_name:
		"Gold Flake": return 6  # Slightly higher when buying
		"Gold Nugget": return 22
		"Crystal": return 17
		"Amethyst": return 28
		"Basic Pan": return 30
		"Wooden Pan": return 55
		"Repair Kit": return 35
		"Upgrade Component": return 45
		_: return 10  # Default price

func _input(event: InputEvent):
	## Handle keyboard shortcuts
	if event.is_action_pressed("ui_cancel") and visible:
		hide_shop()