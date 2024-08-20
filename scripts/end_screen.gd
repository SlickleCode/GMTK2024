extends Control

var count = 0
signal change_song(count)

func update_score(new_score):
	$GridContainer/ColorRect/MarginContainer/ColorRect/VBoxContainer/Label.text = "Score: " + str(new_score)

func _physics_process(delta):
	if count >= 2:
		$GridContainer/ColorRect/MarginContainer/ColorRect/VBoxContainer/HBoxContainer/Button.hide()

func _on_button_pressed():
	count += 1
	emit_signal("change_song", count)

func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://scenes/start.tscn")
