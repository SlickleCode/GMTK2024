extends Node2D

var score = 0
var combo = 0
var schmoving = false
var difficulty = 0
var beat_stretch = 0

var conductor_obj = preload("res://scenes/conductor.tscn")
var conductor_instance

var cur_song_count = 0

func _ready():
	$InputManager/RightHandInputSpot/Label.modulate = Color(1, 1, 1, 0)
	$InputManager/LeftHandInputSpot/Label.modulate = Color(1, 1, 1, 0)
	$InputManager/RightLegInputSpot/Label.modulate = Color(1, 1, 1, 0)
	$InputManager/LeftLegInputSpot/Label.modulate = Color(1, 1, 1, 0)
	randomize()
	on_song_change(0)
	$Timer.start()

func on_song_change(amount_of_change):
	#TODO testing line for switching songs
	# amount_of_change = 1
	
	cur_song_count = amount_of_change
	$CanvasLayer.hide()
	conductor_instance = conductor_obj.instantiate()
	conductor_instance.connect("beat", _on_conductor_beat)
	conductor_instance.connect("spot_in_measure", _on_conductor_spot_in_measure)
	conductor_instance.connect("finished", _on_conductor_finished)
	add_child(conductor_instance)
	if amount_of_change == 0:
		beat_stretch = -4
		conductor_instance.stream = load("res://assets/music/good-night-160166.mp3")
		conductor_instance.bpm = 80
		$NoteManager.bpm = 80
	elif amount_of_change == 1:
		beat_stretch = -4
		conductor_instance.stream = load("res://assets/music/lazy-time-summer-relax-lofi-199737.mp3")
		conductor_instance.bpm = 85
		$NoteManager.bpm = 85
	elif amount_of_change == 2:# placeholder
		beat_stretch = -4
		conductor_instance.stream = load("res://assets/music/all-the-time-144594.mp3")
		conductor_instance.bpm = 120
		$NoteManager.bpm = 120
	elif amount_of_change == 1:# placeholder
		conductor_instance.stream = load("res://assets/music/good-night-160166.mp3")
		conductor_instance.bpm = 80
		$NoteManager.bpm = 80
	$Timer.start()

func start_song_and_game():
	score = 0
	combo = 0
	schmoving = true
	$Big.play("walk")
	await get_tree().create_timer(1.0).timeout
	$NoteManager/left_foot_spawner.show()
	$InputManager/LeftLegInputSpot.show()
	$NoteManager/right_foot_spawner.show()
	$InputManager/RightLegInputSpot.show()
	$NoteManager/left_hand_spawner.show()
	$InputManager/LeftHandInputSpot.show()
	$NoteManager/right_hand_spawner.show()
	$InputManager/RightHandInputSpot.show()
	await get_tree().create_timer(3.0).timeout
	$Big.play("run")
	$Tiny.play("sitting")
	$TinyWorld.play("default")
	await get_tree().create_timer(0.5).timeout
	conductor_instance.play_with_beat_offset(0)

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
		create_score_popup(temp_score, limb_enum)
		combo += 1
		if combo > 1000:
			score += temp_score * 5
		elif combo > 100:
			score += temp_score * 1.3
		elif combo > 10:
			score += temp_score * 1.1
		else:
			score += temp_score
		$CanvasLayer/end_screen.update_score(roundf(score))
		
		var tween = get_tree().create_tween()
		tween.tween_property(sprite_node, "scale", Vector2(1.2, 1.2), .1)
		tween.tween_property(sprite_node, "scale", Vector2(1, 1), .2)
	else:
		combo = 0

func create_score_popup(score, limb_enum):
	var score_text = ''
	if score == 1:
		score_text = "poor"
	elif score == 2:
		score_text = "good"
	elif score == 3:
		score_text = "perfect"
		
	var tween = get_tree().create_tween()
	if limb_enum == Globals.Limb.RIGHT_HAND:
		$InputManager/RightHandInputSpot/Label.text = score_text
		tween.tween_property($InputManager/RightHandInputSpot/Label, "modulate", Color(1, 1, 1, 0), .3).from(Color(1, 1, 1, 1))
	if limb_enum == Globals.Limb.LEFT_HAND:
		$InputManager/LeftHandInputSpot/Label.text = score_text
		tween.tween_property($InputManager/LeftHandInputSpot/Label, "modulate", Color(1, 1, 1, 0), .3).from(Color(1, 1, 1, 1))
	if limb_enum == Globals.Limb.RIGHT_FOOT:
		$InputManager/RightLegInputSpot/Label.text = score_text
		tween.tween_property($InputManager/RightLegInputSpot/Label, "modulate", Color(1, 1, 1, 0), .3).from(Color(1, 1, 1, 1))
	if limb_enum == Globals.Limb.LEFT_FOOT:
		$InputManager/LeftLegInputSpot/Label.text = score_text
		tween.tween_property($InputManager/LeftLegInputSpot/Label, "modulate", Color(1, 1, 1, 0), .3).from(Color(1, 1, 1, 1))

func _on_conductor_beat(beat_position):
	#print(beat_position)
	var relative_beat = beat_position - beat_stretch
	if cur_song_count == 0:
		good_night_beat_stuff(relative_beat)
	if cur_song_count > 0:
		lazy_time_summer_beat_stuff(relative_beat)

func lazy_time_summer_beat_stuff(beat_position):
	if beat_position > 16:
		difficulty = 1

func good_night_beat_stuff(beat_position):
	if beat_position > 16:
		difficulty = 1
	if beat_position > 48 and beat_position % 2 == 0:
		difficulty = 1
	if beat_position > 48 and beat_position % 2 == 1:
		difficulty = 2
	if beat_position > 80:
		difficulty = 1
	if beat_position > 96:
		difficulty = 4
	if beat_position > 97 and beat_position % 2 == 0:
		difficulty = 1
	if beat_position > 97 and beat_position % 2 == 1:
		difficulty = 2
	if beat_position > 112:
		difficulty = 1
	if beat_position > 116:
		difficulty = 4
	if beat_position > 117 and beat_position % 2 == 0:
		difficulty = 1
	if beat_position > 117 and beat_position % 2 == 1:
		difficulty = 3
	if beat_position > 144 and beat_position % 2 == 0:
		difficulty = 1
	if beat_position > 144 and beat_position % 2 == 1:
		difficulty = 2
	if beat_position > 144 and beat_position % 4 == 1:
		difficulty = 4
	if beat_position > 180:
		difficulty = 1
	if beat_position > 192:
		difficulty = 0

func _on_conductor_spot_in_measure(measure_position):
	print(measure_position)
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
	$Big.play("walk")
	$Tiny.stop()
	await get_tree().create_timer(3.0).timeout
	schmoving = false
	$Big.play("wait")
	$NoteManager/left_foot_spawner.hide()
	$InputManager/LeftLegInputSpot.hide()
	$NoteManager/right_foot_spawner.hide()
	$InputManager/RightLegInputSpot.hide()
	$NoteManager/left_hand_spawner.hide()
	$InputManager/LeftHandInputSpot.hide()
	$NoteManager/right_hand_spawner.hide()
	$InputManager/RightHandInputSpot.hide()
	await get_tree().create_timer(1.5).timeout
	$Tiny.play("resting")
	$TinyWorld.play("still")
	$CanvasLayer.show()
	

func _on_area_2d_body_entered(body):
	print(body)
