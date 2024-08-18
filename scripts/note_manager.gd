extends Node2D

var note_scene = preload('res://scenes/Note.tscn')

func _ready():
	create_note()
	create_note()
	create_note()
	create_note()

func _physics_process(delta):
	var notes = $NoteGroup.get_children()
	for note in notes:
		note.position.y += 1

func create_note():
	var note_instance = note_scene.instantiate()
	note_instance.body_part = randi_range(0, 4)
	$NoteGroup.add_child(note_instance)
