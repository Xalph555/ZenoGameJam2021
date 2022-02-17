#--------------------------------------#
# Hurtbox script                       #
#--------------------------------------#
extends Area2D

class_name Hurtbox


# Variables:
#---------------------------------------
onready var _collision_shape = $CollisionShape2D


# Functions:
#---------------------------------------
func disable_collisions() -> void:
	_collision_shape.set_deferred("disabled", true)


func enable_collisions() -> void:
	_collision_shape.set_deferred("disabled", false)
