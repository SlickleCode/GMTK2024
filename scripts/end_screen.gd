extends Control

func update_score(new_score):
	$GridContainer/ColorRect/MarginContainer/ColorRect/VBoxContainer/Label.text = "Score: " + str(new_score)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/start.tscn")
