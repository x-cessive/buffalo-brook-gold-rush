extends CanvasLayer

## Pause Menu for Buffalo Brook Gold Rush
## Features animated buttons with tooltips and smooth fade transitions

# UI Elements
@onready var pause_panel: Panel = $PausePanel
@onready var title_label: Label = $TitleLabel
@onready var resume_button: Button = $PausePanel/ResumeButton
@onready var settings_button: Button = $PausePanel/SettingsButton
@onready var main_menu_button: Button = $PausePanel/MainMenuButton
@onready var quit_button: Button = $PausePanel/QuitButton

# Animation and state parameters
var is_paused: bool = false
var fade_duration: float = 0.3
var button_offset: float = 50  # Initial offset for animations

# Signals
signal game_resumed
signal settings_requested
signal return_to_main_menu
signal quit_requested

func _ready():
	## Initialize the pause menu
	hide()  # Start hidden
	_setup_buttons()
	_setup_signals()
	_position_buttons_offscreen()

func _setup_buttons():
	## Configure buttons with appropriate tooltips
	# Set tooltip properties for each button
	resume_button.set("meta/tooltip_text", "Resume your gold panning adventure")
	settings_button.set("meta/tooltip_text", "Adjust game settings and preferences")
	main_menu_button.set("meta/tooltip_text", "Return to the main menu")
	quit_button.set("meta/tooltip_text", "Exit the game to desktop")

func _setup_signals():
	## Connect button signals
	resume_button.pressed.connect(_on_resume_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _position_buttons_offscreen():
	## Position buttons off-screen for animation
	$PausePanel/ResumeButton.position.x = get_viewport_rect().size.x + button_offset
	$PausePanel/SettingsButton.position.x = get_viewport_rect().size.x + button_offset
	$PausePanel/MainMenuButton.position.x = get_viewport_rect().size.x + button_offset
	$PausePanel/QuitButton.position.x = get_viewport_rect().size.x + button_offset

func show_pause_menu():
	## Show the pause menu with animations
	is_paused = true
	visibility = true
	
	# Fade in the panel
	var tween = create_tween()
	tween.tween_property(pause_panel, "modulate:a", 1.0, fade_duration)
	
	# Animate buttons in with staggered timing
	tween.tween_property($PausePanel/ResumeButton, "position:x", 
		pause_panel.position.x + 50, 0.5).set_delay(0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property($PausePanel/SettingsButton, "position:x", 
		pause_panel.position.x + 50, 0.5).set_delay(0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property($PausePanel/MainMenuButton, "position:x", 
		pause_panel.position.x + 50, 0.5).set_delay(0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property($PausePanel/QuitButton, "position:x", 
		pause_panel.position.x + 50, 0.5).set_delay(0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func hide_pause_menu():
	## Hide the pause menu with animations
	is_paused = false
	var tween = create_tween()
	
	# Animate buttons out
	tween.tween_property($PausePanel/ResumeButton, "position:x", 
		get_viewport_rect().size.x + button_offset, 0.4).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($PausePanel/SettingsButton, "position:x", 
		get_viewport_rect().size.x + button_offset, 0.4).set_delay(0.1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($PausePanel/MainMenuButton, "position:x", 
		get_viewport_rect().size.x + button_offset, 0.4).set_delay(0.1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($PausePanel/QuitButton, "position:x", 
		get_viewport_rect().size.x + button_offset, 0.4).set_delay(0.1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	# Fade out the panel after buttons animate out
	tween.tween_property(pause_panel, "modulate:a", 0.0, fade_duration).set_delay(0.3)
	
	# Actually hide after fade completes
	await tween.finished
	visibility = false

func toggle_pause_menu():
	## Toggle the pause menu on/off
	if is_paused:
		hide_pause_menu()
		emit_signal("game_resumed")
	else:
		show_pause_menu()

func _on_resume_pressed():
	## Handle resume button press
	hide_pause_menu()
	emit_signal("game_resumed")

func _on_settings_pressed():
	## Handle settings button press
	emit_signal("settings_requested")
	hide_pause_menu()

func _on_main_menu_pressed():
	## Handle main menu button press
	emit_signal("return_to_main_menu")
	hide_pause_menu()

func _on_quit_pressed():
	## Handle quit button press
	emit_signal("quit_requested")
	hide_pause_menu()

func _input(event: InputEvent):
	## Handle input for the pause menu
	if event.is_action_pressed("pause") and visible:  # Assuming "pause" is set to Esc or P
		_on_resume_pressed()

func get_pause_state() -> bool:
	## Returns whether the game is currently paused
	return is_paused

# Public methods for external control
func resume_game():
	## Resume the game (for external calling)
	_on_resume_pressed()

func open_settings_from_pause():
	## Open settings from pause menu (for external calling)
	_on_settings_pressed()