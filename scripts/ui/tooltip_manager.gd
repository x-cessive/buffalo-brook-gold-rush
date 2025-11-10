extends CanvasLayer

## Tooltip manager for Buffalo Brook Gold Rush
## Handles all tooltip displays with animations and positioning

# Tooltip UI elements
@onready var tooltip_panel: Panel = $TooltipPanel
@onready var tooltip_label: Label = $TooltipPanel/TooltipLabel

# Tooltip parameters
var show_delay: float = 0.5  # Time to wait before showing tooltip
var fade_duration: float = 0.2  # Duration of fade in/out animations
var tooltip_offset: Vector2 = Vector2(10, -30)  # Offset from mouse position

# Internal state
var current_tooltip: String = ""
var show_timer: float = 0.0
var is_visible: bool = false
var is_fading_in: bool = false
var is_fading_out: bool = false
var target_alpha: float = 0.0
var current_alpha: float = 0.0

func _ready():
	## Initialize the tooltip manager
	hide_tooltip()
	tooltip_panel.modulate.a = 0.0
	tooltip_panel.size = Vector2(200, 60)

func _process(delta: float):
	## Handle tooltip visibility and animations
	# Update timer if waiting to show tooltip
	if show_timer > 0:
		show_timer -= delta
		if show_timer <= 0:
			_show_current_tooltip()
	
	# Handle fading animations
	if is_fading_in or is_fading_out:
		var fade_speed = delta / fade_duration
		if is_fading_in:
			current_alpha = min(1.0, current_alpha + fade_speed)
			if current_alpha >= 1.0:
				is_fading_in = false
		elif is_fading_out:
			current_alpha = max(0.0, current_alpha - fade_speed)
			if current_alpha <= 0.0:
				is_fading_out = false
				is_visible = false
				tooltip_panel.hide()
		
		tooltip_panel.modulate.a = current_alpha

func show_tooltip_at_position(text: String, position: Vector2):
	## Shows a tooltip at the specified position
	current_tooltip = text
	tooltip_label.text = text
	
	# Update tooltip size based on text
	var font = tooltip_label.get_theme_font("font")
	var font_size = tooltip_label.get_theme_font_size("font_size")
	var text_size = font.get_string_size(text, tooltip_label.get_theme_constant("line_spacing"), tooltip_panel.size.x)
	tooltip_panel.size = Vector2(max(100, text_size.x + 20), max(30, text_size.y + 10))
	
	# Position tooltip
	tooltip_panel.position = position + tooltip_offset
	
	# Start show timer
	show_timer = show_delay

func show_tooltip_for_control(text: String, control: Control):
	## Shows a tooltip for a specific control
	var control_position = control.global_position
	var control_size = control.size
	var position = control_position + Vector2(control_size.x / 2, -10)  # Above center of control
	show_tooltip_at_position(text, position)

func _show_current_tooltip():
	## Actually shows the current tooltip
	if current_tooltip != "" and not is_visible:
		tooltip_panel.show()
		is_visible = true
		is_fading_in = true
		current_alpha = 0.0

func hide_tooltip():
	## Hides the current tooltip
	if is_visible:
		is_fading_out = true
		is_fading_in = false
	show_timer = 0.0

func set_tooltip_delay(delay: float):
	## Sets the delay before showing tooltips
	show_delay = delay

func set_fade_duration(duration: float):
	## Sets the fade in/out duration
	fade_duration = duration

func set_tooltip_offset(offset: Vector2):
	## Sets the offset from the target position
	tooltip_offset = offset

# Function to be called from other scripts to show tooltips
static func show(text: String, position: Vector2):
	## Static function to show tooltip from anywhere in the game
	if get_tree().root.has_node("TooltipManager"):
		var tooltip_manager = get_tree().root.get_node("TooltipManager")
		if tooltip_manager:
			tooltip_manager.show_tooltip_at_position(text, position)

static func show_for_control(text: String, control: Control):
	## Static function to show tooltip for a control
	if get_tree().root.has_node("TooltipManager"):
		var tooltip_manager = get_tree().root.get_node("TooltipManager")
		if tooltip_manager:
			tooltip_manager.show_tooltip_for_control(text, control)

static func hide():
	## Static function to hide tooltip from anywhere in the game
	if get_tree().root.has_node("TooltipManager"):
		var tooltip_manager = get_tree().root.get_node("TooltipManager")
		if tooltip_manager:
			tooltip_manager.hide_tooltip()