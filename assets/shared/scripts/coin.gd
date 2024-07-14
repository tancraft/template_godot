extends Area3D

const ROT_SPEED = 2

# rotation
func _process(_delta):
	rotate_y(deg_to_rad(ROT_SPEED))

func _on_body_entered(body):
	if body.is_in_group("Player"):
		Global.coins += 1
		queue_free()
