extends Node2D

## Panning minigame script for Buffalo Brook Gold Rush
## Implements the core panning mechanics, particle separation, and random gold revelation
## Now includes location difficulty and tool type modifiers

# Load probability tables
const LocationTables = preload("res://resources/data/location_probability_tables.gd")
const ToolTables = preload("res://resources/data/tool_probability_tables.gd")
const LocationDataScript = preload("res://scripts/environment/location_data.gd")

# Signals for minigame events
signal panning_success(gold_found)
signal panning_ended
signal gold_found(amount)

# Game state variables
var is_active: bool = false
var gold_particles: Array = []
var sediment_particles: Array = []
var pan_capacity: int = 50
var current_sediment: int = 0
var total_gold_found: int = 0

# Minigame timing
var panning_time: float = 0.0
var max_panning_time: float = 30.0

# Panning mechanics variables
var tilt_angle: float = 0.0
var shake_intensity: float = 0.0
var water_level: float = 100.0
var separation_efficiency: float = 0.5

# Location and tool modifiers (set by external systems)
var location_difficulty: LocationTables.LocationDifficulty = LocationTables.LocationDifficulty.MODERATE
var tool_type: ToolTables.ToolType = ToolTables.ToolType.BASIC_PAN

# Calculated modifiers based on location and tool
var location_probability_modifier: float = 1.0
var tool_probability_modifier: float = 1.0
var location_sediment_modifier: float = 1.0
var tool_efficiency_modifier: float = 1.0

# References to UI elements
@onready var particle_container = $ParticleContainer
@onready var gold_counter = $UI/GoldCounter
@onready var timer_label = $UI/TimerLabel

# Gold discovery effect reference
var gold_discovery_effect_scene = preload("res://scenes/effects/gold_discovery_effect.tscn")
var gold_discovery_effect: Node2D = null

func _ready():
	## Initialize the minigame
	hide()  # Start hidden until triggered
	# Initialize modifiers with default values
	_update_modifiers()
	
	# Preload gold discovery effect scene
	if gold_discovery_effect_scene:
		gold_discovery_effect = gold_discovery_effect_scene.instantiate()

func _process(delta: float):
	## Update the minigame while active
	if is_active:
		panning_time += delta
		
		# Update timer display
		if timer_label:
			timer_label.text = str(int(max_panning_time - panning_time))
		
		# Update particle physics based on panning actions
		_update_particle_physics(delta)
		
		# Check if time is up
		if panning_time >= max_panning_time:
			end_panning_minigame()

func _input(event: InputEvent):
	## Handle minigame-specific input
	if is_active:
		if event.is_action_pressed("pan_tilt_left"):
			tilt_angle = -1.0
		elif event.is_action_released("pan_tilt_left") and tilt_angle < 0:
			tilt_angle = 0.0
		
		if event.is_action_pressed("pan_tilt_right"):
			tilt_angle = 1.0
		elif event.is_action_released("pan_tilt_right") and tilt_angle > 0:
			tilt_angle = 0.0
		
		if event.is_action_pressed("pan_shake"):
			shake_intensity = 1.0
		elif event.is_action_released("pan_shake"):
			shake_intensity = 0.0
		
		if event.is_action_pressed("exit_panning"):
			end_panning_minigame()

func _update_modifiers():
	## Updates all probability and efficiency modifiers based on location and tool
	# Update location-based modifiers
	location_probability_modifier = LocationTables.LOCATION_PROBABILITY_TABLE[location_difficulty]
	location_sediment_modifier = LocationTables.LOCATION_SEDIMENT_DENSITY_TABLE[location_difficulty]
	
	# Update tool-based modifiers
	tool_probability_modifier = ToolTables.TOOL_PROBABILITY_TABLE[tool_type]
	tool_efficiency_modifier = ToolTables.TOOL_EFFICIENCY_TABLE[tool_type]
	
	# Adjust max panning time based on location difficulty
	var time_modifier = LocationTables.LOCATION_TIME_MODIFIER_TABLE[location_difficulty]
	max_panning_time = 30.0 * time_modifier

