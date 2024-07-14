extends Marker3D

@export var is_first_of_level = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if is_first_of_level:
		Global.current_spawner = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
