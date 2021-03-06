#--------------------------------------#
# Player UI script                     #
#--------------------------------------#
extends Control

class_name PlayerUI


# Variables:
#---------------------------------------
export(NodePath) onready var _progress_container = get_node(_progress_container) as VBoxContainer
export(PackedScene) var _area_progress_scene = _area_progress_scene as AreaProgressBar

export(NodePath) onready var _time_text = get_node(_time_text) as Label
export(NodePath) onready var _score_text = get_node(_score_text) as Label
export(NodePath) onready var _current_area_text = get_node(_current_area_text) as Label

export(NodePath) onready var _egg_text = get_node(_egg_text) as Label
export(NodePath) onready var _poster_text = get_node(_poster_text) as Label

export(NodePath) onready var _indicator_container = get_node(_indicator_container) as CenterContainer
export(PackedScene) var _indicator_arrow_scene

export(Texture) var cursor

onready var anim_player := $AnimationPlayer
onready var _sfx_player := $AudioStreamPlayer


# Functions:
#---------------------------------------
func _ready() -> void:
	# connecting signals
	GameEvents.connect("start_game", self, "reset_ui")
	GameEvents.connect("time_changed", self, "_on_time_changed")
	
	PlayerStats.connect("score_changed", self, "_on_score_changed")
	PlayerStats.connect("poster_ammo_changed", self, "_on_poster_ammo_changed")
	PlayerStats.connect("egg_ammo_changed", self, "_on_egg_ammo_changed")


func reset_ui() -> void:
	set_time_text(1)
	set_score_text(0)
	set_egg_text(PlayerStats.egg_ammo)
	set_poster_text(PlayerStats.poster_ammo)


func create_area_bars(all_areas : Array) -> void:
	for i in all_areas:
		i.connect("area_completed", self, "_on_area_completed")
		i.connect("player_entered_area", self, "_on_player_entered_area")
		i.connect("player_exited_area", self, "_on_player_exited_area")
		
		# area bar 
		var temp_progress_bar = _area_progress_scene.instance() as AreaProgressBar
		_progress_container.add_child(temp_progress_bar)
		
		temp_progress_bar.set_area_name(i.area_name)
		
		i.connect("area_progress_changed", temp_progress_bar, "set_area_progress")
		i.connect("player_entered_area", temp_progress_bar, "_on_player_entered_area")
		i.connect("player_exited_area", temp_progress_bar, "_on_player_exited_area")
		
		# indicator arrow
		var temp_indicator_arrow = _indicator_arrow_scene.instance()
		_indicator_container.add_child(temp_indicator_arrow)

		temp_indicator_arrow.target = i

		i.connect("area_completed", temp_indicator_arrow, "_on_area_completed")
		i.connect("player_entered_area", temp_indicator_arrow, "_on_player_entered_area")
		i.connect("player_exited_area", temp_indicator_arrow, "_on_player_exited_area")


func set_time_text(time: float) -> void:
	_time_text.text = "Time : " + format_seconds(time)


func set_score_text(points: int) -> void:
	_score_text.text = "Score: " + str(points)


func set_egg_text(amount: int) -> void:
	_egg_text.text = str(amount)


func set_poster_text(amount: int) -> void:
	_poster_text.text = str(amount)


func format_seconds(time: float) -> String:
	var minutes := time / 60
	var seconds := fmod(time, 60)
	var milliseconds := fmod(time, 1) * 100
	
	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]


# signal call backs
func _on_PlayerUI_visibility_changed() -> void:
	if self.visible:
		Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, cursor.get_size() / 2)
		
	else:
		Input.set_custom_mouse_cursor(null)


func _on_time_changed(time : float):
	set_time_text(time)


func _on_score_changed(score : int):
	set_score_text(score)


func _on_poster_ammo_changed(ammo : int):
	set_poster_text(ammo)


func _on_egg_ammo_changed(ammo : int):
	set_egg_text(ammo)


func _on_player_entered_area(area_ref) -> void:
	_current_area_text.text = "Current Area: " + area_ref.area_name


func _on_player_exited_area(area_ref) -> void:
	_current_area_text.text = "Current Area: -"
	

func _on_area_completed(_area, _time) -> void:
	anim_player.play("AreaComplete")
	_sfx_player.play()

