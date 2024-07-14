extends Area3D

@export var checkpoint_marker: NodePath
@export var is_first_checkpoint: bool = false

func _ready():
	pass

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if Global.last_checkpoint != self:
			Global.last_checkpoint = self
			print("Checkpoint updated")
			if is_first_checkpoint:
				print("This is the first checkpoint!")
			# d autres trucs sont possible comme animer et autre
	else:
		body.queue_free()

func teleport_player_to_checkpoint():
	if Global.player and is_inside_tree():
		if checkpoint_marker:
			var marker = get_node(checkpoint_marker)
			if marker:
				Global.player.global_transform.origin = marker.global_transform.origin
			else:
				print("Marker not found at path:", checkpoint_marker)
		else:
			print("Checkpoint marker path not set")





