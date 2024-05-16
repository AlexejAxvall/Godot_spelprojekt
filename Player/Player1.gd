extends CharacterBody2D

const MAP_X = 1152
const MAP_Y = 648

var not_dead = true
var tumbling = false
const TUMBLING_TIME = 2
var stuck = false
const STUCK_FROM_MISSED_TEKK_TIME = 1
var tekk = false
var dodging = false

const WALK_SPEED = 150.0
const RUN_SPEED = 300.0
var SPEED = WALK_SPEED

var jump_count = 1
var jump_velocity = -300.0
var hanging = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


var flip = 0
var attacks = {
	"Grounded_attacks" : {
		"Grounded-neutral-attack" : {"angle" : 90, "force" : 100, "damage" : 10},
		"Grounded-up-attack" : {"angle" : 0, "force" : 100, "damage" : 10},
		"Grounded-down-attack" : {"angle" : 45, "force" : 100, "damage" : 10},
		"Grounded-left-attack" : {"angle" : 45, "force" : 100, "damage" : 10},
		"Grounded-right-attack" : {"angle" : 45, "force" : 100, "damage" : 10},
		"Grounded-up-left-attack" : {"angle" : 22.5, "force" : 100, "damage" : 10},
		"Grounded-down-left-attack" : {"angle" : 67.5, "force" : 100, "damage" : 10},
		"Grounded-up-right-attack" : {"angle" : 22.5, "force" : 100, "damage" : 10},
		"Grounded-down-right-attack" : {"angle" : 22.5, "force" : 100, "damage" : 10},
		"Grounded-running-up-attack" : {"angle" : 0, "force" : 100, "damage" : 10},
		"Grounded-running-down-attack" : {"angle" : 0, "force" : 100, "damage" : 10},
		"Grounded-running-left-attack" : {"angle" : 0, "force" : 100, "damage" : 10},
		"Grounded-running-right-attack" : {"angle" : 0, "force" : 100, "damage" : 10}
	}
	,
	
	"Airborne_attacks" : {
		"Airborne-neutral-attack" : {"angle" : 67.5, "force" : 10, "damage" : 10},
		"Airborne-up-attack" : {"angle" : 22.5, "force" : 100, "damage" : 10},
		"Airborne-down-attack" : {"angle" : 90, "force" : 100, "damage" : 10},
		"Airborne-left-attack" : {"angle" : 45, "force" : 100, "damage" : 10},
		"Airborne-right-attack" : {"angle" : 45, "force" : 100, "damage" : 10},
		"Airborne-up-left-attack" : {"angle" : 0, "force" : 100, "damage" : 10},
		"Airborne-down-left-attack" : {"angle" : 0, "force" : 100, "damage" : 10},
		"Airborne-up-right-attack" : {"angle" : 0, "force" : 100, "damage" : 10},
		"Airborne-down-right-attack" : {"angle" : 0, "force" : 100, "damage" : 10}
	}
}
	
var grounded_or_airborne = 0

var stock = 3
var health = 10

var attacks_keys = attacks.keys()
var grounded_attack_keys = attacks["Grounded_attacks"].keys()
var airborne_attack_keys = attacks["Airborne_attacks"].keys()
var sub_keys = attacks_keys

@onready var animation = get_node("AnimationPlayer")

func _ready():
	animation.play("Idle")

