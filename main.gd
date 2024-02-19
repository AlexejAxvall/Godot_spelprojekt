extends Node2D


func _on_exit_game_pressed():
	get_tree().quit()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://the_fight.tscn")
