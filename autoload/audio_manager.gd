extends Node

## Audio manager for Buffalo Brook Gold Rush
## Handles all game sounds including gold discovery effects

# Audio buses (for sound categories)
var sfx_bus: int = 0  # Sound effects bus
var music_bus: int = 1  # Music bus

# Sound file paths
const GOLD_DISCOVERY_SOUNDS = [
	"res://assets/audio/sfx/gold_found_1.wav",
	"res://assets/audio/sfx/gold_found_2.wav",
	"res://assets/audio/sfx/gold_found_3.wav"
]

# Preloaded audio streams
var _gold_discovery_streams: Array[AudioStream] = []

func _ready():
	## Initialize the audio manager
	_preload_audio_streams()
	
	# Find audio buses by name
	for i in range(AudioServer.bus_count):
		if AudioServer.get_bus_name(i) == "SFX":
			sfx_bus = i
		elif AudioServer.get_bus_name(i) == "Music":
			music_bus = i
	
	print("Audio manager initialized with " + str(_gold_discovery_streams.size()) + " gold discovery sounds")

func _preload_audio_streams():
	## Preloads audio streams to reduce loading times during gameplay
	for sound_path in GOLD_DISCOVERY_SOUNDS:
		if ResourceLoader.exists(sound_path):
			var stream = load(sound_path) as AudioStream
			if stream:
				_gold_discovery_streams.append(stream)
				print("Preloaded sound: " + sound_path)
		else:
			print("Warning: Sound file not found: " + sound_path)

func play_gold_discovery_sound():
	## Plays a random gold discovery sound
	if _gold_discovery_streams.size() > 0:
		# Pick a random sound from the collection
		var random_sound = _gold_discovery_streams[randi() % _gold_discovery_streams.size()]
		
		# Create temporary audio player for the sound
		var audio_player = AudioStreamPlayer.new()
		audio_player.stream = random_sound
		audio_player.bus = AudioServer.get_bus_name(sfx_bus)
		audio_player.volume_db = linear_to_db(0.7)  # Default volume at 70%
		
		# Add to parent node and play
		add_child(audio_player)
		audio_player.play()
		
		# Remove the player after it finishes playing
		audio_player.finished.connect(_remove_audio_player.bind(audio_player))

func _remove_audio_player(player: AudioStreamPlayer):
	## Removes the temporary audio player after it finishes playing
	if player and is_instance_valid(player):
		remove_child(player)
		player.queue_free()

## Other sound methods would go here
func play_sound(sound_path: String, volume: float = 0.7, bus_name: String = "SFX"):
	## Plays a specified sound file
	var stream = load(sound_path) as AudioStream
	if stream:
		var audio_player = AudioStreamPlayer.new()
		audio_player.stream = stream
		audio_player.bus = bus_name
		audio_player.volume_db = linear_to_db(volume)
		
		add_child(audio_player)
		audio_player.play()
		
		audio_player.finished.connect(_remove_audio_player.bind(audio_player))

func set_bus_volume(bus_name: String, volume_db: float):
	## Sets the volume for a specific audio bus
	for i in range(AudioServer.bus_count):
		if AudioServer.get_bus_name(i) == bus_name:
			AudioServer.set_bus_volume_db(i, volume_db)
			return

func get_bus_volume(bus_name: String) -> float:
	## Gets the current volume for a specific audio bus
	for i in range(AudioServer.bus_count):
		if AudioServer.get_bus_name(i) == bus_name:
			return AudioServer.get_bus_volume_db(i)
	return 0.0