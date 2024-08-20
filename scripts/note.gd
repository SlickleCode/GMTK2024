extends Node2D

@export_range(0, 4) var body_part := 0

signal remove_combo

var notes = [
	preload("res://assets/notes/left_foot.png"),
	preload("res://assets/notes/right_foot.png"),
	preload("res://assets/notes/left_hand.png"),
	preload("res://assets/notes/right_hand.png")
]

var potential_score = 0

func _ready():
	body_part = body_part % 4
	$NotePicture.texture = notes[body_part]

func _on_poor_rating_area_entered(area):
	if area.name == 'Despawner':
		emit_signal("remove_combo")
		queue_free()
	potential_score += 1

func _on_good_rating_area_entered(area):
	potential_score += 1

func _on_perfect_rating_area_entered(area):
	potential_score += 1

func _on_poor_rating_area_exited(area):
	potential_score = potential_score - 1

func _on_good_rating_area_exited(area):
	potential_score = potential_score - 1

func _on_perfect_rating_area_exited(area):
	potential_score = potential_score - 1