func set_location_difficulty(difficulty: LocationTables.LocationDifficulty):
	## Sets the location difficulty and updates modifiers
	location_difficulty = difficulty
	_update_modifiers()
	print("Location difficulty set to: " + str(difficulty))

func set_tool_type(tool: ToolTables.ToolType):
	## Sets the tool type and updates modifiers
	tool_type = tool
	_update_modifiers()
	print("Tool type set to: " + str(tool))

func start_panning_minigame():
	## Initialize and start the panning minigame
	is_active = true
	panning_time = 0.0
	total_gold_found = 0
	gold_particles.clear()
	sediment_particles.clear()
	
	# Update modifiers at the start of each session
	_update_modifiers()
	
	# Generate initial sediment and potential gold based on modifiers
	_generate_initial_particles()
	
	# Show the minigame UI
	show()
	
	print("Panning minigame started with location: " + str(location_difficulty) + 
	      " and tool: " + str(tool_type))

func _generate_initial_particles():
	## Creates initial particles in the pan (sediment and hidden gold)
	# Adjust sediment amount based on location difficulty
	var base_sediment = randi_range(30, 50)
	current_sediment = int(base_sediment * location_sediment_modifier)
	
	# Calculate how many gold particles to hide based on location difficulty and tool type
	var base_gold_range = LocationTables.LOCATION_GOLD_RANGE_TABLE[location_difficulty]
	var base_gold_count = randi_range(base_gold_range.min, base_gold_range.max)
	var tool_multiplier = ToolTables.TOOL_PROBABILITY_TABLE[tool_type]
	var potential_gold_count = int(base_gold_count * tool_multiplier * location_probability_modifier)
	
	# Generate positions for particles in the pan area
	for i in range(current_sediment):
		var particle = _create_particle(Vector2(randf_range(-50, 50), randf_range(-30, 30)), "sediment")
		sediment_particles.append(particle)
		particle_container.add_child(particle)
	
	# Hide gold particles among sediment (not visible initially)
	for i in range(potential_gold_count):
		var gold_pos = Vector2(randf_range(-40, 40), randf_range(-20, 20))
		var gold_particle = _create_particle(gold_pos, "gold", false)  # Hidden initially
		gold_particles.append({"particle": gold_particle, "revealed": false, "position": gold_pos})
		particle_container.add_child(gold_particle)

func _create_particle(position: Vector2, particle_type: String, visible: bool = true):
	## Creates a visual particle for the minigame
	var particle_sprite = ColorRect.new()
	particle_sprite.position = position
	particle_sprite.visible = visible

	# Set appearance based on particle type
	match particle_type:
		"sediment":
			# Brown/gray sediment particles
			particle_sprite.size = Vector2(randf_range(3, 6), randf_range(3, 6))
			particle_sprite.color = Color(0.4 + randf() * 0.2, 0.3 + randf() * 0.1, 0.2, 1.0)
		"gold":
			# Shiny gold particles with glow effect
			particle_sprite.size = Vector2(randf_range(4, 8), randf_range(4, 8))
			particle_sprite.color = Color(1.0, 0.85, 0.3, 1.0)
			# Add a subtle glow animation
			var tween = create_tween().set_loops()
			tween.tween_property(particle_sprite, "modulate:a", 0.7, 0.5)
			tween.tween_property(particle_sprite, "modulate:a", 1.0, 0.5)

	return particle_sprite

func _update_particle_physics(delta: float):
	## Simulates the physics of separating particles based on panning actions
	if tilt_angle != 0:
		_apply_tilt_physics(delta)
	
	if shake_intensity > 0:
		_apply_shake_physics(delta)
	
	# Check for gold revelation based on technique effectiveness
	_check_for_gold_revelation()

