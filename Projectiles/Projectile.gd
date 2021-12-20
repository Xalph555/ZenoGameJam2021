# General Projectile Script
# -------------------------

extends Sprite

class_name Projectile

export var rot_adjust := 0.0

var move_speed := 0.0

var move_dir := Vector2(0, -1)
var velocity := Vector2.ZERO


func _physics_process(delta: float) -> void:
	velocity = move_dir * move_speed
	position += velocity * delta


func shoot(shoot_rot: float, start_pos: Vector2, projectile_speed: float) -> void:
	move_dir = move_dir.rotated(shoot_rot)
	move_speed = projectile_speed
	rotation = shoot_rot + rot_adjust
	self.global_position = start_pos
