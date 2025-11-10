extends CanvasLayer

## Settings Menu for Buffalo Brook Gold Rush
## Features animated controls with tooltips and smooth transitions

# UI Elements
@onready var settings_panel: Panel = $SettingsPanel
@onready var title_label: Label = $TitleLabel
@onready var volume_label: Label = $SettingsPanel/VolumeSection/VolumeLabel
@onready var volume_slider: HSlider = $SettingsPanel/VolumeSection/VolumeSlider
@onready var music_volume_label: Label = $SettingsPanel/MusicSection/MusicVolumeLabel
@onready var music_volume_slider: HSlider = $SettingsPanel/MusicSection/MusicVolumeSlider
@onready var resolution_label: Label = $SettingsPanel/ResolutionSection/ResolutionLabel
@onready var resolution_option: OptionButton = $SettingsPanel/ResolutionSection/ResolutionOption
@onready var fullscreen_checkbox: CheckBox = $SettingsPanel/FullscreenSection/FullscreenCheckbox
@onready var vsync_checkbox: CheckBox = $SettingsPanel/VSyncSection/VSyncCheckbox
@onready var apply_button: Button = $SettingsPanel/ControlButtons/ApplyButton
@onready var back_button: Button = $SettingsPanel/ControlButtons/BackButton

# Animation parameters
var animation_duration: float = 0.4
var slide_offset: float = 100  # Horizontal offset for animations

# Default settings values
var original_volume: float = 1.0
var original_music_volume: float = 1.0
var original_resolution: int = 0
var original_fullscreen: bool = false
var original_vsync: bool = false

# Signals
signal settings_applied
signal settings_closed

func _ready():
	## Initialize the settings menu
	visibility = false  # Start hidden
	_setup_settings_controls()
	_setup_buttons()
	_setup_signals()
	_capture_original_settings()

func _setup_settings_controls():
	## Configure all settings controls with tooltips and initial values
	# Volume slider
	volume_slider.min_value = 0.0
	volume_slider.max_value = 1.0
	volume_slider.value = original_volume
	volume_slider.set("meta/tooltip_text", "Adjust overall game volume (affects all sounds)")
	
	# Music volume slider
	music_volume_slider.min_value = 0.0
	music_volume_slider.max_value = 1.0
	music_volume_slider.value = original_music_volume
	music_volume_slider.set("meta/tooltip_text", "Adjust music volume level")
	
	# Resolution options
	resolution_option.clear()
	resolution_option.add_item("800x600")
	resolution_option.add_item("1024x768")
	resolution_option.add_item("1280x720")
	resolution_option.add_item("1280x1024")
	resolution_option.add_item("1920x1080")
	resolution_option.selected = original_resolution
	resolution_option.set("meta/tooltip_text", "Select your preferred game resolution")
	
	# Fullscreen checkbox
	fullscreen_checkbox.button_pressed = original_fullscreen
	fullscreen_checkbox.set("meta/tooltip_text", "Toggle fullscreen/windowed mode")
	
	# VSync checkbox
	vsync_checkbox.button_pressed = original_vsync
	vsync_checkbox.set("meta/tooltip_text", "Enable vertical sync to reduce screen tearing")

func _setup_buttons():
	## Configure buttons with tooltips
	apply_button.set("meta/tooltip_text", "Apply the current settings changes")
	back_button.set("meta/tooltip_text", "Return to previous menu without applying changes")

func _setup_signals():
	## Connect all necessary signals
	apply_button.pressed.connect(_on_apply_pressed)
	back_button.pressed.connect(_on_back_pressed)
	
	# Connect control changes to enable apply button
	volume_slider.value_changed.connect(_on_setting_changed)
	music_volume_slider.value_changed.connect(_on_setting_changed)
	resolution_option.item_selected.connect(_on_setting_changed)
	fullscreen_checkbox.toggled.connect(_on_setting_changed)
	vsync_checkbox.toggled.connect(_on_setting_changed)

func _capture_original_settings():
	## Capture current settings to allow for reset
	original_volume = volume_slider.value
	original_music_volume = music_volume_slider.value
	original_resolution = resolution_option.selected
	original_fullscreen = fullscreen_checkbox.button_pressed
	original_vsync = vsync_checkbox.button_pressed

