extends Projectile


func remove_flying_poster() -> void:
	$Timer.stop()
	move_dir = Vector2.ZERO
	$AudioStreamPlayer2D.play()
	yield(get_tree().create_timer(0.1), "timeout")
	call_deferred("free")


func _on_HurtBox_area_entered(area: Area2D) -> void:
	remove_flying_poster()
func _on_HurtBox_body_entered(body: Node) -> void:
	remove_flying_poster()


func _on_Timer_timeout() -> void:
	remove_flying_poster()
