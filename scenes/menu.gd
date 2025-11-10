extends Control

## Main menu for Buffalo Brook Gold Rush
## Provides game start, settings, and exit options

func _ready():
	## Called when the node enters the scene tree for the first time
	pass

func _on_PlayButton_pressed():
	## Handles play button press - starts the game
	print("Starting Buffalo Brook Gold Rush...")
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_SettingsButton_pressed():
	## Handles settings button press
	print("Opening settings...")
	# For now, just print message; in full game this would open settings
	pass

func _on_QuitButton_pressed():
	## Handles quit button press
	print("Quitting Buffalo Brook Gold Rush...")
	get_tree().quit()