func show_settings_menu():
	## Show the settings menu with animations
	visibility = true
	
	# Position elements off-screen initially
	_position_elements_offscreen()
	
	# Animate elements in with staggered timing
	var tween = create_tween()
	
	# Animate settings panel
	tween.tween_property(settings_panel, "modulate:a", 1.0, animation_duration)
	
	# Animate section headers and controls
	tween.tween_property($SettingsPanel/VolumeSection, "position:x", 
		100, animation_duration).set_delay(0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property($SettingsPanel/MusicSection, "position:x", 
		100, animation_duration).set_delay(0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property($SettingsPanel/ResolutionSection, "position:x", 
		100, animation_duration).set_delay(0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property($SettingsPanel/FullscreenSection, "position:x", 
		100, animation_duration).set_delay(0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property($SettingsPanel/VSyncSection, "position:x", 
		100, animation_duration).set_delay(0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property($SettingsPanel/ControlButtons, "position:x", 
		100, animation_duration).set_delay(0.35).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func hide_settings_menu():
	## Hide the settings menu with animations
	var tween = create_tween()
	
	# Animate section headers and controls out
	tween.tween_property($SettingsPanel/VolumeSection, "position:x", 
		-get_viewport_rect().size.x - slide_offset, animation_duration).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($SettingsPanel/MusicSection, "position:x", 
		-get_viewport_rect().size.x - slide_offset, animation_duration).set_delay(0.05).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($SettingsPanel/ResolutionSection, "position:x", 
		-get_viewport_rect().size.x - slide_offset, animation_duration).set_delay(0.1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($SettingsPanel/FullscreenSection, "position:x", 
		-get_viewport_rect().size.x - slide_offset, animation_duration).set_delay(0.15).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($SettingsPanel/VSyncSection, "position:x", 
		-get_viewport_rect().size.x - slide_offset, animation_duration).set_delay(0.2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($SettingsPanel/ControlButtons, "position:x", 
		-get_viewport_rect().size.x - slide_offset, animation_duration).set_delay(0.25).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	# Fade out panel after controls animate out
	tween.tween_property(settings_panel, "modulate:a", 0.0, animation_duration).set_delay(0.3)
	
	# Actually hide after animation completes
	await tween.finished
	visibility = false

func _position_elements_offscreen():
	## Position all elements off-screen for initial animation
	$SettingsPanel/VolumeSection.position.x = -get_viewport_rect().size.x - slide_offset
	$SettingsPanel/MusicSection.position.x = -get_viewport_rect().size.x - slide_offset
	$SettingsPanel/ResolutionSection.position.x = -get_viewport_rect().size.x - slide_offset
	$SettingsPanel/FullscreenSection.position.x = -get_viewport_rect().size.x - slide_offset
	$SettingsPanel/VSyncSection.position.x = -get_viewport_rect().size.x - slide_offset
	$SettingsPanel/ControlButtons.position.x = -get_viewport_rect().size.x - slide_offset
	settings_panel.modulate.a = 0.0

func _on_setting_changed(_value = null):
	## Called when any setting is changed, enables apply button
	apply_button.disabled = false

func _on_apply_pressed():
	## Apply current settings
	apply_current_settings()
	emit_signal("settings_applied")
	
	# Disable apply button since settings are applied
	apply_button.disabled = true
	_capture_original_settings()  # Update original settings

func _on_back_pressed():
	## Return to previous menu, discarding unsaved changes
	if _has_unsaved_changes():
		# Ask user if they want to discard changes
		confirm_discard_changes()
	else:
		emit_signal("settings_closed")
		hide_settings_menu()

func _has_unsaved_changes() -> bool:
	## Check if any settings have been changed from original values
	return (volume_slider.value != original_volume or 
	        music_volume_slider.value != original_music_volume or
	        resolution_option.selected != original_resolution or
	        fullscreen_checkbox.button_pressed != original_fullscreen or
	        vsync_checkbox.button_pressed != original_vsync)

func confirm_discard_changes():
	## Confirm with user before discarding changes
	print("User would be asked to confirm discarding changes in a full implementation")
	# In a full implementation, this would show a confirmation dialog
	emit_signal("settings_closed")
	hide_settings_menu()

func apply_current_settings():
	## Apply the current settings to the game
	# Apply volume settings
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(volume_slider.value))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_volume_slider.value))
	
	# Apply resolution (implementation depends on project setup)
	match resolution_option.selected:
		0: # 800x600
			ProjectSettings.set_setting("display/window/size/viewport_width", 800)
			ProjectSettings.set_setting("display/window/size/viewport_height", 600)
		1: # 1024x768
			ProjectSettings.set_setting("display/window/size/viewport_width", 1024)
			ProjectSettings.set_setting("display/window/size/viewport_height", 768)
		2: # 1280x720
			ProjectSettings.set_setting("display/window/size/viewport_width", 1280)
			ProjectSettings.set_setting("display/window/size/viewport_height", 720)
		3: # 1280x1024
			ProjectSettings.set_setting("display/window/size/viewport_width", 1280)
			ProjectSettings.set_setting("display/window/size/viewport_height", 1024)
		4: # 1920x1080
			ProjectSettings.set_setting("display/window/size/viewport_width", 1920)
			ProjectSettings.set_setting("display/window/size/viewport_height", 1080)
	
	# Apply fullscreen
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen_checkbox.button_pressed 
	                              else DisplayServer.WINDOW_MODE_WINDOWED)
	
	# Apply VSync
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if vsync_checkbox.button_pressed 
	                                    else DisplayServer.VSYNC_DISABLED)

func reset_to_defaults():
	## Reset all settings to default values
	volume_slider.value = 1.0
	music_volume_slider.value = 1.0
	resolution_option.selected = 2  # Default to 1280x720
	fullscreen_checkbox.set_pressed_no_signal(false)
	vsync_checkbox.set_pressed_no_signal(true)
	
	apply_current_settings()
	_capture_original_settings()
	apply_button.disabled = true

func _input(event: InputEvent):
	## Handle input for the settings menu
	if event.is_action_pressed("ui_cancel") and visible:
		_on_back_pressed()

# Public methods for external control
func close_settings():
	## Close the settings menu (for external calling)
	_on_back_pressed()

func get_current_volume() -> float:
	## Get current volume setting
	return volume_slider.value

func get_current_music_volume() -> float:
	## Get current music volume setting
	return music_volume_slider.value

func get_fullscreen_state() -> bool:
	## Get current fullscreen setting
	return fullscreen_checkbox.button_pressed