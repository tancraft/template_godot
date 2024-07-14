extends Path3D

@export var is_playing: bool = true
@export var loop: bool = true
@export var speed: float = 2.0
@export var speed_scale: float = 1.0

@onready var path: PathFollow3D = $PathFollow3D
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready():
	set_process(is_playing)
	if is_playing:
		if not loop:
			anim_player.play("move")
			anim_player.speed_scale = speed_scale
	else:
		anim_player.stop()

func _process(delta):
	if is_playing:
		path.progress += speed * delta
	else:
		anim_player.stop()

