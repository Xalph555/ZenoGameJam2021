# Poster Gun Script
# --------------------------------

extends Node2D

export(PackedScene) var _poster_scene = _poster_scene as Projectile
export var _projectile_force := 500

onready var _parent := get_parent()
onready var _shoot_dir := Vector2.ZERO

onready var _pivot := $Pivot
onready var _fire_particles := $Pivot/Particles2D
onready var _fire_point := $Pivot/FirePoint
onready var _sfx_player := $AudioStreamPlayer


func _process(delta: float) -> void:
	update_sprite()


func _physics_process(delta: float) -> void:
	_shoot_dir = _parent.mouse_dir
	
	rotation = _shoot_dir.angle()
	rotation_degrees = wrapf(rotation_degrees, 0, 360)


func update_sprite() -> void:
	if rotation_degrees > 90 and rotation_degrees < 270:
		_pivot.scale.y = -1
	else:
		_pivot.scale.y = 1


func shoot(amount: int) -> void:
	for i in range (amount):
		var _poster_temp = _poster_scene.instance() as Projectile
		get_viewport().add_child(_poster_temp)
		
		var projectile_rot = deg2rad((180.0 / (amount + 1)) * (i + 1) + self.rotation_degrees)
	
		_poster_temp.shoot(projectile_rot, _fire_point.global_position, _projectile_force)
		
		PlayerStats.poster_ammo -= 1
	
	_sfx_player.play()
	_fire_particles.emitting = true
