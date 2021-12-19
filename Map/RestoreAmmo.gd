# Restore Ammo Script
# -------------------------------

extends Area2D



func _on_body_entered(body: Node) -> void:
	PlayerStats.poster_ammo += PlayerStats.base_poster_ammo - PlayerStats.poster_ammo
	PlayerStats.egg_ammo += PlayerStats.base_egg_ammo - PlayerStats.egg_ammo
	$Particles2D.emitting = true
