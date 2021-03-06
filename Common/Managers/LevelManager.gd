#--------------------------------------#
# Level Manager Singleton Script       #
#--------------------------------------#
extends Node2D

class_name LevelManager


# Variables:
#---------------------------------------
export(Array, NodePath) var posterable_area_paths
export(AudioStreamSample) var _game_over_music

export(NodePath) onready var _player_ui = get_node(_player_ui) as PlayerUI

var posterable_areas = []
var _stop_game_triggered := false

onready var _level_timer := $LevelTimer


# Functions:
#---------------------------------------
func _ready() -> void:
	# instantiate posterable_areas array
	for i in posterable_area_paths:
		posterable_areas.append(get_node(i))
	
	# connect posterable_areas signals
	for i in posterable_areas:
		i.connect("area_completed", self, "_on_area_completed")
	
	GameEvents.connect("start_game", self, "_on_start_game")
	GameEvents.connect("reload_game", self, "_on_reload_game")


func _process(delta: float) -> void:
	if get_remaining_time() >= 0:
		GameEvents.emit_signal("time_changed", get_remaining_time())
	
	if posterable_areas.size() <= 0 and not _stop_game_triggered:
		_stop_game_triggered = true
		_level_timer.stop()
		stop_game(true)


# General Level management
func start_game() -> void:
	PlayerStats.reset_stats()
	_player_ui.visible = true
	_player_ui.create_area_bars(posterable_areas)
	
	start_timer()


func stop_game(has_won : bool = false) -> void:
	_level_timer.stop()
	
	GameEvents.emit_signal("game_over", has_won)
	BackgroundMusic.change_track(_game_over_music)
	
	_player_ui.visible = false


# Level Timer Related Functions
func start_timer(time_sec : float = -1) -> void:
	_level_timer.start(time_sec)


func stop_timer() -> void:
	_level_timer.stop()


func pause_timer(is_paused : bool) -> void:
	_level_timer.set_paused(is_paused)


func get_remaining_time() -> float:
	return _level_timer.time_left


func add_time(time_to_add : float) -> void:
	pause_timer(true)
	
	var _new_time = _level_timer.time_left + time_to_add
	
	stop_timer()
	pause_timer(false)
	start_timer(_new_time)


func _on_LevelTimer_timeout() -> void:
	stop_game()


# area management
func _on_area_completed(area, time_to_add) -> void:
	area.disconnect("area_completed", self, "_on_area_completed")
	posterable_areas.erase(area)
	
	add_time(time_to_add)


# general game management
func _on_start_game() -> void:
	start_game()


func _on_reload_game() -> void:
	PlayerStats.reset_stats()
	get_tree().reload_current_scene()
