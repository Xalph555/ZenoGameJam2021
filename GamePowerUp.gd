# Game Power Up Script
# -----------------------------

extends Area2D

export var duration := 5

onready var anim_player := $AnimationPlayer


func _on_GamePowerUp_body_entered(body: Node) -> void:
	body.posters_to_fire = 3
	PlayerStats.start_power_up_timer(duration)
	
	anim_player.play("PickUp")
	yield(anim_player, "animation_finished")
	call_deferred("free")