func _apply_tilt_physics(delta: float):
	## Applies physics to particles based on pan tilt
	# Apply tool efficiency modifier to the tilt effect
	var tilt_effect = tilt_angle * 10.0 * delta * tool_efficiency_modifier
	
	# Move sediment particles toward the lower side of the pan
	for particle in sediment_particles:
		particle.position.x += tilt_effect
		# Keep particles within pan bounds
		particle.position.x = clamp(particle.position.x, -60, 60)
	
	# Gold particles also move but with different physics (they're heavier)
	for gold_data in gold_particles:
		if not gold_data["revealed"]:
			var gold_particle = gold_data["particle"]
			gold_particle.position.x += tilt_effect * 0.7  # Gold moves less due to weight
			gold_particle.position.x = clamp(gold_particle.position.x, -60, 60)

func _apply_shake_physics(delta: float):
	## Applies shaking physics to help separate particles
	# Apply tool efficiency modifier to the shake effect
	var shake_effect = shake_intensity * 5.0 * delta * tool_efficiency_modifier
	
	# Apply random movement to simulate shaking
	for particle in sediment_particles:
		particle.position += Vector2(randf_range(-shake_effect, shake_effect), 
		                            randf_range(-shake_effect, shake_effect))
		particle.position.x = clamp(particle.position.x, -60, 60)
		particle.position.y = clamp(particle.position.y, -40, 40)
	
	# Gold particles also move but settle faster due to weight
	for gold_data in gold_particles:
		if not gold_data["revealed"]:
			var gold_particle = gold_data["particle"]
			gold_particle.position += Vector2(randf_range(-shake_effect * 0.5, shake_effect * 0.5), 
			                                 randf_range(-shake_effect * 0.5, shake_effect * 0.5))
			gold_particle.position.x = clamp(gold_particle.position.x, -60, 60)
			gold_particle.position.y = clamp(gold_particle.position.y, -40, 40)

func _check_for_gold_revelation():
	## Randomly reveals gold particles based on panning technique effectiveness
	var technique_effectiveness = (abs(tilt_angle) + shake_intensity) / 2.0
	
	# Apply modifiers to technique effectiveness
	var tool_technique_bonus = ToolTables.TOOL_TECHNIQUE_BONUS_TABLE[tool_type]
	var modified_technique = technique_effectiveness * tool_technique_bonus
	
	# Calculate combined probability modifier
	var combined_modifier = location_probability_modifier * tool_probability_modifier
	
	# Get location-specific gold rarity modifier from travel system if available
	var location_rarity_modifier = _get_location_rarity_modifier()
	
	# Get weather effect on gold visibility
	var weather_visibility_modifier = _get_weather_visibility_modifier()
	
	# Only check for revelation if we have significant technique
	if modified_technique > 0.3:
		for gold_data in gold_particles:
			if not gold_data["revealed"]:
				# Chance to reveal gold based on technique effectiveness and modifiers
				var base_chance = modified_technique * 0.05
				var final_chance = base_chance * combined_modifier * location_rarity_modifier * weather_visibility_modifier
				
				if randf() < final_chance:
					gold_data["revealed"] = true
					gold_data["particle"].visible = true
					gold_data["particle"].modulate = Color.GOLD  # Make it clearly visible
					
					# Apply tool quality modifier to the gold found
					var quality_multiplier = ToolTables.TOOL_QUALITY_TABLE[tool_type]
					var gold_value = int(1 * quality_multiplier)
					
					# Apply location-specific value multiplier (some locations have higher value gold)
					var location_value_multiplier = _get_location_value_multiplier()
					gold_value = int(gold_value * location_value_multiplier)
					
					# Emit signal when gold is revealed
					emit_signal("gold_found", gold_value)
					total_gold_found += gold_value
					
					# Update gold counter display
					if gold_counter:
						gold_counter.text = str(total_gold_found)
					
					# Trigger visual and sound effects for gold discovery
					_trigger_gold_discovery_effect(gold_data["particle"].global_position)

