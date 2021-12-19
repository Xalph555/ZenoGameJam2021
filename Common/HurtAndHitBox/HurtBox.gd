# Hurtbox script
# ----------------------------

extends Area2D

class_name Hurtbox

onready var _collision_shape = $CollisionShape2D


func disable_collisions() -> void:
	_collision_shape.set_deferred("disabled", true)
	#_collision_shape.disabled = true


func enable_collisions() -> void:
	_collision_shape.set_deferred("disabled", false)
	#_collision_shape.disabled = false
