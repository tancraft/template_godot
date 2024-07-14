extends Area3D

func _on_body_entered(body):
	if body.is_in_group("Player"):
		Global.player.die()
	else:
		body.queue_free()


