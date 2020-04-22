extends Node

#player stats
var sanity
var energy
var productivity
var time_stop = false
var can_move = true
var activities_dict

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

func can_perform_activity(activity_name):
	var sanity_bonus = int(Global.activities_dict[activity_name]["Sanity"])
	var energy_bonus = int(Global.activities_dict[activity_name]["Energy"])
	var productivity_bonus = int(Global.activities_dict[activity_name]["Productivity"])
	#var time_spent = int(Global.activities_dict[activity_name]["Time"])
	
	if Global.sanity + sanity_bonus < 0 or Global.energy + energy_bonus < 0 or Global.productivity + productivity_bonus < 0:
		return false
	else:
		return true
	pass
