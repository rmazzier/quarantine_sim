extends Node2D

var mother_activities_path = "res://assets/dialogue/dialogues_data/mother_activities.json"
var mother_activities_dict

var on_screen = false
var all_activities

func _ready():
	
	mother_activities_dict = Global.load_json(mother_activities_path)
	all_activities = mother_activities_dict.keys()
	print(all_activities)
	perform_random_activity()
	
func perform_random_activity():
	randomize()
	var index = randi() % len(all_activities)
	print(index)
	var activity = all_activities[index]
	# play animation?
#	#set position
	self.position = Vector2(
		mother_activities_dict[activity]["posx"],
		mother_activities_dict[activity]["posy"])
	pass

func _on_visibility_modifier_screen_entered():
	on_screen = true
	print("entered screen")
	pass # Replace with function body.


func _on_visibility_modifier_screen_exited():
	on_screen = false
	print("exited screen")
	pass # Replace with function body.
