extends Node2D


func _ready():
	randomize()
	$Conductor.play_with_beat_offset(8)

func _physics_process(delta):
	$"Big World".position.x -= .1
	if $"Big World".position.x < 110:
		$"Big World".position.x = 429

func _on_conductor_beat(position):
	#print(position)
	pass


func _on_conductor_spot_in_measure(position):
	if position == 1:
		$NoteManager.create_note()
	elif position == 2:
		$NoteManager.create_note()
	elif position == 3:
		$NoteManager.create_note()
	elif position == 4:
		$NoteManager.create_note()
