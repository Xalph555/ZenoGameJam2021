#--------------------------------------#
# Posterable Area Script               #
#--------------------------------------#
extends Area2D

class_name PosterableArea


# Signals
#---------------------------------------
signal area_completed(area, time_to_add)
signal area_progress_changed(progress_percent)

signal player_entered_area(area_ref)
signal player_exited_area(area_ref)


# Variables:
#---------------------------------------
export var area_name := ""
export var points := 0
export var extra_time := 0.0

var posterable_objects = []

var total_health := 0
var current_progress := 0

var is_active := true
var is_intialised := false

onready var collision_shape := $CollisionPolygon2D
onready var _beacon := $Beacon
onready var _player_entered_area := $PlayerEnteredArea


# Functions:
#---------------------------------------
func _process(delta: float) -> void:
	if is_active:
		if is_intialised:
			checked_completed()
			
		else:
			get_posterable_objects()


func get_posterable_objects() -> void:
	if posterable_objects.size() == 0:
		posterable_objects = get_overlapping_bodies()
		
		if total_health == 0:
			set_total_health()
		
		# connect all object_postered signals
		for i in posterable_objects:
			i.connect("health_changed", self, "_on_object_health_changed")
			i.connect("object_postered", self, "_on_object_postered")
		
		is_intialised = true


func checked_completed() -> void:
	if posterable_objects.size() <= 0:
		collision_shape.disabled = true
		
		PlayerStats.score += points
		emit_signal("area_completed", self, extra_time)
		_beacon.visible = false
		
		is_active = false


func set_total_health() -> void:
	for obj in posterable_objects:
		total_health += obj.max_health 


func _on_object_health_changed(amount) -> void:
	current_progress -= amount
	
	var _progress_percent = (current_progress / float(total_health)) * 100
	
	emit_signal("area_progress_changed", _progress_percent)


func _on_object_postered(object) -> void:
	object.disconnect("health_changed", self, "_on_object_health_changed")
	object.disconnect("object_postered", self, "_on_object_postered")
	
	posterable_objects.erase(object)


func _on_PlayerEnteredArea_body_entered(body: Node) -> void:
	var player = body as Player
		
	if not player:
		if body is Car:
			player = body.player_reference as Player
			
			if not player:
				return
		
		else:
			return
			
	if is_active and player: #_player_entered_area.get_overlapping_bodies():
		_beacon.visible = false
		
		emit_signal("player_entered_area", self)


func _on_PlayerEnteredArea_body_exited(body: Node) -> void:
	var player = body as Player
		
	if not player:
		if body is Car:
			player = body.player_reference as Player
			
			if not player:
				return
		
		else:
			return
				
	if is_active and player: #not _player_entered_area.get_overlapping_bodies():
		_beacon.visible = true
		
		emit_signal("player_exited_area", self)
		
