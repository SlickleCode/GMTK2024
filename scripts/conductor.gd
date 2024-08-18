extends AudioStreamPlayer

@export var bpm := 80
@export var measures := 4

# Tracking the beat and song position
var song_position = 0.0
var song_position_in_beats = 1
var sec_per_beat = 60.0 / bpm
var last_reported_beat = 0
var beats_before_start = 0
var cur_measure_spot = 1

# Determining how close to the beat an event is
var closest = 0
var time_off_beat = 0.0

signal beat(position)
signal spot_in_measure(position)

func _ready():
	sec_per_beat = 60.0 / bpm

func _physics_process(_delta):
	if playing:
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		song_position_in_beats = int(floor(song_position / sec_per_beat)) + beats_before_start
		_report_beat()

func _report_beat():
	if last_reported_beat < song_position_in_beats:
		if cur_measure_spot > measures:
			cur_measure_spot = 1
		emit_signal("beat", song_position_in_beats)
		emit_signal("spot_in_measure", cur_measure_spot)
		last_reported_beat = song_position_in_beats
		cur_measure_spot += 1

func play_with_beat_offset(num):
	beats_before_start = num
#	TODO FIX WHY ITS NULL AHHH
	#$StartTimer.wait_time = sec_per_beat
	#$StartTimer.start()

func closest_beat(nth):
	closest = int(round((song_position / sec_per_beat) / nth) * nth) 
	time_off_beat = abs(closest * sec_per_beat - song_position)
	return Vector2(closest, time_off_beat)

func play_from_beat(beat, offset):
	play()
	seek(beat * sec_per_beat)
	beats_before_start = offset
	cur_measure_spot = beat % measures


func _on_start_timer_timeout():
	song_position_in_beats += 1
	if song_position_in_beats < beats_before_start - 1:
		$StartTimer.start()
	elif song_position_in_beats == beats_before_start - 1:
		$StartTimer.wait_time = $StartTimer.wait_time - (AudioServer.get_time_to_next_mix() +
														AudioServer.get_output_latency())
		$StartTimer.start()
	else:
		play()
		$StartTimer.stop()
	_report_beat()
