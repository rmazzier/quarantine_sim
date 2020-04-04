extends Control

var datetime_class = load("res://scripts/DateTime.gd")
var datetime1

onready var hour_text = $hour
onready var date_text = $date
onready var tick_timer = $tick
onready var tween = $Tween

export var tick = 0.2

func _ready():
	datetime1 = datetime_class.new()
	datetime1.set_datetime_explicit(23, 45, 28, 2, 2020)
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

func _on_tick_timeout():
	if Global.time_stop == false:
		datetime1.add_minutes(1)
		update_datetime_hud()

func add_minutes_smooth(amount):
	var target_datetime = datetime1.add_minutes(amount)
	tick_timer.wait_time = 0.03
	pass
