extends Node3D

@onready var start_scene: PackedScene = preload("res://scenes/world/levels/start_scene.tscn")
@onready var level_scene: PackedScene = preload("res://core/scenes/level.tscn")
@onready var player_scene: PackedScene = preload("res://core/entities/player/player.tscn")

func _ready():
	print("game manager ready")

func _physics_process(_delta):
	get_tree().call_group("enemies", "update_target_location", Global.player.global_transform.origin)


func inst(instance):
	pass

func launch_game():
	pass

func launch_level():
	pass

func start():
	pass

func exit():
	pass
