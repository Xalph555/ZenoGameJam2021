# Main menu Script
# ------------------------------

extends Control


export(String, FILE) var game_scene 
export(AudioStreamSample) var main_menu_music


func _ready() -> void:
	BackgroundMusic.change_track(main_menu_music)


func _on_PlayGameButton_button_down() -> void:
	$AudioStreamPlayer.play()
	BackgroundMusic.fade_out()
	yield(BackgroundMusic, "music_stopped")
	
	get_tree().change_scene(game_scene)
