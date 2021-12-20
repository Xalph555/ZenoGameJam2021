# Background music singleton
# ------------------------------------

extends Node2D

signal music_stopped
signal music_changed

const TRANS_FADEIN = Tween.TRANS_QUART
const EASE_FADEIN = Tween.EASE_OUT

const TRANS_FADEOUT = Tween.TRANS_LINEAR
const EASE_FADEOUT = Tween.EASE_IN

onready var _music_player = $AudioStreamPlayer
onready var _tween = $Tween


func start_playing() -> void:
	_music_player.playing = true


func stop_playing() -> void:
	_music_player.playing = false


func fade_in(duration : float = 1) -> void:
	_music_player.playing = true
	_tween.interpolate_property(_music_player,'volume_db', _music_player.volume_db, -5, duration, TRANS_FADEIN, EASE_FADEIN)
	_tween.start()
	

func fade_out(duration : float = 1) -> void:
	_tween.interpolate_property(_music_player,'volume_db', _music_player.volume_db, -40, duration, TRANS_FADEIN, EASE_FADEOUT)
	_tween.start()


func change_track(audio : AudioStreamSample, fade_in_duration: float = 1, fade_out_duration: float = 1) -> void:
	fade_out(fade_out_duration)
	yield(_tween, "tween_completed")
	_music_player.stream = audio
	fade_in(fade_in_duration)
	
	emit_signal("music_changed")


func _on_Tween_tween_completed(object, key) -> void:
	if _music_player.volume_db == -40:
		stop_playing()
		emit_signal("music_stopped")
