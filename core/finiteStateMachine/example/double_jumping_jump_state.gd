class_name DoubleJumpingJumpState
extends State
 
@export var actor: CharacterBody3D
@export var jump_velocity: int = -350
@export var double_jump_velocity_scale: float = 0.9
 
func Enter():
	actor.velocity.y = jump_velocity * double_jump_velocity_scale
 
func Physics_update(_delta):
	if actor.is_on_floor():
		transitioned.emit("IdleJumpState")
