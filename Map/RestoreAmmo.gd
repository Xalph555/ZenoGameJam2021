#--------------------------------------#
# Restore Ammo Area Script             #
#--------------------------------------#
extends Area2D


# Variables:
#---------------------------------------
onready var _particles := $Particles2D
onready var _sfx := $AudioStreamPlayer


# Functions:
#---------------------------------------
func _ready() -> void:
	GameEvents.connect("start_game", self, "_on_start_game")


func _on_body_entered(body: Node) -> void:
	var player = body as Player
		
	if not player:
		if body is Car:
			player = body.player_reference as Player
			
			if not player:
				return
		
		else:
			return
		
	PlayerStats.poster_ammo += PlayerStats.base_poster_ammo - PlayerStats.poster_ammo
	PlayerStats.egg_ammo += PlayerStats.base_egg_ammo - PlayerStats.egg_ammo
	_particles.emitting = true
	
	_sfx.play()


func _on_start_game() -> void:
	self.visible = true
