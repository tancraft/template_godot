extends VBoxContainer

const WORLD = preload("res://world/world.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_quit_pressed():
	get_tree().quit()


func _on_start_pressed():
	get_tree().change_scene_to_packed(WORLD)
