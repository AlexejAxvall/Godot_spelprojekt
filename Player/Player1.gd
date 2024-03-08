extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation = get_node("AnimationPlayer")

var health = 10

func _ready():
	animation.play("Idle")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var direction_up_down = Input.get_axis("ui_down","ui_up")
	
	#if direction_up_down == -1:
		#animation.play("down")
	#elif direction_up_down == 1:
		#animation.play("up")
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions
	var direction_left_right = Input.get_axis("ui_left", "ui_right")
	
	if direction_left_right == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction_left_right == 1:
		get_node("AnimatedSprite2D").flip_h = false
	
	if direction_left_right:
		velocity.x = direction_left_right * SPEED
		if velocity.y == 0 and is_on_floor():
			animation.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0 and velocity.x == 0 and is_on_floor() and Input.is_action_just_pressed("Player1_attack") != true:
			animation.play("Idle")
	
	if not is_on_floor():
		animation.play("Jump")
	
	move_and_slide()
	
	if Input.is_action_just_pressed("Player1_attack"):
		animation.play("Attack")
	
		

func take_damage(damage):
	health -= damage
