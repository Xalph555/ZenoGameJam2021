# Poster Remvoer Script
# --------------------------------------

extends KinematicBody2D
class_name PosterRemover

export(NodePath) onready var _assigned_area = get_node(_assigned_area) as PosterableArea

export var heal_amount := 10

var _move_speed := 180.0
var _move_dir := Vector2.ZERO
var _velocity := Vector2.ZERO

var _dist_to_target := 0.0

var _target = null
var _can_heal := false

var is_stunned := false

onready var _heal_rate_timer := $HealRate
onready var _stun_timer := $StunTimer

onready var _anim_player := $AnimationPlayer
onready var _sprite := $Sprite
onready var _heal_particles := $Particles2D


func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	if !is_stunned:
		if _target:
			_dist_to_target = self.global_position.distance_to(_target.global_position)
			heal_target()

		else:
			find_target()


func _physics_process(delta: float) -> void:
	if !is_stunned:
		update_movement(delta)


func update_movement(delta: float) -> void:
	if _target:
		if _dist_to_target > 15:
			_move_dir = self.global_position.direction_to(_target.global_position)
			
		else:
			_move_dir = Vector2.ZERO
	
	_velocity = _move_dir * _move_speed
	_velocity = move_and_slide(_velocity)


func update_sprite() -> void:
	# sprite direction
	if _move_dir.x > 0:
		_sprite.scale.x = -1
	elif _move_dir.x < 0:
		_sprite.scale.x = 1
	
	if _velocity.length() < 1:
		_anim_player.play("Idle")
	
	else:
		_anim_player.play("Run")


func heal_target() -> void:
	if _can_heal and _dist_to_target < 15:
		_can_heal = false
		_target.health += heal_amount
		
		_heal_particles.emitting = true
		
		if _target.health == _target.max_health:
			_target.is_npc_targetable = true
			
			_target.disconnect("object_postered", self, "_on_object_postered")
			_target = null
		
		else:
			_heal_rate_timer.start()


func find_target() -> void:
	for i in _assigned_area.posterable_objects:
		if (i.health > 0 and i.health < i.max_health) and i.is_npc_targetable:
			_target = i
			_target.is_npc_targetable = false
			
			_can_heal = true
			
			_target.connect("object_postered", self, "_on_object_postered")
			
			break


func _on_HealRate_timeout() -> void:
	_can_heal = true


func _on_object_postered(object) -> void:
	_target.disconnect("object_postered", self, "_on_object_postered")
	_target = null


func _on_HurtBox_area_entered(area: Area2D) -> void:
	_stun_timer.start()
	
	is_stunned = true
	_velocity = Vector2.ZERO
	
	_anim_player.play("Stunned")


func _on_StunTimer_timeout() -> void:
	is_stunned = false
	
	_anim_player.stop()
