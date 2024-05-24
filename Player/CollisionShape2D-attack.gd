extends CollisionShape2D

var is_attack_active = false
var last_frame_processed = -1
var frame_count

var the_position: Vector2
var angle: float
var direction: Vector2
var initial_position: Vector2

var is_attack_animation = false

func get_attack_info(_position: Vector2, _angle: float):
	the_position = _position
	angle = _angle
	is_attack_animation = true
	is_attack_active = false

	# Calculate the initial direction based on the angle
	var angle_radians: float = deg_to_rad(angle - 90)
	direction = Vector2(cos(angle_radians), sin(angle_radians))
	initial_position = _position

func show_hitbox():
	disabled = false

func hide_hitbox():
	disabled = true

func _ready():
	hide_hitbox()
	var animation_player = get_parent().get_parent().get_node("AnimationPlayer")
	if not animation_player:
		pass

func _process(delta):
	var animation_player = get_parent().get_parent().get_node("AnimationPlayer")
	if animation_player:
		var current_anim_name = animation_player.get_current_animation()
		if is_attack_animation:
			var anim_position = animation_player.get_current_animation_position()
			var anim_length = animation_player.get_current_animation_length()
			var animation = animation_player.get_animation(current_anim_name)
			var frame_step = animation.step if animation.step > 0 else delta
			frame_count = int(anim_length / frame_step)
			var current_frame = int(anim_position / anim_length * frame_count) + 1
			if current_frame != last_frame_processed:
				handle_frame_logic(current_frame)
				last_frame_processed = current_frame

func handle_frame_logic(frame):
	if frame == 1 and not is_attack_active:
		is_attack_active = true
		show_hitbox()
		change_hitbox(frame)
		rotate_self(angle)
	elif frame == frame_count and is_attack_active:
		reset_hitbox()
	elif is_attack_active:
		change_hitbox(frame)

func change_hitbox(frame):
	if shape is CapsuleShape2D:
		var initial_radius = 5
		var initial_height = 2 * initial_radius
		var new_height = initial_height + (frame - 1) * 10

		var height_change = new_height - initial_height  # Calculate total height change from initial
		var offset_change = direction * height_change / 2

		# Use initial position and offset only
		self.position = initial_position + offset_change
		print("Offset_change = " + str(offset_change) + " for frame: " + str(frame))
		print("Self.position = " + str(self.position) + " for frame: " + str(frame))

		shape.height = new_height
	else:
		pass

func rotate_self(_angle):
	rotation_degrees = _angle

func reset_hitbox():
	self.position = Vector2(0, -10)
	shape.height = 10
	shape.radius = 5
	is_attack_active = false
	hide_hitbox()
	rotate_self(angle)
	is_attack_animation = false
