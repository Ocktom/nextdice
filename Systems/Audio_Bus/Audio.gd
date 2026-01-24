extends Node

@onready var sfx : AudioStreamPlayer2D = $Audio_FX
@onready var music : AudioStreamPlayer2D = $Audio_Music

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.audio_node = self

func play_sfx(stream_path : String):
	
	print ("playing sfx audio")
	sfx.stream = load(stream_path)
	sfx.play()

func play_music(stream_path: String):
	print ("playing music audio")
	music.stream = load(stream_path)
	music.play()

func play_random (sound_array : Array[String]):
	var path_pick = sound_array.pick_random()
	play_sfx(path_pick)
