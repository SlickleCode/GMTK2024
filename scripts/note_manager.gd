extends Node2D

var note_scene = preload('res://scenes/Note.tscn')

func _physics_process(delta):
	var notes = $left_foot_spawner/left_foot_notes.get_children()
	notes.append_array($right_foot_spawner/right_foot_notes.get_children())
	notes.append_array($left_hand_spawner/left_hand_notes.get_children())
	notes.append_array($right_hand_spawner/right_hand_notes.get_children())
	
	for note in notes:
		note.position.y += 1

func create_random_note():
	create_note_of_type(randi_range(0, 3))
	
func create_note_of_type(limb_type):
	var note_instance = note_scene.instantiate()
	note_instance.body_part = limb_type
	add_note_to_group(note_instance)
	
func add_note_to_group(note):
	#TODO based on part, put in certain lane
	if note.body_part == note.Limb.LEFT_FOOT:
		$left_foot_spawner/left_foot_notes.add_child(note)
	elif note.body_part == note.Limb.RIGHT_FOOT:
		$right_foot_spawner/right_foot_notes.add_child(note)
	elif note.body_part == note.Limb.LEFT_HAND:
		$left_hand_spawner/left_hand_notes.add_child(note)
	elif note.body_part == note.Limb.RIGHT_HAND:
		$right_hand_spawner/right_hand_notes.add_child(note)
