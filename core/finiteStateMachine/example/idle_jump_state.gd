class_name IdleJumpState
extends State
 
@export var actor: CharacterBody3D
 
func Physics_update(_delta):
	if Input.is_action_just_pressed("jump"):
		if actor.is_on_floor():
			print("jump")
			transitioned.emit("JumpingJumpState")
		else:
			print("double")
			transitioned.emit("DoubleJumpingJumpState")
