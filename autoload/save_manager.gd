extends Node

## Save manager for Buffalo Brook Gold Rush
## Handles saving and loading of game data including inventory

# Reference to the inventory system
var inventory: Node = null

# Save file path
const SAVE_FILE_PATH = "user://savegame.save"

func _ready():
	## Initialize the save manager
	print("Save manager initialized")

func set_inventory_system(inventory_node: Node):
	## Sets the reference to the inventory system
	inventory = inventory_node
	print("Save manager connected to inventory system")

func save_game() -> bool:
	## Saves the game data including inventory
	if not inventory:
		print("ERROR: No inventory system connected for saving")
		return false
	
	return inventory.save_inventory(SAVE_FILE_PATH)

func load_game() -> bool:
	## Loads the game data including inventory
	if not inventory:
		print("ERROR: No inventory system connected for loading")
		return false
	
	return inventory.load_inventory(SAVE_FILE_PATH)

func quick_save() -> bool:
	## Performs a quick save of the game
	return save_game()

func quick_load() -> bool:
	## Performs a quick load of the game
	return load_game()

func save_exists() -> bool:
	## Checks if a save file exists
	return FileAccess.file_exists(SAVE_FILE_PATH)

func delete_save():
	## Deletes the save file
	if FileAccess.file_exists(SAVE_FILE_PATH):
		DirAccess.remove_absolute(SAVE_FILE_PATH)
		print("Save file deleted")