# Main menu Script
# ------------------------------

extends Control


export(String, FILE) var game_scene 


func _on_PlayGameButton_button_down() -> void:
	get_tree().change_scene(game_scene)
