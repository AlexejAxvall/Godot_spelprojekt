extends Node2D

@onready var player = get_node("Player1");

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_respawn_cooldown(which_player):
	$Timer.start(3)
	if which_player == 1:
		player = get_node("Player1")
	if which_player == 2:
		player = get_node("Player2")
	player.health = 10;

func _on_timer_timeout():
	respawn_player()

func respawn_player():
	print("Out of bounds")
	player.process_mode = Node.PROCESS_MODE_INHERIT
	print(player.position)
	player.position.x = 600
	player.position.y = 300
	player.show()
	player.not_dead = true;
