extends Control

var mins
var hour

var day
var month
var year

onready var hour_text = $hour
onready var date_text = $date
onready var tick_timer = $tick

export var tick = 0.2

func _ready():
	tick_timer.wait_time = tick
	year = OS.get_datetime()["year"]
	month = OS.get_datetime()["month"]
	day = OS.get_datetime()["day"]
	
	hour = OS.get_datetime()["hour"]
	mins = OS.get_datetime()["minute"] 
	
	update_datetime()
	pass # Replace with function body.

func update_datetime():
	var hour_str = "0" + str(hour)
	hour_str = hour_str[-2] + hour_str[-1]
	var mins_str = "0" + str(mins)
	mins_str = mins_str[-2] + mins_str[-1]
	hour_text.bbcode_text = "%s : %s" % [hour_str, mins_str]
	var day_str = "0" + str(day)
	day_str = day_str[-2] + day_str[-1]
	var month_str = "0" + str(month)
	month_str = month_str[-2] + month_str[-1]
	date_text.bbcode_text = "%s / %s / %d" % [day_str, month_str, year]
	
func add_minute(amount):
	if mins + amount < 60:
		mins += amount
	else:
		mins = (mins+amount)%60
		add_hour(1)
	pass

func add_hour(amount):
	if hour + amount < 24:
		hour += amount
	else:
		hour = (hour+amount) % 24
		add_day()
	pass

func add_day():
	# 30 giorni : 4, 6, 9, 11
	if month in [4, 6, 9, 11]:
		if day + 1 <= 30:
			day += 1
		else:
			day = 1
			add_month()
	elif month == 2:
		if day +1 <= 28:
			day +=1
		else:
			day = 1
			add_month()
	else:
		if day +1 <= 31:
			day += 1
		else:
			day = 1
			add_month()
	pass

func add_month():
	if month +1 < 12:
		month += 1
	else:
		month = 1
		add_year()
	pass

func add_year():
	year += 1
	pass

func _on_tick_timeout():
	add_minute(1)
	update_datetime()
	pass # Replace with function body.
