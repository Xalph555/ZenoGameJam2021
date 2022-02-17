#--------------------------------------#
# Car Script                           #
#--------------------------------------#
extends KinematicBody2D

class_name Car


# Variables:
#---------------------------------------
export(AudioStreamSample) var sfx_car_drive
export(AudioStreamSample) var sfx_car_interact

var _in_player_control := false
var player_reference : Player
var _player_enter_pos := Vector2.ZERO

# car movement vars
var _friction := -0.7 # lower max speed - make larger
var _drag := -0.0001 # lower max speed - make smaller

var _wheel_dist := 50.0
var _steering_angle := 60.0

var _move_speed := 200.0
var _acceleration := Vector2.ZERO

var _break_speed := -200.0
var _max_reverse_speed := 400

var _slip_speed := 100.0
var _traction_fast := 0.6
var _traction_slow := 0.7

var _steer_angle := 0.0
var velocity := Vector2.ZERO

onready var _player_camera = $Camera2D
onready var _interact_label = $LabelPosition
onready var _sfx_player = $AudioStreamPlayer2D


# Functions:
#---------------------------------------
func _ready() -> void:
	GameEvents.connect("game_over", self, "_on_game_over")


func _input(event: InputEvent) -> void:
	if player_reference:
		if event.is_action_pressed("ui_interact"):
			if !_in_player_control:
				player_enter_car()
				
			elif _in_player_control:
				player_exit_car()


func get_input() -> void:
	var turn = 0
	
	if Input.is_action_pressed("ui_move_right"):
		turn += 1
	if Input.is_action_pressed("ui_move_left"):
		turn -= 1
	
	_steer_angle = turn * deg2rad(_steering_angle)

	if Input.is_action_pressed("ui_move_up"):
		_acceleration = transform.x * _move_speed
	
	if Input.is_action_pressed("ui_move_down"):
		_acceleration = transform.x * _break_speed


func _physics_process(delta: float) -> void:
	update_movement(delta)
	
	_interact_label.global_rotation = 0
	if _in_player_control:
		_interact_label.visible = false


func update_movement(delta: float) -> void:
	_acceleration = Vector2.ZERO
	
	if _in_player_control:
		get_input() 
	
	calculate_steering(delta)
	apply_friction()
	
	velocity += _acceleration * delta
	velocity = move_and_slide(velocity)


func calculate_steering(delta: float) -> void:
	var _rear_wheels := position - (transform.x * _wheel_dist / 2.0)
	var _front_wheels := position + (transform.x * _wheel_dist / 2.0)
	
	_rear_wheels += velocity * delta
	_front_wheels += velocity.rotated(_steer_angle) * delta
	
	var _forward_dir := (_front_wheels - _rear_wheels).normalized()
	
	var _traction := _traction_slow
	if velocity.length() > _slip_speed:
		_traction = _traction_fast
	
	var d := _forward_dir.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.linear_interpolate(_forward_dir * velocity.length(), _traction)
	
	if d < 0:
		velocity = -_forward_dir * min(velocity.length(), _max_reverse_speed)

	rotation = _forward_dir.angle()


func apply_friction() -> void:
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	
	var _friction_force = velocity * _friction
	var _drag_force = velocity * velocity.length() * _drag
	
	_acceleration += _drag_force + _friction_force


func player_enter_car() -> void:
	player_reference.remove_player_control()
	_in_player_control = true
	
	_player_enter_pos = to_local(player_reference.global_position)
	
	player_reference.visible = false
	_interact_label.visible = false
	
	_player_camera.current = true
	
	play_sfx(sfx_car_interact)
	yield(get_tree().create_timer(0.5), "timeout")
	play_sfx(sfx_car_drive)


func player_exit_car() -> void:
	play_sfx(sfx_car_interact)
	
	player_reference.return_player_control()
	_in_player_control = false
	
	player_reference.global_position = to_global(_player_enter_pos)
	
	player_reference.visible = true
	
	_player_camera.current = false


func play_sfx(sfx : AudioStreamSample) -> void:
	_sfx_player.stop()
	_sfx_player.stream = sfx
	_sfx_player.play()


func _on_PlayerInteractArea_body_entered(body: Node) -> void:
	player_reference = body as Player
	
	if player_reference != null:
		_interact_label.visible = true


func _on_PlayerInteractArea_body_exited(body: Node) -> void:
	if !_in_player_control and body == player_reference:
		player_reference = null
		_interact_label.visible = false


func _on_game_over(has_won : bool) -> void:
	_in_player_control = false