func _get_location_rarity_modifier() -> float:
	## Returns the location-specific gold rarity modifier
	# Try to get the travel system to access location data
	if "TravelSystem" in get_tree().root:
		var travel_system = get_tree().root.get_node("TravelSystem")
		if travel_system and travel_system.has_method("get_current_location"):
			var current_loc = travel_system.get_current_location()
			return LocationDataScript.get_gold_rarity_multiplier(current_loc)
	
	# Default to 1.0 if no travel system is available
	return 1.0

func _get_weather_visibility_modifier() -> float:
	## Returns the weather effect on gold visibility
	# Try to get the weather system to access current weather data
	if "WeatherSystem" in get_tree().root:
		var weather_system = get_tree().root.get_node("WeatherSystem")
		if weather_system and weather_system.has_method("get_gold_visibility_multiplier"):
			return weather_system.get_gold_visibility_multiplier()
	
	# Default to 1.0 if no weather system is available
	return 1.0

func _get_location_value_multiplier() -> float:
	## Returns the location-specific gold value multiplier
	# Try to get the travel system to access location data
	if "TravelSystem" in get_tree().root:
		var travel_system = get_tree().root.get_node("TravelSystem")
		if travel_system and travel_system.has_method("get_current_location"):
			var current_loc = travel_system.get_current_location()
			var location_data = LocationDataScript.get_location_by_id(current_loc)
			if location_data:
				# Higher difficulty locations might have higher value gold
				return 1.0 + (location_data.difficulty * 0.05)  # 5% more value per difficulty level
	
	# Default to 1.0 if no travel system is available
	return 1.0

func _trigger_gold_discovery_effect(position: Vector2):
	## Creates and triggers the gold discovery visual and sound effect
	if gold_discovery_effect:
		# Add the effect to the scene
		add_child(gold_discovery_effect)
		
		# Position and trigger the effect
		gold_discovery_effect.global_position = position
		gold_discovery_effect.trigger_gold_discovery_effect(position)

func end_panning_minigame():
	## Ends the panning minigame and returns to the main game
	is_active = false
	
	# Emit signal with total gold found
	emit_signal("panning_success", total_gold_found)
	emit_signal("panning_ended")
	
	# Add gold to player's inventory via the player controller
	_add_gold_to_player(total_gold_found)
	
	# Hide the minigame UI
	hide()
	
	# Clear all particles
	for particle in particle_container.get_children():
		particle.queue_free()
	
	# Reset variables
	gold_particles.clear()
	sediment_particles.clear()
	
	print("Panning minigame ended. Gold found: " + str(total_gold_found))

func _add_gold_to_player(gold_amount: int):
	## Adds gold to the player's inventory through the player controller
	var player = get_parent().get_node("Player") as CharacterBody2D
	if player and player.has_method("add_gold"):
		player.add_gold(gold_amount)
	else:
		# If we can't find the player directly, try to add through the inventory system
		if "Inventory" in get_tree().root:
			var inventory = get_tree().root.get_node("Inventory") as Node
			if inventory:
				inventory.add_gold(gold_amount)
				print("Added " + str(gold_amount) + " gold through global inventory")
			else:
				print("Could not add gold to inventory - system not found")
		else:
			print("Could not add gold to player - Player node not found")

func get_gold_found():
	## Returns the total gold found in the current minigame
	return total_gold_found

func get_modifiers_info():
	## Returns information about current modifiers for debugging/feedback
	return {
		"location_difficulty": location_difficulty,
		"tool_type": tool_type,
		"location_probability": location_probability_modifier,
		"tool_probability": tool_probability_modifier,
		"tool_efficiency": tool_efficiency_modifier,
		"sediment_modifier": location_sediment_modifier
	}