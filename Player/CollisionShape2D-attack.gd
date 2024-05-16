extends CollisionShape2D

var is_attack_active = false
var last_frame_processed = -1
var angle

func get_attack_info(_angle):
	angle = _angle

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
		if current_anim_name == "Grounded-neutral-attack":
			var anim_position = animation_player.get_current_animation_position()
			var anim_length = animation_player.get_current_animation_length()
			var expected_frames = 10
			var current_frame = int(anim_position / anim_length * expected_frames) + 1
			if current_frame != last_frame_processed:
				handle_frame_logic(current_frame)
				last_frame_processed = current_frame

func handle_frame_logic(frame):
	if frame == 1 and not is_attack_active:
		is_attack_active = true
		show_hitbox()
		change_hitbox(frame)
		rotate_parent(angle)
	elif frame == 10 and is_attack_active:
		self.position = Vector2(0, 0)
		shape.height = 10
		shape.radius = 5
		is_attack_active = false
		hide_hitbox()
		rotate_parent(angle)
	elif is_attack_active:
		change_hitbox(frame)

func change_hitbox(frame):
	if shape is CapsuleShape2D:
		var initial_height = 50
		var initial_radius = 5
		var new_height = initial_height + (frame - 1) * 5
		#var new_radius = initial_radius + (frame - 1) * 0.5

		var height_change = new_height - shape.height
		var new_position_offset = Vector2(0, height_change / 2)

		self.position -= new_position_offset
		shape.height = new_height
		#shape.radius = new_radius
	else:
		pass

func rotate_parent(_angle):
	var node2d_parent = get_parent()
	if node2d_parent and node2d_parent is Node2D:
		node2d_parent.rotation_degrees = _angle
