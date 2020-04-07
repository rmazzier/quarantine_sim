extends Control

var datetime_class = load("res://scripts/DateTime.gd")
var datetime1
var target_datetime

onready var hour_text = $hour
onready var date_text = $date
onready var tick_timer = $tick
onready var tween = $Tween
onready var debug_tick_text = $debug_tick

signal activity_finish

export var tick = 0.2

func _ready():
	datetime1 = datetime_class.new()
	#read hour from save file
	datetime1.set_datetime_explicit(23, 45, 28, 2, 2020)
	target_datetime = datetime_class.new()
	target_datetime.set_datetime_explicit(23, 45, 28, 2, 2020)
	tick_timer.wait_time = tick
	update_datetime_hud()

func update_datetime_hud():
	var hour_str = "0" + str(datetime1.hr)
	hour_str = hour_str[-2] + hour_str[-1]
	var mins_str = "0" + str(datetime1.mi)
	mins_str = mins_str[-2] + mins_str[-1]
	hour_text.bbcode_text = "%s : %s" % [hour_str, mins_str]
	var day_str = "0" + str(datetime1.da)
	day_str = day_str[-2] + day_str[-1]
	var month_str = "0" + str(datetime1.mo)
	month_str = month_str[-2] + month_str[-1]
	date_text.bbcode_text = "%s / %s / %d" % [day_str, month_str, datetime1._Year]
	
	debug_tick_text.bbcode_text = str(tick_timer.wait_time)

var distance_prev_frame = 0

func _process(delta):
	var distance = datetime1.distance_between(target_datetime)
	
	if distance_prev_frame > 0 and distance == 0:
		emit_signal("activity_finish")
	#metti un tick custom che dipende dalla distanza..
	# più lontano = più veloce, più vicino = più lento!
	var tick2 = tick / (distance +1)
	tick_timer.wait_time = tick2
	
	distance_prev_frame = distance
	
func _on_tick_timeout():
	if Global.time_stop == false :
		datetime1.add_minutes(1)
		if target_datetime._min(datetime1) == target_datetime:
			# non appena datetime1 raggiunge target_datetime, updata target_datetime
			target_datetime.set_datetime_implicit(
				datetime1._Minute,
				datetime1._Day,
				datetime1._Year)
		update_datetime_hud()

