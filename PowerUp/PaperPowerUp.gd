#--------------------------------------#
# Paper Powerup Script                 #
#--------------------------------------#
extends Area2D


# Variables:
#---------------------------------------
export var extra_ammo := 10

onready var anim_player := $AnimationPlayer


# Functions:
#---------------------------------------
func _on_PaperPowerUp_body_entered(body: Node) -> void:
	var player := body as Player
	
	if not player:
		if body is Car:
			player = body.player_reference as Player
			
			if not player:
				return
		
		else:
			return
		
	PlayerStats.poster_ammo += extra_ammo
	
	anim_player.play("PickUp")
	yield(anim_player, "animation_finished")
	call_deferred("free")
