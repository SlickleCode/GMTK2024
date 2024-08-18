extends Node2D


func _ready():
	randomize()
	$Conductor.play_with_beat_offset(8)


func _on_conductor_beat(position):
	print(position)
	pass # Replace with function body.


func _on_conductor_spot_in_measure(position):
	if position == 1:
		$NoteManager.create_random_note()
	elif position == 2:
		$NoteManager.create_random_note()
	elif position == 3:
		$NoteManager.create_random_note()
	elif position == 4:
		$NoteManager.create_random_note()
