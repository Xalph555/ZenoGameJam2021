# Egg Thrower
# ----------------------------

extends Node2D

export(PackedScene) var _egg_scene = _egg_scene as Projectile
export var _projectile_force := 500

onready var _parent := get_parent()
onready var _shoot_dir := Vector2.ZERO

onready var _fire_point := $FirePoint


func _physics_process(delta: float) -> void:
	_shoot_dir = _parent.mouse_dir
	
	rotation = _shoot_dir.angle()
	rotation_degrees = wrapf(rotation_degrees, 0, 360)


func shoot(amount) -> void:
	for i in range (amount):
		var _egg_temp = _egg_scene.instance() as Projectile
		get_viewport().add_child(_egg_temp)
		
		var projectile_rot = deg2rad((180.0 / (amount + 1.0)) * (i + 1.0) + self.rotation_degrees)
	
		_egg_temp.shoot(projectile_rot, _fire_point.global_position, _projectile_force)
