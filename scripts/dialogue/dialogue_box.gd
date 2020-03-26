extends Control

#export (String, FILE, "*.json") var dialogue_file_path : String

signal finished

onready var text_label = $RichTextLabel
var page 
var dialogue
var active

func _ready():
	hide()
	active = false
	page = 0

	#print(dialogue[str(0)]["text"])
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_accept") and active:
		if text_label.visible_characters > text_label.get_total_character_count():
			if page < dialogue.size()-1:
				page += 1
				text_label.bbcode_text = dialogue[str(page)]["text"]
				text_label.visible_characters = 0 
			else:
				emit_signal("finished")
		else:
			text_label.visible_characters = text_label.get_total_character_count()


func load_dialogue(file_path) -> Dictionary:
	""" Parses JSON """
	
	var file = File.new()
	assert(file.file_exists(file_path))
	
	file.open(file_path, file.READ)
	var this_dialogue = parse_json(file.get_as_text())
	assert(this_dialogue.size() > 0)
	return this_dialogue

func interact(interagibile_file_path) -> void:
	show()
	active = true 
	text_label.visible_characters = 0 
	page = 0
	dialogue = load_dialogue(interagibile_file_path)
	text_label.bbcode_text = dialogue[str(page)]["text"]
	#play_dialogue() e aspetta che emetta finished

func play_dialogue() -> void:
	pass

func _on_Timer_timeout():
	if text_label.visible_characters <= text_label.get_total_character_count() + 1:
		text_label.visible_characters += 1
	pass # Replace with function body.


func _on_Node2D_finished():
	#hide....
	self.hide()
	var timer2 = $Timer2
	timer2.start()
	
	pass # Replace with function body.


func _on_Timer2_timeout():
	active = false
	
	pass # Replace with function body.
