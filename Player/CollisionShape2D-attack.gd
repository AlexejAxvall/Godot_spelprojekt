extends CollisionShape2D

var is_attack_active = false
var last_frame_processed = -1

func show_hitbox():
	#print("Showing hitbox")
	disabled = false

func hide_hitbox():
	#print("Hiding hitbox")
	disabled = true

func _ready():
	hide_hitbox()
	var animation_player = get_parent().get_parent().get_node("AnimationPlayer")
	if not animation_player:
		#print("Error: AnimationPlayer not found.")
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
				#print("Anim Name:", current_anim_name, "Position:", anim_position, "Length:", anim_length, "Expected Frames:", expected_frames, "Current Frame:", current_frame)
				handle_frame_logic(current_frame)
				last_frame_processed = current_frame

func handle_frame_logic(frame):
	#print("Checking frame:", frame, "Active:", is_attack_active)
	if frame == 1 and not is_attack_active:
		is_attack_active = true
		show_hitbox()
		stretch_hitbox(frame)
		#print("Hitbox activated at frame:", frame)
	elif frame == 10 and is_attack_active:
		shape.height = 10
		shape.radius = 10
		is_attack_active = false
		hide_hitbox()
		#print("Hitbox deactivated at frame:", frame)
	elif is_attack_active:
		stretch_hitbox(frame)

func stretch_hitbox(frame):
	if shape is CapsuleShape2D:
		var new_height = 50 + (frame - 1) * 5
		var new_radius = 5 + (frame - 1) * 0.5
		shape.height = new_height
		shape.radius = new_radius
		#print("Stretching hitbox: height =", new_height, "radius =", new_radius)
	else:
		#print("Hitbox shape is not a CapsuleShape2D.")
		pass
