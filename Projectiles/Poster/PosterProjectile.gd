#--------------------------------------#
# Poster projectile Script             #
#--------------------------------------#
extends Projectile


# Variables:
#---------------------------------------
onready var _timer := $Timer
onready var _sfx := $AudioStreamPlayer2D


# Functions:
#---------------------------------------
func remove_flying_poster() -> void:
	_timer.stop()
	move_dir = Vector2.ZERO
	move_speed = 0
	_sfx.play()
	yield(get_tree().create_timer(0.1), "timeout")
	call_deferred("free")


func _on_HurtBox_area_entered(area: Area2D) -> void:
	remove_flying_poster()
func _on_HurtBox_body_entered(body: Node) -> void:
	remove_flying_poster()


func _on_Timer_timeout() -> void:
	remove_flying_poster()
