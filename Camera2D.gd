extends Camera2D

var zoom_min = Vector2(1.2, 1.2)
var zoom_max = Vector2(1.8, 1.8)
var buffer = 0
var horizontal_upper_limit = 1152
var horizontal_lower_limit = 0
var vertical_upper_limit = 0
var vertical_lower_limit = 775
var distance = 0
var distance2 = 0
var new_zoom = 0
var zoom_finished = true

func _process(delta):
	var player_positions = []
	for player in get_tree().get_nodes_in_group("players"):
		player_positions.append(player.global_position)
		
	if player_positions.size() == 0:
		return
	
	var centroid = Vector2.ZERO
	for pos in player_positions:
		centroid += pos
	centroid /= player_positions.size()

	#if centroid.x > horizontal_upper_limit:
		#centroid.x = horizontal_upper_limit
	#elif centroid.x < horizontal_lower_limit:
		#centroid.x = horizontal_lower_limit

	#if centroid.y > vertical_upper_limit:
		#centroid.y = vertical_upper_limit
	#elif centroid.y < vertical_lower_limit:
		#centroid.y = vertical_lower_limit
	
	#print("Centroid x = " + str(centroid.x))
	#print("Centroid y = " + str(centroid.y))
	#print(get_viewport_rect().size.x)
		
	position = centroid
	
	for pos in player_positions:
		distance = centroid.distance_to(pos)
	#print("abs(d1 - d2) = " + str(abs(distance - distance2)))
		#print("hallo")
	distance2 = distance
	new_zoom = 200 / distance
	buffer = 0.1 * new_zoom
	#if zoom_finished:
	var parent = get_parent()
	parent.start_zoom_timer()
	#zoom_finished = false
	update_zoom()

func update_zoom():
	#print("Hey")
	zoom = Vector2(new_zoom, new_zoom).clamp(zoom_min, zoom_max)
	zoom_finished = true
