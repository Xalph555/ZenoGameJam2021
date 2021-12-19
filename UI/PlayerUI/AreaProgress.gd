# Area Progress Bar
# --------------------------------------

extends HBoxContainer
class_name AreaProgressBar


export(NodePath) onready var _area_name = get_node(_area_name) as Label
export(NodePath) onready var _area_progress = get_node(_area_progress) as TextureProgress


func set_area_name(area_name: String) -> void:
	_area_name.text = area_name


func set_area_progress(area_progress: float) -> void:
	_area_progress.value = area_progress
	
	if _area_progress.value == _area_progress.max_value:
		call_deferred("free")
