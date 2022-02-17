#--------------------------------------#
# Start Screen Script                  #
#--------------------------------------#
extends Control


# Variables:
#---------------------------------------
onready var anim_player := $AnimationPlayer
export(AudioStreamSample) var _game_music


# Functions:
#---------------------------------------
func _ready() -> void:
	yield(get_tree(), "idle_frame")
	start_sequence()


func start_sequence() -> void:
	yield(get_tree().create_timer(1), "timeout")
	anim_player.play("ShowPosterableObjects")
	yield(anim_player, "animation_finished")
	anim_player.play("GoodLuck")
	yield(anim_player, "animation_finished")
	anim_player.play("ReadyStart")
	BackgroundMusic.change_track(_game_music, 4, 4)
	yield(anim_player, "animation_finished")
	
	
	GameEvents.emit_signal("start_game")
