extends Node2D

## Main Game Scene for Buffalo Brook Gold Rush
## Handles the core gameplay mechanics of gold panning

# Player references
@onready var player: CharacterBody2D = $Player

# Game state variables
var gold_count: int = 0
var current_tool: String = "Basic Pan"
var is_panning: bool = false
var player_speed: float = 200.0

# Signals
signal gold_found(amount: int)
signal tool_changed(tool_name: String)

func _ready():
	## Called when the node enters the scene tree for the first time
	gold_count = 0
	print("Main game scene loaded!")

func _process(delta: float):
	## Called every frame to update game state
	_handle_player_movement(delta)
	_handle_input()

func _handle_player_movement(delta: float):
	## Handles player movement with WASD/Arrow keys
	var velocity = Vector2.ZERO

	# Get input direction
	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		velocity.x += 1
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):
		velocity.y += 1
	if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):
		velocity.y -= 1

	# Normalize velocity and apply speed
	if velocity.length() > 0:
		velocity = velocity.normalized() * player_speed

	# Move the player
	if player:
		player.position += velocity * delta

func _handle_input():
	## Handles player input for interactions
	if Input.is_action_just_pressed("interact") or Input.is_key_pressed(KEY_E):
		_try_to_pan()

func _try_to_pan():
	## Attempts to start a panning action if player is near water
	if is_panning:
		print("Already panning!")
		return

	# Check if player is near water (simple distance check)
	var water_pos = Vector2(640, 500)  # Position of water area
	var distance = player.position.distance_to(water_pos)

	print("Player position: " + str(player.position))
	print("Distance to water: " + str(distance))

	if distance < 250:  # Within range of water (increased range)
		_start_panning()
	else:
		print("Too far from water! Move closer (distance: " + str(int(distance)) + ")")

func _start_panning():
	## Starts the panning action
	is_panning = true
	print("Panning for gold...")

	# Wait 2 seconds then find gold
	await get_tree().create_timer(2.0).timeout

	is_panning = false

	# Random gold amount
	var gold_amount = randi_range(1, 5)
	gold_count += gold_amount
	print("Found " + str(gold_amount) + " gold! Total: " + str(gold_count))
	emit_signal("gold_found", gold_amount)