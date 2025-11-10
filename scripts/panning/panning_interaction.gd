extends Area2D

## Panning interaction script for Buffalo Brook Gold Rush
## Handles the trigger that starts the panning minigame when player presses [E] near water
## Now includes location-specific parameters

# Signal emitted when panning minigame starts
signal panning_started

# Reference to the player character
var player: CharacterBody2D = null

# Check if player is in range and can pan
var player_in_range: bool = false

# Reference to travel system to get location info
var travel_system: Node = null

func _ready():
	## Called when the node enters the scene tree for the first time
	# Connect the body entered and exited signals to track player presence
	body_entered.connect(_on_player_entered)
	body_exited.connect(_on_player_exited)
	
	# Connect to travel system to get location data
	_connect_to_travel_system()

func _connect_to_travel_system():
	## Connects to the travel system to get location-specific parameters
	if "TravelSystem" in get_tree().root:
		travel_system = get_tree().root.get_node("TravelSystem")
		print("Panning interaction connected to travel system")
	elif has_node("/root/Main/TravelSystem"):
		travel_system = get_node("/root/Main/TravelSystem")
		print("Panning interaction connected to travel system")
	else:
		print("WARNING: Panning interaction could not connect to travel system")

func _process(_delta: float):
	## Called every frame to check for input
	if player_in_range and Input.is_action_just_pressed("interact"):
		# Start the panning minigame
		start_panning_minigame()

func _on_player_entered(body: Node):
	## Called when a body enters the interaction area
	if body.has_method("can_pan") and body.has_signal("panning_started"):
		player = body
		player_in_range = true
		# Show interaction prompt to player
		var location_name = "Unknown"
		if travel_system and travel_system.has_method("get_current_location_name"):
			location_name = travel_system.get_current_location_name()
		print("Press [E] to start panning at " + location_name)

func _on_player_exited(body: Node):
	## Called when a body exits the interaction area
	if body == player:
		player_in_range = false
		# Hide interaction prompt from player
		print("Panning prompt hidden")

func start_panning_minigame():
	## Starts the panning minigame if the player can pan
	if player and player.can_pan():
		print("Starting panning minigame")
		# Emit signal to let other systems know panning started
		panning_started.emit()
		
		# Call the panning minigame scene or script
		# This could be handled by the scene manager in a full implementation
		activate_panning_visuals()
		
		# Disable player movement during panning
		if player.has_method("start_panning"):
			player.start_panning()

func activate_panning_visuals():
	## Shows visual elements related to panning
	# This would typically trigger the panning minigame UI or scene
	# For now, we'll just print to indicate it's working
	print("Panning visuals activated")
	
	# In a full implementation, this might:
	# - Show the panning minigame scene
	# - Enable panning-specific controls
	# - Add visual effects to the water area