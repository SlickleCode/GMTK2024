extends Node2D


func _ready():
	randomize()
	$Conductor.play_with_beat_offset(8)


func _on_conductor_beat(position):
	print(position)
	pass # Replace with function body.


func _on_conductor_spot_in_measure(position):
	if position == 1:
		print('tomato1')
	elif position == 2:
		print("tomato2")
	elif position == 3:
		print("tomato3")
	elif position == 4:
		print('tomato4')
