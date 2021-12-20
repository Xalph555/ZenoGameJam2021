extends Control

export(String, FILE) var main_menu_scene 


func play_transition() -> void:
	self.visible = true
	
	$Panel/ScoreLabel.text = "Score: " + str(PlayerStats.score)
	$AnimationPlayer.play("GameOverTransition")


func set_win_title() -> void:
	$Panel/GameOverTitle.text = "You Win!"
	$Panel/ResultDescription.text = "Your friend's wish has come true"


func _on_PlayAgainButton_button_down() -> void:
	$AudioStreamPlayer.play()
	GameEvents.emit_signal("reload_game")


func _on_MainMenuButton2_button_down() -> void:
	$AudioStreamPlayer.play()
	get_tree().change_scene(main_menu_scene)
