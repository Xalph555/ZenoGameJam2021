# Player Script
# ------------------------------

extends KinematicBody2D

class_name Player

export var posters_to_fire := 1
export var eggs_to_throw := 1

var _in_player_control := true

var _move_speed := 250.0
var mouse_dir := Vector2.ZERO
var move_dir := Vector2.ZERO
var velocity := Vector2.ZERO

onready var _sprite := $Sprite
onready var _poster_gun := $Gun
onready var _egg_thrower := $EggThrower


func get_input() -> void:
	# movement
	move_dir = Input.get_vector("ui_move_left", "ui_move_right", "ui_move_up", "ui_move_down")
	
	# mouse direciton
	mouse_dir = (get_global_mouse_position() - self.global_position).normalized()
	
	# poster gun fire
	if Input.is_action_just_pressed("ui_shoot_primary"):
		_poster_gun.shoot(posters_to_fire)
	
	# egg throw
	if Input.is_action_just_pressed("ui_shoot_secondary"):
		_egg_thrower.shoot(eggs_to_throw)


func _process(delta: float) -> void:
	update_sprites()


func _physics_process(delta: float) -> void:
	if _in_player_control:
		get_input()
		update_movement(delta)


func update_movement(delta: float) -> void:
	velocity = move_dir * _move_speed
	velocity = move_and_slide(velocity)


func update_sprites() -> void:
	if move_dir.x > 0:
		_sprite.scale.x = 1
	elif move_dir.x < 0:
		_sprite.scale.x = -1


func remove_player_control() -> void:
	_in_player_control = false


func return_player_control() -> void:
	_in_player_control = true
