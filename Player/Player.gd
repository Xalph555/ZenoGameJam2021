# Player Script
# ------------------------------

extends KinematicBody2D

export var posters_to_fire := 1
export var eggs_to_throw := 1

var _move_speed := 250.0
var mouse_dir := Vector2.ZERO
var move_dir := Vector2.ZERO
var velocity := Vector2.ZERO

onready var _sprite := $Sprite
onready var _poster_gun := $Gun
onready var _egg_thrower := $EggThrower


func _ready() -> void:
	pass


func _input(event: InputEvent) -> void:
	# movement
	move_dir = Input.get_vector("ui_move_left", "ui_move_right", "ui_move_up", "ui_move_down")
	
	# mouse direciton
	mouse_dir = (get_global_mouse_position() - self.global_position).normalized()
	
	# poster gun fire
	if event.is_action_pressed("ui_shoot_primary"):
		_poster_gun.shoot(posters_to_fire)
	
	# egg throw
	if event.is_action_pressed("ui_shoot_secondary"):
		_egg_thrower.shoot(eggs_to_throw)


func _process(delta: float) -> void:
	update_sprites()


func _physics_process(delta: float) -> void:
	update_movement()


func update_movement() -> void:
	velocity = move_dir * _move_speed
	velocity = move_and_slide(velocity)


func update_sprites() -> void:
	if move_dir.x > 0:
		_sprite.scale.x = 1
	elif move_dir.x < 0:
		_sprite.scale.x = -1
