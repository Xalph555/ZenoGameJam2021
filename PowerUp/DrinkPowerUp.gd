#--------------------------------------#
# Paper Powerup Script                 #
#--------------------------------------#
extends Area2D


# Variables:
#---------------------------------------
export var duration := 5

onready var anim_player := $AnimationPlayer


# Functions:
#---------------------------------------
func _on_DrinkPowerUp_body_entered(body: Node) -> void:
	var player := body as Player
	
	if not player:
		if body is Car:
			player = body.player_reference as Player
			
			if not player:
				return
		
		else:
			return
	
	player.move_speed *= 1.5
	PlayerStats.start_power_up_timer(duration)
	
	anim_player.play("PickUp")
	yield(anim_player, "animation_finished")
	call_deferred("free")
