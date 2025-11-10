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

	# Find UI elements with null safety
	if $GameUI and $GameUI/PauseMenu:
		pause_menu = $GameUI/PauseMenu
	
	if $GameUI and $GameUI/HUD and $GameUI/HUD/GoldCounter:
		gold_counter = $GameUI/HUD/GoldCounter
	
	if $GameUI and $GameUI/HUD and $GameUI/HUD/ToolIndicator:
		tool_indicator = $GameUI/HUD/ToolIndicator

	# Connect pause menu buttons with error handling
	if pause_menu and $GameUI/PauseMenu/ResumeButton:
		$GameUI/PauseMenu/ResumeButton.pressed.connect(_on_resume_pressed)
	if pause_menu and $GameUI/PauseMenu/MainMenuButton:
		$GameUI/PauseMenu/MainMenuButton.pressed.connect(_on_main_menu_pressed)

	# Initially hide pause menu
	if pause_menu:
		pause_menu.visible = false
	else:
		print("Warning: Pause menu not found")

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
	var main_game_scene = load("res://scenes/main_game.tscn")
	if main_game_scene:
		game_scene = main_game_scene.instantiate()
		add_child(game_scene)

		# Connect to game events with error handling
		if game_scene.has_signal("gold_found"):
			game_scene.gold_found.connect(_on_gold_found)
		if game_scene.has_signal("tool_changed"):
			game_scene.tool_changed.connect(_on_tool_changed)
	else:
		print("Error: Could not load main_game.tscn")

func toggle_pause_menu():
	## Toggles the pause menu visibility
	get_tree().paused = not get_tree().paused
	if pause_menu:
		pause_menu.visible = get_tree().paused

func _on_gold_found(amount: int):
	## Updates the gold counter when gold is found
	if gold_counter and game_scene:
		var current_gold = game_scene.get_gold_count() if game_scene.has_method("get_gold_count") else 0
		gold_counter.text = "Gold: " + str(current_gold)

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