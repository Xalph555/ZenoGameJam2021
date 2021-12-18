# Posterable Object Script
# -------------------------------

extends StaticBody2D
class_name PosterableObject

export var max_health := 50
export var points := 0

onready var health = max_health setget set_health

onready var _health_bar := $HealthBar
onready var sprite := $Sprite


func _ready() -> void:
	_health_bar.max_value = max_health


func set_health(value : int):
	health = clamp(value, 0, max_health)
	_health_bar.value = health
	
	hurt_flash()
	
	if health <= 0:
		PlayerStats.score += points
		
		self.visible = false


func hurt_flash() -> void:
	sprite.material.set_shader_param("active", true)
	yield(get_tree().create_timer(0.05), "timeout")
	sprite.material.set_shader_param("active", false)


func _on_HurtBox_area_entered(area: Area2D) -> void:
	var _poster := area as Hitbox
	
	if _poster:
		_health_bar.visible = true
		self.health -= _poster.damage
