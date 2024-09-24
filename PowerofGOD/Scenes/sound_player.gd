extends Node2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = AudioStreamPlayer2D.new()

var music_tracks = {
	"SSS": "res://Sounds/Treachery.mp3",
	"menu": "res://Sounds/Menu music.mp3",
	
}

var sound_effects = {
	"hit":"res://Sounds/hitHurt.wav",
	"sword":"res://Sounds/sword.wav.wav",
	 
	}

var music_db = 1
var sound_db = 1.5

func change_music_db(val: float) -> void:
	music_db = linear_to_db(val)
	
func change_sound_db(val: float) -> void:
	sound_db = linear_to_db(val)
	
func _ready() -> void:
	pass#audio_stream_player_2d.stream = load(music_tracks["menu"])
	#add_child(audio_stream_player_2d)
	#audio_stream_player_2d.play()

func play_sfx(sfx) :
	var sound : AudioStreamPlayer2D = audio_stream_player_2d.duplicate()
	sound.stream = load(sound_effects[sfx])
	add_child(sound)
	sound.play()
	await sound.finished
	print("sound finished")
	sound.queue_free()
	
	
