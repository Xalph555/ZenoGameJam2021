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


func fade_in() -> void:
	_music_player.playing = true
	_tween.interpolate_property(_music_player,'volume_db', _music_player.volume_db, -5, 2, TRANS_FADEIN, EASE_FADEIN)
	_tween.start()
	

func fade_out() -> void:
	_tween.interpolate_property(_music_player,'volume_db', _music_player.volume_db, -40, 2, TRANS_FADEIN, EASE_FADEOUT)
	_tween.start()


func change_track(audio : AudioStreamSample) -> void:
	fade_out()
	yield(_tween, "tween_completed")
	_music_player.stream = audio
	fade_in()
	
	emit_signal("music_changed")


func _on_Tween_tween_completed(object, key) -> void:
	if _music_player.volume_db == -40:
		stop_playing()
		emit_signal("music_stopped")
