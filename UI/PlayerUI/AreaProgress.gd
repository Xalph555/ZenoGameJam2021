#--------------------------------------#
# Area Progress Bar Script             #
#--------------------------------------#
extends HBoxContainer

class_name AreaProgressBar


# Variables:
#---------------------------------------
export(NodePath) onready var _area_name = get_node(_area_name) as Label
export(NodePath) onready var _area_progress = get_node(_area_progress) as TextureProgress
export(NodePath) onready var _area_name_highlight = get_node(_area_name_highlight) as ColorRect


# Functions:
#---------------------------------------
func set_area_name(area_name: String) -> void:
	_area_name.text = area_name + " "


func set_area_progress(area_progress: float) -> void:
	_area_progress.value = area_progress
	
	if _area_progress.value == _area_progress.max_value:
		call_deferred("free")


func _on_player_entered_area(area_ref) -> void:
	_area_name_highlight.visible = true


func _on_player_exited_area(area_ref) -> void:
	_area_name_highlight.visible = false
