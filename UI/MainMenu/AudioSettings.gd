#--------------------------------------#
# Audio Settings script                #
#--------------------------------------#
extends Control


# Variables:
#---------------------------------------
export(NodePath) onready var _music_volume = get_node(_music_volume) as Slider
export(NodePath) onready var _game_sfx_volume = get_node(_game_sfx_volume) as Slider
export(NodePath) onready var _ui_sfx_volume = get_node(_ui_sfx_volume) as Slider

export(NodePath) onready var _sfx_player = get_node(_sfx_player) as AudioStreamPlayer
export(AudioStreamSample) var _game_sfx_test
export(AudioStreamSample) var _ui_sfx_test

# Audio Sliders
export(String) var music_bus_name
export(String) var game_sfx_bus_name
export(String) var ui_sfx_bus_name

# Audio Busses
onready var _music_bus = AudioServer.get_bus_index(music_bus_name)
onready var _game_sfx_bus = AudioServer.get_bus_index(game_sfx_bus_name)
onready var _ui_sfx_bus = AudioServer.get_bus_index(ui_sfx_bus_name)


# Functions:
#---------------------------------------
func _ready() -> void:
	# Adjust Volume Slider default values
	_music_volume.value = db2linear(AudioServer.get_bus_volume_db(_music_bus))
	_game_sfx_volume.value = db2linear(AudioServer.get_bus_volume_db(_game_sfx_bus))
	_ui_sfx_volume.value = db2linear(AudioServer.get_bus_volume_db(_ui_sfx_bus))


# Audio Settings
func _on_MusicSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_music_bus, linear2db(value))


func _on_GameSFXSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_game_sfx_bus, linear2db(value))


func _on_UISFXSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_ui_sfx_bus, linear2db(value))


# Test sound changes
func _on_GameSFXSlider_gui_input(event: InputEvent) -> void:
	if event.is_action_released("ui_shoot_primary"):
		_sfx_player.stream = _game_sfx_test
		_sfx_player.bus = game_sfx_bus_name
		_sfx_player.play()


func _on_UISFXSlider_gui_input(event: InputEvent) -> void:
	if event.is_action_released("ui_shoot_primary"):
		_sfx_player.stream = _ui_sfx_test
		_sfx_player.bus = ui_sfx_bus_name
		_sfx_player.play()


func _on_MusicSlider_mouse_exited() -> void:
	_music_volume.release_focus()

func _on_GameSFXSlider_mouse_exited() -> void:
	_game_sfx_volume.release_focus()

func _on_UISFXSlider_mouse_exited() -> void:
	_ui_sfx_volume.release_focus()