func _physics_process(delta):
	print(animation.current_animation)
	if not stuck:
		if not is_on_floor():
			velocity.y += gravity * delta
		
		if is_on_floor():
			jump_count = 1
			grounded_or_airborne = "Grounded_attacks"
		else:
			grounded_or_airborne = "Airborne_attacks"
				
		if Input.is_action_pressed("Player1_jump") and is_on_floor():
			print(jump_velocity)
			jump_velocity = clamp(jump_velocity - 50, -500, -300)
			print(jump_velocity)
		
		if Input.is_action_just_pressed("Player1_jump") and not is_on_floor() and jump_count > 0:
			velocity.y = -400
			jump_count -= 1
				
		if Input.is_action_just_released("Player1_jump") or jump_velocity == -500:
			if is_on_floor() and animation.current_animation not in attacks["Grounded_attacks"]:
				velocity.y = jump_velocity
				print("Jump reset")
				jump_velocity = -300
		
		var direction_up_down = Input.get_axis("Player1_crouch","Player1_look_up")
		
		if direction_up_down == -1 and animation.current_animation not in attacks["Grounded_attacks"]:
			pass
			#animation.play("down")
		elif direction_up_down == 1 and animation.current_animation not in attacks["Grounded_attacks"]:
			pass
			#animation.play("up")
		
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions
		var direction_left_right = Input.get_axis("Player1_go_left", "Player1_go_right")
		
		if animation.current_animation not in attacks["Grounded_attacks"] and is_on_floor():
			if direction_left_right == -1:
				get_node("AnimatedSprite2D").flip_h = true
				flip = -1
			elif direction_left_right == 1:
				get_node("AnimatedSprite2D").flip_h = false
				flip = 1
		if direction_left_right and animation.current_animation not in attacks["Grounded_attacks"]:
			if Input.is_action_pressed("Player1_run"):
				if is_on_floor():
					velocity.x = move_toward(velocity.x, direction_left_right * RUN_SPEED, 50)
				else:
					velocity.x = move_toward(velocity.x, direction_left_right * RUN_SPEED, 20)
			else:
				if is_on_floor():
					velocity.x = move_toward(velocity.x, direction_left_right * WALK_SPEED, 50)
				else:
					velocity.x = move_toward(velocity.x, direction_left_right * WALK_SPEED, 20)
			if velocity.y == 0 and is_on_floor() and animation.current_animation not in attacks["Grounded_attacks"]:
				animation.play("Run")

		elif animation.current_animation not in attacks:
			if is_on_floor():
				velocity.x = move_toward(velocity.x, 0, 30)
			elif not is_on_floor():
				velocity.x = move_toward(velocity.x, 0, 5)
			if velocity.y == 0 and velocity.x == 0 and is_on_floor() and animation.current_animation not in attacks["Grounded_attacks"]:
				animation.play("Idle")
		
		if not is_on_floor() and animation.current_animation not in attacks["Grounded_attacks"]:
			animation.play("Jump")
		
		#if hanging:
			#velocity.x = 0
			#velocity.y = 0
			#animation.play("hanging")
		
		
		move_and_slide()
		if attack():
			print(attack())
			animation.play(attack())
			var attack_box = get_node("Area2D(attack_box)").get_node("CollisionShape2D-attack")
			grounded_or_airborne = "Grounded_attacks" if is_on_floor() else "Airborne_attacks"
			attack_box.get_attack_info(attacks[grounded_or_airborne][attack()]["angle"]*flip)
			print(attacks[grounded_or_airborne][attack()]["angle"])
			
			
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

func simulate_attack_on():
	var attack_force = 500.0
	var attack_angle = deg_to_rad(180)
	knockback_player(attack_force, attack_angle)

func knockback_player(force: float, angle: float):
	var knockback_direction = Vector2(cos(angle), sin(angle))
	var knockback_magnitude = force
	var knockback = knockback_direction * knockback_magnitude
	velocity.x += knockback.x / 8
	velocity.y += knockback.y

func attack():
	sub_keys = grounded_attack_keys if is_on_floor() else airborne_attack_keys
	if Input.is_action_just_pressed("Player1_neutral-attack"):
		simulate_attack_on()
		return "Grounded-neutral-attack" if is_on_floor() else "Airborne-neutral-attack"
	elif Input.is_action_just_pressed("Player1_up-attack") and Input.is_action_just_pressed("Player1_left-attack"):
		return "Grounded-up-left-attack" if is_on_floor() else "Airborne-up-left-attack"
	elif Input.is_action_just_pressed("Player1_down-attack") and Input.is_action_just_pressed("Player1_left-attack"):
		return "Grounded-down-left-attack" if is_on_floor() else "Airborne-down-left-attack"
	elif Input.is_action_just_pressed("Player1_up-attack") and Input.is_action_just_pressed("Player1_right-attack"):
		return "Grounded-up-right-attack" if is_on_floor() else "Airborne-up-right-attack"
	elif Input.is_action_just_pressed("Player1_down-attack") and Input.is_action_just_pressed("Player1_right-attack"):
		return "Grounded-down-right-attack" if is_on_floor() else "Airborne-down-right-attack"
	elif Input.is_action_just_pressed("Player1_up-attack"):
		return "Grounded-up-attack" if is_on_floor() else "Airborne-up-attack"
	elif Input.is_action_just_pressed("Player1_down-attack"):
		return "Grounded-down-attack" if is_on_floor() else "Airborne-down-attack"
	elif Input.is_action_just_pressed("Player1_left-attack"):
		return "Grounded-left-attack" if is_on_floor() else "Airborne-left-attack"
	elif Input.is_action_just_pressed("Player1_right-attack"):
		return "Grounded-right-attack" if is_on_floor() else "Airborne-right-attack"
	else:
		pass

func _on_timer_timeout():
	pass # Replace with function body.


func _on_area_2d_body_entered(body):
	if body.name == "Player2":
		print("bababababa")
