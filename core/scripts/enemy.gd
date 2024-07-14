extends CharacterBody3D

var in_chase: bool = false
var returning_to_initial: bool = false
var first_launch: bool = true
var initial_position: Vector3
var initial_rotation: Vector3

@export var SPEED = 3.0
@export var HP: int = 10
@export var PA: int = 2

@onready var nav = $NavigationAgent3D
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var is_in_attack: bool = false

func _ready():
	initial_position = global_transform.origin
	nav.target_position = initial_position
	initial_rotation = global_transform.basis.get_euler()

func _physics_process(_delta):
	if not first_launch:
		if in_chase:
			anim_player.play("in_chase")
			agent_chase()
		else:
			if returning_to_initial:
				anim_player.play("in_chase")
				return_to_initial_position()
			else:
				#anim_player.play("idle")
				rotate_to_initial_position()
	else:
		first_launch = false
		
	nav.set_velocity(velocity)

func update_target_location(target_location):
	nav.target_position = target_location

func agent_chase():
	var current_location = global_transform.origin
	var next_location = nav.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	velocity = velocity.move_toward(new_velocity, 0.50)
	look_at(Vector3(Global.player.global_position.x, global_position.y, Global.player.global_position.z), Vector3.UP)

func return_to_initial_position():
	nav.target_position = initial_position
	var current_location = global_transform.origin
	var next_location = nav.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	if current_location.distance_to(initial_position) > 0.1:
		var target_rotation = initial_rotation
		global_transform.basis = Basis().rotated(Vector3.UP, lerp_angle(global_transform.basis.get_euler().y, target_rotation.y, 0.1))

	if current_location.distance_to(initial_position) < 0.1:
		velocity = Vector3.ZERO
	else:
		velocity = velocity.move_toward(new_velocity, 0.2)

func rotate_to_initial_position():
	var current_rotation = global_transform.basis.get_euler()
	var target_rotation = initial_rotation
	global_transform.basis = Basis().rotated(Vector3.UP, lerp_angle(current_rotation.y, target_rotation.y, 0.1))

func lerp_angle(a: float, b: float, t: float) -> float:
	return a + t * (b - a)

func take_damage(body):
	HP -= body.PA
	if HP <= 0:
		die()

func die():
	queue_free()

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		in_chase = true
		nav.target_position = body.global_transform.origin

func _on_area_3d_body_exited(body):
	if body.is_in_group("Player"):
		in_chase = false
		returning_to_initial = true
		nav.target_position = initial_position

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()

func _on_hurtbox_area_entered(area):
	if area.is_in_group("playerHitbox") and Global.player.is_in_attack:
		take_damage(Global.player)

func _on_navigation_agent_3d_navigation_finished():
	anim_player.play("idle")
