#--------------------------------------#
# Egg Projectile Script                #
#--------------------------------------#
extends Projectile


# Variables:
#---------------------------------------
onready var _timer := $Timer
onready var _particles := $Particles2D
onready var _sfx := $AudioStreamPlayer2D


# Functions:
#---------------------------------------
func egg_break() -> void:
	_timer.stop()
	move_dir = Vector2.ZERO
	move_speed = 0
	self.self_modulate = Color(1, 1, 1, 0)
	_particles.emitting = true
	_sfx.play()
	yield(get_tree().create_timer(1), "timeout")
	call_deferred("free")


func _on_HurtBox_area_entered(area: Area2D) -> void:
	egg_break()
func _on_HurtBox_body_entered(body: Node) -> void:
	egg_break()


func _on_Timer_timeout() -> void:
	egg_break()
