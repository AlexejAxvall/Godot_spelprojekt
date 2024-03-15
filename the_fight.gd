extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(player.position)
	
@onready var player = get_node("Player1");

func start_respawn_cooldown(which_player):
	$Timer.start(3)
	if which_player == 1:
		player = get_node("Player1")
	if which_player == 2:
		player = get_node("Player2")

func _on_timer_timeout():
	respawn_player(player)

func respawn_player(player):
	player.process_mode = 4
