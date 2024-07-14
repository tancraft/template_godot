extends Node3D


func _ready():
	Global.current_level = self
	print("level ready")

func _process(delta):
	pass
