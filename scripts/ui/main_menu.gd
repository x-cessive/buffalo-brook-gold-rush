extends CanvasLayer

## Main Menu for Buffalo Brook Gold Rush
## Features animated buttons with tooltips and smooth transitions

# UI Elements
@onready var menu_panel: Panel = $MenuPanel
@onready var title_label: Label = $TitleLabel
@onready var start_button: Button = $MenuPanel/StartButton
@onready var settings_button: Button = $MenuPanel/SettingsButton
@onready var quit_button: Button = $MenuPanel/QuitButton

# Animation parameters
var button_animation_offset: float = 0.1  # Vertical offset for animation
var animation_speed: float = 3.0
var target_positions: Dictionary = {}

# Signals
signal game_started
signal settings_requested
signal quit_requested

func _ready():
	## Initialize the main menu
	_setup_buttons()
	_setup_animations()
	_setup_signals()
	
	# Position elements off-screen initially for animation
	_position_elements_offscreen()
	
	# Animate elements in
	await get_tree().create_timer(0.1).timeout
	_animate_menu_in()

func _setup_buttons():
	## Configure buttons with animation script and tooltips
	# Convert regular buttons to animated buttons if needed
	if start_button.get_script() == null:
		# This is handled by the scene setup, but we'll configure properties
		start_button.set("meta/tooltip_text", "Start a new gold panning adventure")
	
	if settings_button.get_script() == null:
		settings_button.set("meta/tooltip_text", "Adjust game settings and preferences")
	
	if quit_button.get_script() == null:
		quit_button.set("meta/tooltip_text", "Exit the game to desktop")

func _setup_animations():
	## Store target positions for animation
	target_positions["start_button"] = $MenuPanel/StartButton.position
	target_positions["settings_button"] = $MenuPanel/SettingsButton.position
	target_positions["quit_button"] = $MenuPanel/QuitButton.position

func _setup_signals():
	## Connect button signals
	start_button.pressed.connect(_on_start_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _position_elements_offscreen():
	## Position menu elements off-screen for initial animation
	title_label.position.y = -100
	$MenuPanel/StartButton.position.y = get_viewport_rect().size.y + 100
	$MenuPanel/SettingsButton.position.y = get_viewport_rect().size.y + 150
	$MenuPanel/QuitButton.position.y = get_viewport_rect().size.y + 200

func _animate_menu_in():
	## Animate menu elements into view
	var tween = create_tween()
	
	# Animate title
	tween.tween_property(title_label, "position:y", get_viewport_rect().size.y * 0.2, 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	# Animate buttons with delays
	tween.tween_property($MenuPanel/StartButton, "position:y", target_positions["start_button"].y, 0.6).set_delay(0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property($MenuPanel/SettingsButton, "position:y", target_positions["settings_button"].y, 0.6).set_delay(0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property($MenuPanel/QuitButton, "position:y", target_positions["quit_button"].y, 0.6).set_delay(0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

func _animate_menu_out():
	## Animate menu elements off-screen
	var tween = create_tween()
	
	# Animate title
	tween.tween_property(title_label, "position:y", -100, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	# Animate buttons
	tween.tween_property($MenuPanel/StartButton, "position:y", get_viewport_rect().size.y + 100, 0.5).set_delay(0.1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($MenuPanel/SettingsButton, "position:y", get_viewport_rect().size.y + 150, 0.5).set_delay(0.1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($MenuPanel/QuitButton, "position:y", get_viewport_rect().size.y + 200, 0.5).set_delay(0.1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	return tween

func _on_start_pressed():
	## Handle start button press
	emit_signal("game_started")
	_animate_menu_out()
	
	# In a real game, this would start the main game scene
	print("Game started!")

func _on_settings_pressed():
	## Handle settings button press
	emit_signal("settings_requested")
	_animate_menu_out()
	
	# In a real game, this would open the settings menu
	print("Settings requested!")

func _on_quit_pressed():
	## Handle quit button press
	emit_signal("quit_requested")
	
	# Animate out, then quit
	var animation_tween = _animate_menu_out()
	await animation_tween.finished
	get_tree().quit()

func show_menu():
	## Show the menu with animation
	_position_elements_offscreen()
	visibility = true
	_animate_menu_in()

func hide_menu():
	## Hide the menu
	visibility = false

func _input(event: InputEvent):
	## Handle input for the menu
	if event.is_action_pressed("ui_cancel"):
		# If escape is pressed, handle differently based on context
		_on_quit_pressed()

# Public methods for other systems to interact with the menu
func start_game():
	## Start the game (for external calling)
	_on_start_pressed()

func open_settings():
	## Open settings (for external calling)
	_on_settings_pressed()