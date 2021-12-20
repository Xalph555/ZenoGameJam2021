# Start Screen Script
# -------------------------

extends Control


onready var anim_player := $AnimationPlayer


func _ready() -> void:
	start_sequence()


func start_sequence() -> void:
	yield(get_tree().create_timer(1), "timeout")
	anim_player.play("ShowPosterableObjects")
	yield(anim_player, "animation_finished")
	anim_player.play("GoodLuck")
	yield(anim_player, "animation_finished")
	anim_player.play("ReadyStart")
	yield(anim_player, "animation_finished")
	
	GameEvents.emit_signal("start_game")
