class_name JumpingJumpState
extends State
 
@export var actor: CharacterBody3D
@export var jump_velocity: float = 10.0
 
func Enter():
	## Apply velocity to jump only once when entering the state
	actor.velocity.y = jump_velocity
	print(actor.velocity)
		
func Physics_update(_delta):
	var is_jump_just_pressed: bool = Input.is_action_just_pressed("jump")
 
	if is_jump_just_pressed and actor.velocity.y < jump_velocity:
		transitioned.emit("DoubleJumpingJumpState")
		
	if actor.is_on_floor():
		transitioned.emit("IdleJumpState")
