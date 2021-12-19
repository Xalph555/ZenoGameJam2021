extends Control

var target

func _process(delta: float) -> void:
	if target:
		self.visible = true
		self.set_rotation((target.return_control_position() - self.rect_global_position).angle())
	
	else:
		self.visible = false


func _on_area_completed(_area, _time_to_add) -> void:
	target = null
	call_deferred("free")
