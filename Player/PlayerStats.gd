#--------------------------------------#
# Player Stats Singleton Script        #
#--------------------------------------#
extends Node


# Signals:
#---------------------------------------
signal score_changed(score)
signal poster_ammo_changed(ammo)
signal egg_ammo_changed(ammo)

signal out_of_posters

signal power_up_ended


# Variables:
#---------------------------------------
export var base_poster_ammo := 50
export var base_egg_ammo := 10

onready var score := 0 setget set_score

onready var poster_ammo := base_poster_ammo setget set_poster_ammo
onready var egg_ammo := base_egg_ammo setget set_egg_ammo

onready var _power_up_timer := $PowerUpTimer


# Functions:
#---------------------------------------
func reset_stats() -> void:
	score = 0
	poster_ammo = base_poster_ammo
	egg_ammo = base_egg_ammo


func set_score(points : int):
	score = points
	emit_signal("score_changed", score)


func set_poster_ammo(amount : int):
	poster_ammo = amount
	emit_signal("poster_ammo_changed", poster_ammo)
	
	if poster_ammo <= 0:
		emit_signal("out_of_posters")


func set_egg_ammo(amount : int):
	egg_ammo = amount
	emit_signal("egg_ammo_changed", egg_ammo)


func start_power_up_timer(duration : float) -> void:
	_power_up_timer.start(duration)


func _on_PowerUpTimer_timeout() -> void:
	emit_signal("power_up_ended")
