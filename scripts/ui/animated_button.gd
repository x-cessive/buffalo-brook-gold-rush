extends Button

## Animated button for Buffalo Brook Gold Rush
## Provides hover, press, and selection animations with tooltips

# Animation parameters
@export var hover_scale: float = 1.1  # Scale when hovered
@export var press_scale: float = 0.95  # Scale when pressed
@export var animation_speed: float = 8.0  # Animation speed
@export var pulse_animation: bool = false  # Whether to pulse when idle
@export var pulse_intensity: float = 0.05  # How much to pulse
@export var pulse_speed: float = 2.0  # How fast to pulse

# Tooltip parameters
@export var button_tooltip_text: String = ""
@export var tooltip_delay: float = 0.5  # Time to show tooltip

# Internal state
var is_hovered: bool = false
var is_pressed: bool = false
var target_scale: float = 1.0
var current_scale: float = 1.0
var hover_timer: float = 0.0
var tooltip_visible: bool = false
var tooltip_label: Label = null

# For pulsing animation
var pulse_offset: float = 0.0

func _ready():
	## Initialize the animated button
	# Set initial scale
	scale = Vector2(current_scale, current_scale)
	
	# Connect to mouse signals
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)
	
	# Create tooltip if needed
	if button_tooltip_text != "":
		_create_tooltip()

func _process(delta: float):
	## Update animations and tooltip visibility
	# Update scale animation
	if current_scale != target_scale:
		current_scale = lerp(current_scale, target_scale, delta * animation_speed)
		scale = Vector2(current_scale, current_scale)
	
	# Handle pulsing animation if enabled
	if pulse_animation and not is_hovered and not is_pressed:
		pulse_offset += delta * pulse_speed
		var pulse_amount = sin(pulse_offset) * pulse_intensity
		var pulse_scale = 1.0 + pulse_amount
		scale = Vector2(pulse_scale, pulse_scale)
	
	# Handle tooltip delay
	if is_hovered and not tooltip_visible:
		hover_timer += delta
		if hover_timer >= tooltip_delay:
			show_tooltip()
	else:
		hover_timer = 0.0

func _on_mouse_entered():
	## Called when mouse enters the button area
	is_hovered = true
	target_scale = hover_scale
	hover_timer = 0.0

func _on_mouse_exited():
	## Called when mouse exits the button area
	is_hovered = false
	is_pressed = false
	target_scale = 1.0
	hide_tooltip()

func _on_button_down():
	## Called when button is pressed down
	is_pressed = true
	target_scale = press_scale

func _on_button_up():
	## Called when button is released
	is_pressed = false
	if is_hovered:
		target_scale = hover_scale
	else:
		target_scale = 1.0

func _create_tooltip():
	## Creates and configures the tooltip label
	tooltip_label = Label.new()
	tooltip_label.text = button_tooltip_text
	tooltip_label.size = Vector2(200, 50)
	tooltip_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tooltip_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	tooltip_label.add_theme_color_override("font_color", Color.WHITE)
	tooltip_label.add_theme_color_override("background_color", Color(0, 0, 0, 0.8))
	tooltip_label.visible = false
	
	# Add to parent or root
	var parent = get_parent()
	if parent:
		parent.add_child(tooltip_label)
	else:
		# If no parent, add to root
		var root = get_tree().root
		root.add_child(tooltip_label)

func show_tooltip():
	## Shows the tooltip at the appropriate position
	if tooltip_label:
		# Position tooltip near the button
		var button_position = global_position
		tooltip_label.position = button_position + Vector2(0, -60)  # Above button
		tooltip_label.visible = true
		tooltip_visible = true

func hide_tooltip():
	## Hides the tooltip
	if tooltip_label:
		tooltip_label.visible = false
		tooltip_visible = false

func set_tooltip(new_tooltip: String):
	## Updates the button's tooltip text
	button_tooltip_text = new_tooltip
	if tooltip_label:
		tooltip_label.text = new_tooltip

# Custom button styles
func set_idle_style(style: StyleBox):
	## Sets the style for the idle button state
	add_theme_stylebox_override("normal", style)

func set_hover_style(style: StyleBox):
	## Sets the style for the hover button state
	add_theme_stylebox_override("hover", style)

func set_pressed_style(style: StyleBox):
	## Sets the style for the pressed button state
	add_theme_stylebox_override("pressed", style)

func set_disabled_style(style: StyleBox):
	## Sets the style for the disabled button state
	add_theme_stylebox_override("disabled", style)