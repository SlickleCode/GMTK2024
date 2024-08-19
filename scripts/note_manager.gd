extends Node2D

var note_scene = preload('res://scenes/Note.tscn')
var notes_map = {
	Enums.Limb.LEFT_FOOT: "left_foot_spawner/left_foot_notes",
	Enums.Limb.RIGHT_FOOT: "right_foot_spawner/right_foot_notes",
	Enums.Limb.LEFT_HAND: "left_hand_spawner/left_hand_notes",
	Enums.Limb.RIGHT_HAND: "right_hand_spawner/right_hand_notes",
}


func _physics_process(delta):
	var notes = []
	for note_list in notes_map.values():
		notes.append_array(get_node(note_list).get_children())
	
	for note in notes:
		note.position.y += 1

func create_random_note():
	create_note_of_type(randi_range(0, 3))

func create_two_random_note():
	var random_note = randi_range(0, 3)
	create_note_of_type(random_note)
	create_note_of_type((random_note + 1) % 4)
	
func create_three_random_note():
	var random_note = randi_range(0, 3)
	create_note_of_type(random_note)
	create_note_of_type((random_note + 1) % 4)
	create_note_of_type((random_note + 2) % 4)

func create_four_random_note():
	create_note_of_type(0)
	create_note_of_type(1)
	create_note_of_type(2)
	create_note_of_type(3)
	
func create_note_of_type(limb_type):
	var note_instance = note_scene.instantiate()
	note_instance.body_part = limb_type
	get_node(notes_map[limb_type]).add_child(note_instance)
		
func check_for_points(limb):
	var notes_list = get_node(notes_map[limb]).get_children()
	var score = 0
	for note in notes_list:
		if note.potential_score > 0:
			score = note.potential_score
			#TODO call any animation for when they are deleted, perhaps a display of how on the note it was
			note.queue_free()
	return score
	
