# Posterable Area Script
# -----------------------------

extends Area2D

class_name PosterableArea

export var points := 0

var posterable_objects = []

var total_health := 0
var current_progress := 0


func _process(delta: float) -> void:
	if posterable_objects.size() == 0:
		posterable_objects = get_overlapping_bodies()
		
		if total_health == 0:
			set_total_health()


func set_total_health() -> void:
	for obj in posterable_objects:
		total_health += obj.max_health 
