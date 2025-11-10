extends CanvasLayer

## HUD (Heads-Up Display) for Buffalo Brook Gold Rush
## Displays gold total and other important information to the player

# Reference to the global inventory system
var inventory: Node = null

# UI elements
@onready var gold_label: Label = $Panel/GoldDisplay/GoldAmount
@onready var item_count_label: Label = $Panel/ItemCount/ItemCountValue
@onready var inventory_icon: TextureRect = $Panel/InventoryIcon

# Default values if inventory is not connected
var current_gold: int = 0
var current_item_count: int = 0

func _ready():
	## Initialize the HUD
	_connect_to_inventory()
	
	# Setup UI interactions
	if inventory_icon:
		inventory_icon.gui_input.connect(_on_inventory_icon_input)

func _connect_to_inventory():
	## Connects the HUD to the global inventory system if available
	if has_node("/root/Main/Inventory"):  # Adjust path based on your scene structure
		inventory = get_node("/root/Main/Inventory")
		# Connect signals
		inventory.gold_changed.connect(_on_gold_changed)
		inventory.inventory_updated.connect(_on_inventory_updated)
		
		# Update initial values
		_on_gold_changed(inventory.get_gold())
		_on_inventory_updated()
		
		print("HUD connected to inventory system")
	else:
		print("WARNING: Could not connect to inventory system")
		# Fallback: attempt to connect via autoload if set up that way
		if "Inventory" in get_tree().root:
			inventory = get_tree().root.get_node("Inventory")
			if inventory:
				inventory.gold_changed.connect(_on_gold_changed)
				inventory.inventory_updated.connect(_on_inventory_updated)
				
				_on_gold_changed(inventory.get_gold())
				_on_inventory_updated()
				print("HUD connected to inventory autoload")

func _on_gold_changed(new_gold: int):
	## Updates the displayed gold amount when it changes
	current_gold = new_gold
	if gold_label:
		gold_label.text = str(current_gold)

func _on_inventory_updated():
	## Updates inventory-related UI when the inventory changes
	if inventory:
		current_item_count = inventory.get_total_item_types()
		if item_count_label:
			item_count_label.text = str(current_item_count)
	else:
		# Fallback if inventory isn't available
		current_item_count = 0
		if item_count_label:
			item_count_label.text = "0"

func _on_inventory_icon_input(event: InputEvent):
	## Handles interaction with the inventory icon
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Toggle inventory UI or show inventory screen
		print("Inventory icon clicked")
		# This would typically open the inventory screen in a real implementation

# Public methods to update HUD directly if needed
func update_gold_display(gold_amount: int):
	## Updates the gold display directly
	current_gold = gold_amount
	if gold_label:
		gold_label.text = str(gold_amount)

func update_item_count_display(item_count: int):
	## Updates the item count display directly
	current_item_count = item_count
	if item_count_label:
		item_count_label.text = str(item_count)

# Debug method to test HUD updates
func _input(event: InputEvent):
	if event.is_action_pressed("ui_debug_gold"):
		# Simulate gold change for testing
		current_gold += 10
		if gold_label:
			gold_label.text = str(current_gold)

func _process(_delta: float):
	## This function can be used to update HUD elements that change constantly
	# For example, animations, timers, etc.
	pass