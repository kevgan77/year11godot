extends Node2D

@onready var audio_stream_player_2d: AudioStreamPlayer = AudioStreamPlayer.new()

var music_tracks = {
	"SSS": "res://Sounds/Treachery.mp3",
	"menu": "res://Sounds/Menu music.mp3",
	"Envi": "res://Sounds/Environment or Battle.mp3",
	"Flamenco": "res://Sounds/Dance in the Firelight.mp3",
}

var sound_effects = {
	"hit":"res://Sounds/hitHurt.wav",
	"sword":"res://Sounds/sword.wav.wav",
	"jump":"res://Sounds/jump.wav",
	"womp":"res://Sounds/womp_womp.mp3"
	}

var music_db = 1
var sound_db = 1

func change_music_db(val: float) -> void:
	music_db = linear_to_db(val)
	
func change_sound_db(val: float) -> void:
	sound_db = linear_to_db(val)
	
func _ready() -> void:
	audio_stream_player_2d.stream = load(music_tracks["Flamenco"])
	add_child(audio_stream_player_2d)
	audio_stream_player_2d.play()

func change_music_track(track):
	audio_stream_player_2d.stream = load(music_tracks[track])
	audio_stream_player_2d.play()
	
func play_sfx(sfx) :
	var sound : AudioStreamPlayer = audio_stream_player_2d.duplicate()
	sound.stream = load(sound_effects[sfx])
	add_child(sound)
	sound.play()
	await sound.finished
	print("sound finished")
	sound.queue_free()
	
#func _exit_tree() -> void:
	#audio_stream_player_2d.stop()
	#audio_stream_player_2d.queue_free()
