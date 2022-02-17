#--------------------------------------#
# Indicator Arrow Script               #
#--------------------------------------#
extends Control


# Variables:
#---------------------------------------
export var _max_arrow_dist := 350.0
export var _arrow_dist_check := 2000.0

var target setget set_target

onready var _arrow_image := $TextureRect


# Functions:
#---------------------------------------
func _process(delta: float) -> void:
	var displacement = target.get_global_transform_with_canvas().get_origin() - self.rect_global_position
	self.set_rotation(displacement.angle())
	
	var distance = displacement.length()
	_arrow_image.rect_position.x = _max_arrow_dist * min((distance / _arrow_dist_check), 1)


func set_target(value) -> void:
	target = value
	
	if target:
		self.visible = true
		
	else:
		self.visible = false


func _on_area_completed(_area, _time_to_add) -> void:
	target = null
	call_deferred("free")


func _on_player_entered_area(area_ref) -> void:
	self.visible = false


func _on_player_exited_area(area_ref) -> void:
	self.visible = true
