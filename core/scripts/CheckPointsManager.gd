extends Node

var checkpoints: Array

func _ready():
	checkpoints = self.get_children()
	for checkpoint in checkpoints:
		if checkpoint.is_first_checkpoint:
			Global.last_checkpoint = checkpoint
			print("first position checkpoint updated")
	pass

func respawn_player():
	if Global.last_checkpoint:
		Global.last_checkpoint.teleport_player_to_checkpoint()
	else:
		print("dont have a checkpoint setted")


