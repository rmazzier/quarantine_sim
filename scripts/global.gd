extends Node

#player stats
var sanity
var energy
var productivity
var time_stop = false
var can_move = true
var activities_dict

onready var hud = get_tree().get_root().get_node("Scene").find_node("stats_wheel")
onready var clock = get_tree().get_root().get_node("Scene").find_node("clock")

signal dialog_finished
signal choice_executed

var activities_path = "res://assets/dialogue/dialogues_data/activities.json"

func _ready():
	#prendi le stats dal save file!
	
	#per ora le setto a valori random (da 1 a 100)
	sanity = 60
	energy = 40
	productivity = 0
	
	#carica il file con tutte le attività a i relativi valori
	activities_dict = load_json(activities_path)
	pass 

func load_json(file_path) -> Dictionary:
	""" Parses JSON """
	
	var file = File.new()
	assert(file.file_exists(file_path))
	file.open(file_path, file.READ)
	var this_dialogue = parse_json(file.get_as_text())
	assert(this_dialogue.size() > 0)
	return this_dialogue

func add_productivity(value):
	if productivity + value <= 100:
		productivity += value
	else:
		productivity = 100
	hud.update_wheel(hud.anim_duration)

func add_sanity(value):
	if sanity + value <= 100:
		sanity += value
	else:
		sanity = 100
	hud.update_wheel(hud.anim_duration)

func add_energy(value):
	if energy + value <= 100:
		energy += value
	else:
		energy = 100
	hud.update_wheel(hud.anim_duration)

func perform_activity(activity_name):
	#takes activity_name as input and modifies the stats according to activities_dict
	if activity_name in activities_dict:
		var sanity_bonus = int(activities_dict[activity_name]["Sanity"])
		var energy_bonus = int(activities_dict[activity_name]["Energy"])
		var productivity_bonus = int(activities_dict[activity_name]["Productivity"])
		var time_spent = int(activities_dict[activity_name]["Time"])
		
		#add bonuses
		clock.target_datetime.add_minutes(time_spent)
		if sanity_bonus != 0:
			add_sanity(sanity_bonus)
		if energy_bonus != 0:
			add_energy(energy_bonus)
		if productivity_bonus != 0 :
			add_productivity(productivity_bonus)
	pass
