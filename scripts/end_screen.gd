extends Control

func update_score(new_score):
	$GridContainer/ColorRect/MarginContainer/Label.text = "Score: " + new_score
