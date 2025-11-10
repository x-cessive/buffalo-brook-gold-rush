extends Control

## Main menu for Buffalo Brook Gold Rush
## Provides game start, settings, and exit options

@onready var play_button = $PlayButton
@onready var settings_button = $SettingsButton
@onready var quit_button = $QuitButton
@onready var title = $Title

var time_passed: float = 0.0

func _ready():
	## Called when the node enters the scene tree for the first time
	_setup_button_animations()
	_animate_title_entrance()

func _process(delta: float):
	## Animate the title with a gentle pulse
	time_passed += delta
	var pulse = 1.0 + sin(time_passed * 2.0) * 0.05
	if title:
		title.scale = Vector2(pulse, pulse)

func _setup_button_animations():
	## Setup hover animations for buttons
	if play_button:
		play_button.mouse_entered.connect(_on_button_hover.bind(play_button))
		play_button.mouse_exited.connect(_on_button_unhover.bind(play_button))
	if settings_button:
		settings_button.mouse_entered.connect(_on_button_hover.bind(settings_button))
		settings_button.mouse_exited.connect(_on_button_unhover.bind(settings_button))
	if quit_button:
		quit_button.mouse_entered.connect(_on_button_hover.bind(quit_button))
		quit_button.mouse_exited.connect(_on_button_unhover.bind(quit_button))

func _animate_title_entrance():
	## Animate the title sliding in
	if title:
		title.modulate.a = 0.0
		var tween = create_tween()
		tween.tween_property(title, "modulate:a", 1.0, 1.0)

func _on_button_hover(button: Button):
	## Animate button on hover
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1.1, 1.1), 0.1)

func _on_button_unhover(button: Button):
	## Animate button on unhover
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.1)

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