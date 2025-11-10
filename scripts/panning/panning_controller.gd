extends Node2D

## Panning minigame controller script for Buffalo Brook Gold Rush
## Handles the core mechanics of gold panning including particle separation, gold detection, and minigame state

# Signals that communicate minigame events to other systems
signal panning_success(gold_found)     # Emitted when player successfully finds gold
signal panning_failure()               # Emitted when player fails to find gold
signal minigame_started()              # Emitted when panning minigame begins
signal minigame_ended()                # Emitted when panning minigame ends
signal sediment_removed(amount)        # Emitted when sediment is successfully removed from pan
signal water_added()                   # Emitted when player adds water to the pan

# Panning mechanics variables
var pan_contents: Array = []           # Array containing particles currently in the pan (sediment, gold, debris)
var gold_count: int = 0                # Number of gold particles found in current panning session
var sediment_count: int = 0            # Amount of sediment in the pan (affects visibility)
var pan_tilt_angle: float = 0.0        # Current angle of the pan (for particle separation)
var water_amount: float = 100.0        # Current water level in the pan (affects particle movement)
var max_water: float = 150.0           # Maximum water capacity of the pan
var min_water: float = 30.0            # Minimum water needed for effective panning

# Timing and progression variables
var panning_time: float = 0.0          # Time spent panning in current session
var max_panning_time: float = 30.0     # Maximum time allowed for panning session
var success_threshold: float = 0.7     # Threshold for determining successful panning (0.0 to 1.0)

# Input handling variables
var _pan_rotation_speed: float = 2.0   # Speed at which pan rotates when tilted
var _shake_intensity: float = 0.0      # Current intensity of pan shaking
var _shake_decay_rate: float = 0.1     # How quickly shaking stops after input

# Environmental factors affecting panning
var current_weather_effect: float = 1.0  # Weather modifier (rain might affect visibility)
var location_richness: float = 1.0         # Location modifier for gold density

func _ready():
	## Called when the node enters the scene tree for the first time
	print("Panning minigame controller initialized")
	# Initialize pan with some sediment
	_generate_initial_sediment()

func _process(delta: float):
	## Called every frame to update panning mechanics
	if Input.is_action_pressed("pan_tilt_left"):
		pan_tilt_angle = max(pan_tilt_angle - (_pan_rotation_speed * delta), -1.0)
	if Input.is_action_pressed("pan_tilt_right"):
		pan_tilt_angle = min(pan_tilt_angle + (_pan_rotation_speed * delta), 1.0)
	
	# Apply decay to shake intensity over time
	if _shake_intensity > 0:
		_shake_intensity = max(_shake_intensity - (_shake_decay_rate / delta), 0.0)
		_apply_panning_effects(delta)
	
	panning_time += delta
	
	# End minigame if max time exceeded
	if panning_time >= max_panning_time:
		end_panning_minigame()

func _input(event: InputEvent):
	## Handles input events for panning actions
	if event.is_action_pressed("pan_shake"):
		_shake_pan()
	if event.is_action_pressed("pan_add_water"):
		_add_water()
	if event.is_action_pressed("pan_remove_water"):
		_remove_water()
	if event.is_action_pressed("end_panning"):
		end_panning_minigame()

func _apply_panning_effects(delta: float):
	## Simulates the separation of heavier particles (gold) from lighter particles (sediment)
	# This is where physics would be applied to separate particles based on density
	var effective_separation = abs(pan_tilt_angle) * _shake_intensity * current_weather_effect
	
	# Reduce sediment based on effective separation
	var sediment_removed = effective_separation * delta * 10
	if sediment_count > 0:
		var actual_removal = min(sediment_removed, sediment_count)
		sediment_count -= actual_removal
		sediment_removed.emit(actual_removal)
	
	# Detect gold particles that remain after sediment is removed
	var gold_detected = _detect_gold_particles(effective_separation)
	if gold_detected > 0:
		_collect_gold(gold_detected)

func _detect_gold_particles(separation_factor: float) -> int:
	## Detects gold particles based on separation effectiveness
	# Simulate gold detection algorithm
	var detection_chance = separation_factor * location_richness
	if randf() < detection_chance:
		# Random number of gold particles found based on location richness
		return randi_range(1, 3) * location_richness
	return 0

func _collect_gold(amount: int):
	## Collects gold particles and updates state
	gold_count += amount
	panning_success.emit(amount)

func _shake_pan():
	## Applies shaking motion to the pan to separate particles
	_shake_intensity = min(_shake_intensity + 0.5, 1.0)
	
	# Temporarily increase water sloshing for more effective separation
	var additional_separation = _shake_intensity * 0.2
	sediment_count = max(0, sediment_count - (additional_separation * 20))
	sediment_removed.emit(additional_separation * 20)

func _add_water():
	## Adds water to the pan to improve particle separation
	if water_amount < max_water:
		water_amount = min(water_amount + 20.0, max_water)
		water_added.emit()

func _remove_water():
	## Removes water from the pan to concentrate heavier particles
	if water_amount > min_water:
		water_amount = max(water_amount - 10.0, min_water)
		# Removing water helps concentrate gold particles
		_shake_intensity = min(_shake_intensity + 0.2, 1.0)

func _generate_initial_sediment():
	## Populates the pan with initial sediment and potential gold particles
	sediment_count = randi_range(30, 60)
	# Add some randomness to gold generation based on location richness
	var gold_chance = 0.3 * location_richness
	if randf() < gold_chance:
		gold_count = randi_range(1, 3)
	
	# Adjust based on environmental factors
	sediment_count *= current_weather_effect

func start_panning_minigame():
	## Initializes the panning minigame state
	panning_time = 0.0
	gold_count = 0
	_generate_initial_sediment()
	minigame_started.emit()
	print("Panning minigame started")

func end_panning_minigame():
	## Ends the panning minigame and evaluates results
	var success_rate = float(gold_count) / max(1, gold_count + sediment_count)

	if success_rate >= success_threshold:
		panning_success.emit(gold_count)
	else:
		panning_failure.emit()
	
	minigame_ended.emit()
	print("Panning minigame ended")

func set_location_richness(richness: float):
	## Adjusts the gold density based on the current location
	location_richness = clamp(richness, 0.1, 3.0)

func set_weather_effect(effect: float):
	## Adjusts panning effectiveness based on current weather
	current_weather_effect = clamp(effect, 0.5, 1.5)

func get_panning_efficiency() -> float:
	## Calculates current panning efficiency based on technique and conditions
	return abs(pan_tilt_angle) * _shake_intensity * (water_amount / max_water) * current_weather_effect