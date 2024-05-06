extends CollisionShape2D

var is_dodge_active = true
var last_frame_processed = -1

func show_hitbox():
	print("Showing hitbox")
	disabled = false

func hide_hitbox():
	print("Hiding hitbox")
	disabled = true

func _ready():
	var animation_player = get_parent().get_parent().get_node("AnimationPlayer")
	if not animation_player:
		print("Error: AnimationPlayer not found.")
		pass

func _process(delta):
	var animation_player = get_parent().get_parent().get_node("AnimationPlayer")
	if animation_player:
		var current_anim_name = animation_player.get_current_animation()
		if current_anim_name == "Dodge":
			var anim_position = animation_player.get_current_animation_position()
			var anim_length = animation_player.get_current_animation_length()
			var expected_frames = 3
			var current_frame = int(anim_position / anim_length * expected_frames) + 1
			if current_frame != last_frame_processed:
				print("Anim Name:", current_anim_name, "Position:", anim_position, "Length:", anim_length, "Expected Frames:", expected_frames, "Current Frame:", current_frame)
				handle_frame_logic(current_frame)
				last_frame_processed = current_frame

func handle_frame_logic(frame):
	print("Checking frame:", frame, "Active:", is_dodge_active)
	if frame == 1 and not is_dodge_active:
		is_dodge_active = true
		hide_hitbox()
		print("Hitbox activated at frame:", frame)
	elif frame == 10 and is_dodge_active:
		is_dodge_active = false
		show_hitbox()
		print("Hitbox deactivated at frame:", frame)
