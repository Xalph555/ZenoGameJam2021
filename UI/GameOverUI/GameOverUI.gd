#--------------------------------------#
# Game Over UI Script                  #
#--------------------------------------#
extends Control


# Variables:
#---------------------------------------
export(String, FILE) var main_menu_scene 

export(NodePath) onready var _game_over_label = get_node(_game_over_label) as Label
export(NodePath) onready var _score_label = get_node(_score_label) as Label
export(NodePath) onready var _result_label = get_node(_result_label) as Label

onready var _anim_player := $AnimationPlayer
onready var _sfx := $AudioStreamPlayer


# Functions:
#---------------------------------------
func _ready() -> void:
	GameEvents.connect("game_over", self, "_on_game_over")


func play_transition() -> void:
	self.visible = true
	
	_score_label.text = "Score: " + str(PlayerStats.score)
	_anim_player.play("GameOverTransition")


func set_win_title() -> void:
	_game_over_label.text = "You Win!"
	_result_label.text = "Your friend's wish has come true"


func _on_PlayAgainButton_button_down() -> void:
	_sfx.play()
	GameEvents.emit_signal("reload_game")


func _on_MainMenuButton2_button_down() -> void:
	_sfx.play()
	get_tree().change_scene(main_menu_scene)


func _on_game_over(has_won : bool) -> void:
	if has_won:
		set_win_title()
	
	play_transition()
