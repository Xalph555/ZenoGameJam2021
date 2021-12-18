# Level Manager Sungleton Script
# ----------------------------

extends Node2D

class_name LevelManager

onready var _level_timer = $LevelTimer


func _ready() -> void:
	# FOR TESTING
	yield(get_tree().create_timer(2), "timeout")
	start_timer()
	GameEvents.emit_signal("start_game")


func _process(delta: float) -> void:
	if get_remaining_time() > 0:
		GameEvents.emit_signal("time_changed", get_remaining_time())


# General Level management
func start_game() -> void:
	pass


func stop_game() -> void:
	pass


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
