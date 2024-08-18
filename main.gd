extends Node2D

var score = 0

func _ready():
	randomize()
	$Conductor.play_with_beat_offset(8)

func _physics_process(delta):
	$BigSkyLine.position.x -= .1
	if $BigSkyLine.position.x < 110:
		$BigSkyLine.position.x = 429
	$BigPath.position.x -= .5
	if $BigPath.position.x < 110:
		$BigPath.position.x = 324

	if Input.is_action_just_pressed('left_leg'):
		print('left leg button')
		score += $NoteManager.check_for_points(Enums.Limb.LEFT_FOOT)
		print('Score: ' + str(score))
	elif Input.is_action_just_pressed('right_leg'):
		print('right leg button')
		score += $NoteManager.check_for_points(Enums.Limb.RIGHT_FOOT)
		print('Score: ' + str(score))
	elif Input.is_action_just_pressed('left_hand'):
		print('left hand button')
		score += $NoteManager.check_for_points(Enums.Limb.LEFT_HAND)
		print('Score: ' + str(score))
	elif Input.is_action_just_pressed('right_hand'):
		print('right hand button')
		score += $NoteManager.check_for_points(Enums.Limb.RIGHT_HAND)
		print('Score: ' + str(score))

func _on_conductor_beat(position):
	#print(position)
	pass


func _on_conductor_spot_in_measure(position):
	if position == 1:
		$NoteManager.create_random_note()
	elif position == 2:
		$NoteManager.create_random_note()
	elif position == 3:
		$NoteManager.create_random_note()
	elif position == 4:
		$NoteManager.create_random_note()
