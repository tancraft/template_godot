extends ColorRect

@export var camera_distance: float = 20.0

@onready var map_camera: Camera3D = $SubViewportContainer/SubViewport/Camera3D

func _process(_delta):
	map_camera.size = camera_distance
	map_camera.position = Vector3(Global.player.position.x, camera_distance,Global.player.position.z)
