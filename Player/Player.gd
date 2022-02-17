#--------------------------------------#
# Player Script                        #
#--------------------------------------#
extends KinematicBody2D

class_name Player


# Variables:
#---------------------------------------
export var posters_to_fire := 1
export var eggs_to_throw := 1

var _in_player_control := false

var move_speed := 250.0
var mouse_dir := Vector2.ZERO
var move_dir := Vector2.ZERO
var velocity := Vector2.ZERO

onready var _player_camera := $Camera2D
onready var _sprite := $Sprite
onready var _poster_gun := $Gun
onready var _egg_thrower := $EggThrower
onready var collision_shape := $CollisionShape2D
onready var anim_player := $AnimationPlayer
onready var _sfx_player := $AudioStreamPlayer


# Functions:
#---------------------------------------
func _ready() -> void:
	GameEvents.connect("start_game", self, "_on_start_game")
	GameEvents.connect("game_over", self, "_on_game_over")
	
	PlayerStats.connect("power_up_ended", self, "_on_power_up_ended")


func get_input() -> void:
	# movement
	move_dir = Input.get_vector("ui_move_left", "ui_move_right", "ui_move_up", "ui_move_down")
	
	# mouse direciton
	mouse_dir = (get_global_mouse_position() - self.global_position).normalized()
	
	# poster gun fire
	if Input.is_action_just_pressed("ui_shoot_primary") and \
			posters_to_fire <= PlayerStats.poster_ammo:
		_poster_gun.shoot(posters_to_fire)
	
	# egg throw
	if Input.is_action_just_pressed("ui_shoot_secondary") and \
			eggs_to_throw <= PlayerStats.egg_ammo:
		_egg_thrower.shoot(eggs_to_throw)


func _process(delta: float) -> void:
	update_sprites()


func _physics_process(delta: float) -> void:
	if _in_player_control:
		get_input()
		update_movement(delta)


func update_movement(delta: float) -> void:
	velocity = move_dir * move_speed
	velocity = move_and_slide(velocity)


func update_sprites() -> void:
	if move_dir.x > 0:
		_sprite.scale.x = -1
	elif move_dir.x < 0:
		_sprite.scale.x = 1
	
	if PlayerStats.poster_ammo > 0:
		_poster_gun.visible = true
		
	else:
		_poster_gun.visible = false
	
	if velocity.length() < 1:
		anim_player.play("Idle")
	
	else:
		anim_player.play("Run")


func remove_player_control() -> void:
	move_dir = Vector2.ZERO
	velocity = Vector2.ZERO
	
	anim_player.play("Idle")
	_sfx_player.stop()
	
	_in_player_control = false
	collision_shape.disabled = true
	_player_camera.current = false


func return_player_control() -> void:
	move_dir = Vector2.ZERO
	velocity = Vector2.ZERO
	
	anim_player.play("Idle")
	_sfx_player.stop()
	
	_in_player_control = true
	collision_shape.disabled = false
	_player_camera.current = true


func _on_start_game() -> void:
	_in_player_control = true


func _on_game_over(has_won : bool) -> void:
	_in_player_control = false
	
	move_dir = Vector2.ZERO
	velocity = Vector2.ZERO
	
	anim_player.play("Idle")
	_sfx_player.stop()


func _on_power_up_ended() -> void:
	posters_to_fire = 1
	eggs_to_throw = 1
	
	move_speed = 250.0
