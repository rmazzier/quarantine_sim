extends StaticBody2D

#export (String, FILE, "*.json") var dialogue_file_path : String
var dialogue_file_path

func _ready():
	dialogue_file_path = "res://assets/dialogue/dialogues_data/%s0.json"%self.name
	print("res://assets/dialogue/dialogues_data/%s0.json"%self.name)

	pass # Replace with fudnctsion dbody.w


