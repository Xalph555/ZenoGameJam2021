#--------------------------------------#
# Poster Remover Script                #
#--------------------------------------#
extends KinematicBody2D

class_name PosterRemover


# Variables:
#---------------------------------------
export(NodePath) onready var _assigned_area = get_node(_assigned_area) as PosterableArea

export var heal_amount := 10
export(AudioStreamSample) var sfx_poster_rip

var _move_speed := 180.0
var _move_dir := Vector2.ZERO
var _velocity := Vector2.ZERO

#var _dist_to_target := 0.0

var _target = null
var _can_heal := false

var is_stunned := false

var _path := []
var _navigation_area : Navigation2D

onready var _heal_rate_timer := $HealRate
onready var _stun_timer := $StunTimer

onready var _anim_player := $AnimationPlayer
onready var _sfx_player := $AudioStreamPlayer2D
onready var _sprite := $Sprite
onready var _heal_particles := $Particles2D


# Functions:
#---------------------------------------
func _ready() -> void:
	yield(get_tree(), "idle_frame")
	
	var tree = get_tree()
	if tree.has_group("NavigationArea"):
		_navigation_area = tree.get_nodes_in_group("NavigationArea")[0]


func _process(delta: float) -> void:
	if !is_stunned:
		if _target:
			heal_target()

		else:
			find_target()


func _physics_process(delta: float) -> void:
	if !is_stunned:
		update_movement(delta)
		update_sprite()


func update_movement(delta: float) -> void:
	if _target:
		if _path.size() > 0:
			if _velocity.length() > self.global_position.distance_to(_path[0]):
				_velocity = self.global_position.direction_to(_path[0]) * (_move_speed)
#				_velocity *= 0.5
				
			else:
				_velocity = self.global_position.direction_to(_path[0]) * _move_speed
			
#			if global_position == _path[0]:
			if self.global_position.distance_to(_path[0]) < 15:
				_path.pop_front()
				
		else:
			_velocity = Vector2.ZERO

			
	else:
		_velocity = Vector2.ZERO
	
	_velocity = move_and_slide(_velocity)


func generate_path(destination : Vector2) -> void:
	if not _navigation_area:
		return
	
	_path = _navigation_area.get_simple_path(self.global_position, destination)


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
#	if _can_heal and _dist_to_target < 15:
	if _can_heal and _path.size() <= 0:
		_can_heal = false
		_target.heal_object(heal_amount)
		
		_heal_particles.emitting = true
		_sfx_player.stream = sfx_poster_rip
		_sfx_player.play()
		
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
			generate_path(_target.global_position)
			
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
	
	_anim_player.play("Idle")
