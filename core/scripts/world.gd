extends Node3D

func _ready():
	print("world ready")

func _physics_process(_delta):
	get_tree().call_group("enemies", "update_target_location", Global.player.global_transform.origin)
