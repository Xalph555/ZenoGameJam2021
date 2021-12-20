extends Projectile


func egg_break() -> void:
	$Timer.stop()
	move_dir = Vector2.ZERO
	self.self_modulate = Color(1, 1, 1, 0)
	$Particles2D.emitting = true
	yield(get_tree().create_timer(1), "timeout")
	call_deferred("free")


func _on_HurtBox_area_entered(area: Area2D) -> void:
	egg_break()
func _on_HurtBox_body_entered(body: Node) -> void:
	egg_break()


func _on_Timer_timeout() -> void:
	egg_break()
