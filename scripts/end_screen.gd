extends Control

var count = 0
signal change_song(count)

func update_score(new_score):
	$GridContainer/ColorRect/MarginContainer/ColorRect/VBoxContainer/Label.text = "Score: " + str(new_score)

func _on_button_pressed():
	count += 1
	emit_signal("change_song", count)
