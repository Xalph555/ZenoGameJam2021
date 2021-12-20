# Level Manager Sungleton Script
# ----------------------------

extends Node2D

class_name LevelManager


export(Array, NodePath) var posterable_area_paths

# NOTE TO SELF: Let us not do this coupling - please fix after jam
export(NodePath) onready var _player_ui = get_node(_player_ui) as PlayerUI
export(NodePath) onready var _game_over_ui = get_node(_game_over_ui)

var posterable_areas = []

onready var _level_timer = $LevelTimer


func _ready() -> void:
	# instantiate posterable_areas array
	for i in posterable_area_paths:
		posterable_areas.append(get_node(i))
	
	# connect posterable_areas signals
	for i in posterable_areas:
		i.connect("area_completed", self, "_on_area_completed")
	
	GameEvents.connect("start_game", self, "_on_start_game")
	GameEvents.connect("reload_game", self, "_on_reload_game")
	
	# FOR TESTING
	#yield(get_tree().create_timer(2), "timeout")
	#GameEvents.emit_signal("start_game")
	#start_game()


func _process(delta: float) -> void:
	if get_remaining_time() >= 0:
		GameEvents.emit_signal("time_changed", get_remaining_time())
	
	if posterable_areas.size() <= 0:
		stop_game()


# General Level management
func start_game() -> void:
	PlayerStats.reset_stats()
	_player_ui.visible = true
	_player_ui.create_area_bars(posterable_areas)
	
	start_timer()


func stop_game() -> void:
	GameEvents.emit_signal("game_over")
	
	_player_ui.visible = false
	_game_over_ui.play_transition()


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
	get_tree().reload_current_scene()
