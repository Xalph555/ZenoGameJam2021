# Paper Power Up Script
# ----------------------------------

extends Area2D

export var extra_ammo := 10

onready var anim_player := $AnimationPlayer


func _on_PaperPowerUp_body_entered(body: Node) -> void:
	PlayerStats.poster_ammo += extra_ammo
	
	anim_player.play("PickUp")
	yield(anim_player, "animation_finished")
	call_deferred("free")
