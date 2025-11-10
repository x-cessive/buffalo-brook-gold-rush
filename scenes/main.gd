extends Node2D

## Main scene script for Buffalo Brook Gold Rush
## Entry point for the game and manager of main game states

var game_scene: Node2D = null
var gold_counter: Label = null
var tool_indicator: Label = null

func _ready():
	## Called when the node enters the scene tree for the first time
	print("Buffalo Brook Gold Rush starting...")

	# Find UI elements
	gold_counter = $GameUI/HUD/GoldCounter
	tool_indicator = $GameUI/HUD/ToolIndicator

	# Get reference to the main game scene (already instanced in the scene tree)
	game_scene = $MainGame

	print("Game initialized and ready to play!")

func _process(_delta: float):
	## Called every frame
	pass

