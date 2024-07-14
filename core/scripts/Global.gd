extends Node

@onready var player_scene: PackedScene = preload("res://core/entities/player/player.tscn")
@onready var start_scene: PackedScene = preload("res://world/levels/start_scene.tscn")
@onready var level_scene: PackedScene = preload("res://core/scenes/level.tscn")

var player: CharacterBody3D
var current_level: Node3D
var last_checkpoint: Area3D
var UI: CanvasLayer


var coins: int

func _ready():
	print("Global ready")
