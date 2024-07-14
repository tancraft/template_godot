extends Node3D

@export var speed: float = 2

func _process(_delta):
	rotate_y(deg_to_rad(speed))
