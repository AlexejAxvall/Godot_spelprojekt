extends CharacterBody2D

const MAP_X = 1152
const MAP_Y = 648

var not_dead = true
var tumbling = false
const TUMBLING_TIME = 2
var stuck = false
const STUCK_FROM_MISSED_TEKK_TIME = 1
var tekk = false

const WALK_SPEED = 150.0
const RUN_SPEED = 300.0
var SPEED = WALK_SPEED

var jump_count = 2
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var attacks = [
	["Grounded-neutral-attack", "Grounded-up-attack", "Grounded-down-attack", "Grounded-left-attack", "Grounded-right-attack", "Grounded-up-left-attack", "Grounded-down-left-attack", "Grounded-up-right-attack", "Grounded-down-right-attack"],
	["Airborne-neutral-attack", "Airborne-up-attack", "Airborne-down-attack", "Airborne-left-attack", "Airborne-right-attack", "Airborne-up-left-attack", "Airborne-down-left-attack", "Airborne-up-right-attack", "Airborne-down-right-attack"]
	]
var attacks_first_index = 0

var stock = 3
var health = 10

@onready var animation = get_node("AnimationPlayer")

func _ready():
	animation.play("Idle")

func _physics_process(delta):
	
	
	if not stuck:
		if not is_on_floor():
			velocity.y += gravity * delta
		
		if is_on_floor():
			jump_count = 2
			attacks_first_index = 0
		else:
			attacks_first_index = 1
		
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and jump_count > 0 and animation.current_animation != "Attack":
			velocity.y = JUMP_VELOCITY
			jump_count -= 1
		
		var direction_up_down = Input.get_axis("ui_down","ui_up")
		
		if direction_up_down == -1:
			animation.play("down")
		elif direction_up_down == 1:
			animation.play("up")
		
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions
		var direction_left_right = Input.get_axis("ui_left", "ui_right")
		
		if animation.current_animation != "Attack" and is_on_floor():
			if direction_left_right == -1:
				get_node("AnimatedSprite2D").flip_h = true
			elif direction_left_right == 1:
				get_node("AnimatedSprite2D").flip_h = false
		
		if direction_left_right and animation.current_animation != "Attack":
			velocity.x = direction_left_right * SPEED
			if velocity.y == 0 and is_on_floor():
				animation.play("Run")
		elif animation.current_animation != "Attack":
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if velocity.y == 0 and velocity.x == 0 and is_on_floor() and animation.current_animation != "Attack":
				animation.play("Idle")
		
		if not is_on_floor():
			animation.play("Jump")
		
		move_and_slide()
		if attack():
			print(attack())
			animation.play(attack())
			
		if tumbling and is_on_floor() and not tekk:
			stuck = true
			#animation.play("Lying_down")
			$Timer_stuck.start(STUCK_FROM_MISSED_TEKK_TIME)

	if self.position.x < 0 or self.position.x > MAP_X or self.position.y > MAP_Y or self.position.y < 0:
		print("Out of bounds")
		var parent = get_parent()
		if parent and parent.has_method("start_respawn_cooldown"):
			parent.start_respawn_cooldown(1)
			self.process_mode = Node.PROCESS_MODE_DISABLED
			self.hide()
			stock -= 1
			not_dead = false
			velocity.x = 0
			velocity.y = 0
	
func take_damage(damage):
	if not_dead:
		health -= damage
		if health <= 0:
			var parent = get_parent()
			if parent and parent.has_method("start_respawn_cooldown"):
				parent.start_respawn_cooldown(1)
				self.process_mode = Node.PROCESS_MODE_DISABLED
				self.hide()
				stock -= 1
				not_dead = false



func _on_timer_tumble_timeout():
	tumbling = false

func _on_timer_stuck_timeout():
	stuck = false

func attack():
	if Input.is_action_just_pressed("Player1_neutral-attack"):
		print("ABC")
		return attacks[attacks_first_index][0]
	elif Input.is_action_just_pressed("Player1_up-attack") and Input.is_action_just_pressed("Player1_left-attack"):
		return attacks[attacks_first_index][5]
	elif Input.is_action_just_pressed("Player1_down-attack") and Input.is_action_just_pressed("Player1_left-attack"):
		return attacks[attacks_first_index][6]
	elif Input.is_action_just_pressed("Player1_up-attack") and Input.is_action_just_pressed("Player1_right-attack"):
		return attacks[attacks_first_index][7]
	elif Input.is_action_just_pressed("Player1_down-attack") and Input.is_action_just_pressed("Player1_right-attack"):
		return attacks[attacks_first_index][8]
	elif Input.is_action_just_pressed("Player1_up-attack"):
		return attacks[attacks_first_index][1]
	elif Input.is_action_just_pressed("Player1_down-attack"):
		return attacks[attacks_first_index][2]
	elif Input.is_action_just_pressed("Player1_left-attack"):
		return attacks[attacks_first_index][3]
	elif Input.is_action_just_pressed("Player1_right-attack"):
		return attacks[attacks_first_index][4]
	else:
		pass
