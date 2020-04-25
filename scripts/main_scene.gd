extends Node

onready var hud = find_node("stats_wheel")
onready var clock = find_node("clock")
onready var mother = find_node("mother")

signal choice_executed
signal dialog_finished

func add_productivity(value):
	if Global.productivity + value <= 100:
		Global.productivity += value
	else:
		Global.productivity = 100
	hud.update_wheel(hud.anim_duration)

func add_sanity(value):
	if Global.sanity + value <= 100:
		Global.sanity += value
	else:
		Global.sanity = 100
	hud.update_wheel(hud.anim_duration)

func add_energy(value):
	if Global.energy + value <= 100:
		Global.energy += value
	else:
		Global.energy = 100
	hud.update_wheel(hud.anim_duration)

func perform_activity(activity_name):
	#takes activity_name as input and modifies the stats according to activities_dict
	if activity_name in Global.activities_dict:
		var sanity_bonus = int(Global.activities_dict[activity_name]["Sanity"])
		var energy_bonus = int(Global.activities_dict[activity_name]["Energy"])
		var productivity_bonus = int(Global.activities_dict[activity_name]["Productivity"])
		var time_spent = int(Global.activities_dict[activity_name]["Time"])
		
		#add bonuses
		clock.target_datetime.add_minutes(time_spent)
		if sanity_bonus != 0:
			add_sanity(sanity_bonus)
		if energy_bonus != 0:
			add_energy(energy_bonus)
		if productivity_bonus != 0 :
			add_productivity(productivity_bonus)
		if mother.on_screen == false:
			mother.perform_random_activity()
	pass
