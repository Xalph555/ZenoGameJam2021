#--------------------------------------#
# Main menu Script                     #
#--------------------------------------#
extends Control


# Variables:
#---------------------------------------
export(String, FILE) var game_scene 
export(AudioStreamSample) var main_menu_music

export(NodePath) onready var _info_page = get_node(_info_page) as Control
export(NodePath) onready var _controls_page = get_node(_controls_page) as Control


# Functions:
#---------------------------------------
func _ready() -> void:
	BackgroundMusic.change_track(main_menu_music)
	
	_info_page.visible = true
	_controls_page.visible = false


func _on_PlayGameButton_button_down() -> void:
	_info_page.visible = false
	_controls_page.visible = true


func _on_BackButton_button_down() -> void:
	_info_page.visible = true
	_controls_page.visible = false


func _on_StartButton_button_down() -> void:
	BackgroundMusic.fade_out()
	yield(BackgroundMusic, "music_stopped")
	
	get_tree().change_scene(game_scene)
