extends Node2D

## Main scene script for Buffalo Brook Gold Rush
## Entry point for the game and manager of main game states

var game_scene: Node2D = null
var pause_menu: Panel = null
var gold_counter: Label = null
var tool_indicator: Label = null

func _ready():
	## Called when the node enters the scene tree for the first time
	print("Buffalo Brook Gold Rush starting...")
	
	# Find UI elements
	pause_menu = $GameUI/PauseMenu
	gold_counter = $GameUI/HUD/GoldCounter
	tool_indicator = $GameUI/HUD/ToolIndicator
	
	# Connect pause menu buttons
	$GameUI/PauseMenu/ResumeButton.pressed.connect(_on_resume_pressed)
	$GameUI/PauseMenu/MainMenuButton.pressed.connect(_on_main_menu_pressed)
	
	# Initially hide pause menu
	pause_menu.visible = false
	
	# Start the game
	start_game()

func _process(_delta: float):
	## Called every frame
	# Handle pause input
	if Input.is_action_just_pressed("pause"):
		toggle_pause_menu()

func start_game():
	## Starts a new game session
	# Remove any existing game scene
	if game_scene:
		game_scene.queue_free()
	
	# Create and add the main game scene
	game_scene = load("res://scenes/main_game.tscn").instantiate()
	add_child(game_scene)
	
	# Connect to game events
	game_scene.gold_found.connect(_on_gold_found)
	game_scene.tool_changed.connect(_on_tool_changed)

func toggle_pause_menu():
	## Toggles the pause menu visibility
	get_tree().paused = not get_tree().paused
	pause_menu.visible = get_tree().paused

func _on_gold_found(amount: int):
	## Updates the gold counter when gold is found
	if gold_counter and game_scene:
		gold_counter.text = "Gold: " + str(game_scene.get_gold_count())

func _on_tool_changed(tool_name: String):
	## Updates the tool indicator when tool changes
	if tool_indicator:
		tool_indicator.text = "Tool: " + tool_name

func _on_resume_pressed():
	## Handles resume button press
	toggle_pause_menu()

func _on_main_menu_pressed():
	## Handles main menu button press
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu.tscn")