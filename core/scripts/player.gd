extends CharacterBody3D

const JUMP_VELOCITY = 6.2

@export var sens: float = 0.5
@export var SPEED: float = 3.0
@export var BONUS_SPEED: float = 7.0
@export var MAX_JUMP_COUNT: int = 2
@export var HP: int = 20
@export var PA: int = 5

@onready var eyes: Node3D = $Character_body/MeshInstance3D/eyes
@onready var anim_player: AnimationPlayer = $Character_body/AnimationPlayer
@onready var camera_controller: Node3D = $Camera_controller
@onready var camera_spring_arm: SpringArm3D = $Camera_controller/SpringArm3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var in_first_view: bool = false
var is_sprinting: bool = false
var transitioning: bool = false
var is_in_attack: bool = false

var current_speed: float = SPEED
var jump_count: int = 0
var transition_progress: float = 0.0
var transition_duration: float = 0.4 # transition duration
var initial_spring_length: float = 5.0
var target_spring_length: float = 0.0

func _ready():
	Global.player = self
	position = Global.last_checkpoint.position
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.last_checkpoint.teleport_player_to_checkpoint()
	anim_player.play("idle")
	print("player ready")

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sens))
		camera_controller.rotate_x(deg_to_rad(-event.relative.y * sens))
		camera_controller.rotation.x = clamp(camera_controller.rotation.x, deg_to_rad(-90), deg_to_rad(45))

func _physics_process(delta):
	get_current_dir()
	handle_input()
	update_dir()
	get_current_dir()
	move_and_slide()
	update_statement(delta)
	if transitioning:
		update_view_transition(delta)

	#update game
func update_dir():
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		update_animation(input_dir)
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if velocity.x == 0 and velocity.z == 0 and not is_in_attack:
			anim_player.play("idle")
	pass
func get_current_dir():
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()



func update_view_transition(delta):
	transition_progress += delta / transition_duration
	if transition_progress >= 1.0:
		transition_progress = 1.0
		transitioning = false
	camera_spring_arm.spring_length = lerp(initial_spring_length, target_spring_length, transition_progress)

func update_animation(input_dir: Vector2) -> void:
	if is_in_attack: 
		return
	if is_sprinting:
		if input_dir.y > 0:
			anim_player.play("run_backward")
		elif input_dir.y < 0:
			anim_player.play("run_forward")
		#elif input_dir.x > 0:
			#anim_player.play("run_right")
		#elif input_dir.x < 0:
			#anim_player.play("run_left")
	else:
		if input_dir.y > 0:
			anim_player.play("backward")
		elif input_dir.y < 0:
			anim_player.play("forward")
		#elif input_dir.x > 0:
			#anim_player.play("step_right")
		#elif input_dir.x < 0:
			#anim_player.play("step_left")

func update_statement(delta):
	fall(delta)
	if is_on_floor():
		jump_count = 0
	sprint()

func take_damage(body):
	if HP >= 0:
		HP -= body.PA
	elif HP == 0:
		die()

func die():
	var CheckpointsManager = $"../Level/CheckPoints"
	CheckpointsManager.respawn_player()

	#input actions
func handle_input():
	if Input.is_action_just_pressed("toggle_view"):
		update_view_mode()

	if Input.is_action_just_pressed("ui_accept") and jump_count < MAX_JUMP_COUNT:
		jump()

	if Input.is_action_just_pressed("attack"):
		attack()

	if Input.is_action_pressed("sprint"):
		is_sprinting = true
	else:
		is_sprinting = false

func update_view_mode():
	in_first_view = !in_first_view
	initial_spring_length = camera_spring_arm.spring_length
	target_spring_length = 0 if in_first_view else 5
	transitioning = true
	transition_progress = 0.0
	eyes.visible = not in_first_view


func sprint():
	if is_sprinting:
		current_speed = SPEED + BONUS_SPEED
	else:
		current_speed = SPEED

func jump() -> void:
	velocity.y = JUMP_VELOCITY
	jump_count += 1

func fall(delta) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

func attack():
	if is_in_attack:
		return
	is_in_attack = true
	anim_player.play("attack")
	await anim_player.animation_finished
	is_in_attack = false

	#signals
func _on_hurtbox_area_entered(area):

	if area.is_in_group("playerHitbox") and Global.player.is_in_attack:
		take_damage(Global.player)
