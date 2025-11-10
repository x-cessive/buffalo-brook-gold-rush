extends Node2D

## Gold discovery effect system for Buffalo Brook Gold Rush
## Handles visual sparkle effects when gold is found
## Audio is handled by the global audio manager

# Reference to particle system
@onready var sparkle_particles = $SparkleParticles

# Visual effect properties
var sparkle_duration: float = 1.0  # Duration of the sparkle effect in seconds
var sparkle_count: int = 10        # Number of sparkle particles to create
var sparkle_area: Vector2 = Vector2(30, 30)  # Area where sparkles appear

func _ready():
	## Initialize the gold discovery effect system
	hide()  # Hide by default until triggered
	
	# Configure particle system
	if sparkle_particles:
		sparkle_particles.emitting = false
		sparkle_particles.one_shot = true

func trigger_gold_discovery_effect(position: Vector2):
	## Triggers the visual sparkle and sound effects at the given position
	# Position the effect where the gold was found
	global_position = position
	
	# Show the effect node
	show()
	
	# Trigger the sparkle particles
	_trigger_sparkle_effect()
	
	# Play the success sound through the audio manager
	AudioManager.play_gold_discovery_sound()
	
	# Hide the effect after duration
	await get_tree().create_timer(sparkle_duration).timeout
	hide()

func _trigger_sparkle_effect():
	## Activates the sparkle particle system
	if sparkle_particles:
		# Reset and configure particles
		sparkle_particles.position = Vector2.ZERO
		sparkle_particles.process_material = _create_sparkle_material()
		
		# Emit particles
		sparkle_particles.emitting = true

func _create_sparkle_material():
	## Creates a material for the sparkle particles with gold-like appearance
	var material = ParticleProcessMaterial.new()
	
	# Set gold/yellow colors for the particles
	material.albedo_color = Color.YELLOW
	material.particle_flag_align_y = true
	
	# Configure emission
	material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_POINT
	material.emission_point_count = sparkle_count
	
	# Configure particle lifetime
	material.lifetime = sparkle_duration
	material.lifetime_randomness = 0.3
	material.initial_velocity_min = 5.0
	material.initial_velocity_max = 20.0
	
	# Configure size over lifetime
	material.scale_multiplier = 0.5
	material.particle_flag_disable_size_scale = false
	
	# Configure color over lifetime (start bright, fade out)
	var color_ramp = Gradient.new()
	color_ramp.add_point(0.0, Color.YELLOW.lightened(1.0))
	color_ramp.add_point(0.7, Color.YELLOW.lightened(0.5))
	color_ramp.add_point(1.0, Color.YELLOW.darkened(2.0))
	material.color_ramp = color_ramp
	
	return material

# Public method to customize effect properties
func set_sparkle_properties(count: int, duration: float, area: Vector2):
	## Allows customization of sparkle effect properties
	sparkle_count = count
	sparkle_duration = duration
	sparkle_area = area