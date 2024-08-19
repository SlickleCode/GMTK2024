extends Node2D

var score = 0
var combo = 0
var schmoving = true
var difficulty = 0
var beat_stretch = 0

func _ready():
	randomize()
	$Conductor.play_with_beat_offset(0)

func _physics_process(delta):
	if schmoving:
		$HUD/Combo.text = "Combo: " + str(combo)
		$BigSkyLine.position.x -= .1
		if $BigSkyLine.position.x < 110:
			$BigSkyLine.position.x = 429
		$BigPath.position.x -= .5
		if $BigPath.position.x < 110:
			$BigPath.position.x = 324

		if Input.is_action_just_pressed('left_leg'):
			handle_note_input($InputManager/LeftLegInputSpot, Globals.Limb.LEFT_FOOT)
		if Input.is_action_just_pressed('right_leg'):
			handle_note_input($InputManager/RightLegInputSpot, Globals.Limb.RIGHT_FOOT)
		if Input.is_action_just_pressed('left_hand'):
			handle_note_input($InputManager/LeftHandInputSpot, Globals.Limb.LEFT_HAND)
		if Input.is_action_just_pressed('right_hand'):
			handle_note_input($InputManager/RightHandInputSpot, Globals.Limb.RIGHT_HAND)

func handle_note_input(sprite_node, limb_enum):
	var temp_score = $NoteManager.check_for_points(limb_enum)
	if temp_score > 0:
		combo += 1
		score += temp_score
		var tween = get_tree().create_tween()
		tween.tween_property(sprite_node, "scale", Vector2(1.2, 1.2), .1)
		tween.tween_property(sprite_node, "scale", Vector2(1, 1), .2)
	else:
		combo = 0

func _on_conductor_beat(beat_position):
	var relative_beat = beat_position - beat_stretch
	if relative_beat > 12:
		difficulty = 1
	if relative_beat > 48:
		difficulty = 2
	if relative_beat > 90:
		difficulty = 1
	if relative_beat > 96:
		difficulty = 3
	if relative_beat > 100:
		difficulty = 1


func _on_conductor_spot_in_measure(measure_position):
	if measure_position == 1:
		check_difficulty_and_spawn()
	elif measure_position == 2:
		check_difficulty_and_spawn()
	elif measure_position == 3:
		check_difficulty_and_spawn()
	elif measure_position == 4:
		check_difficulty_and_spawn()

func check_difficulty_and_spawn():
	if difficulty == 1:
		$NoteManager.create_random_note()
	elif difficulty == 2:
		$NoteManager.create_two_random_note()
	elif difficulty == 3:
		$NoteManager.create_three_random_note()
	elif difficulty == 4:
		$NoteManager.create_four_random_note()

func _on_conductor_finished():
	schmoving = false
	$CanvasLayer/end_screen.update_score(score)
	await get_tree().create_timer(3.0).timeout
	$Big.play("walk")
	await get_tree().create_timer(3.0).timeout
	$Big.play("wait")
	$NoteManager/left_foot_spawner.hide()
	$InputManager/LeftLegInputSpot.hide()
	$NoteManager/right_foot_spawner.hide()
	$InputManager/RightLegInputSpot.hide()
	$NoteManager/left_hand_spawner.hide()
	$InputManager/LeftHandInputSpot.hide()
	$NoteManager/right_hand_spawner.hide()
	$InputManager/RightHandInputSpot.hide()
	await get_tree().create_timer(3.0).timeout
	$CanvasLayer.show()
	$Tiny.hide()
	
