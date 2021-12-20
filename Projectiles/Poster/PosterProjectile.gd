extends Projectile


func remove_flying_poster() -> void:
	$Timer.stop()
	call_deferred("free")


func _on_HurtBox_area_entered(area: Area2D) -> void:
	remove_flying_poster()
func _on_HurtBox_body_entered(body: Node) -> void:
	remove_flying_poster()


func _on_Timer_timeout() -> void:
	remove_flying_poster()
