#--------------------------------------#
# Sound Button Script                  #
#--------------------------------------#
extends Button


# Variables:
#---------------------------------------
onready var _sound_player := $AudioStreamPlayer


# Functions:
#---------------------------------------


func _on_SoundButton_button_down() -> void:
	_sound_player.play()
