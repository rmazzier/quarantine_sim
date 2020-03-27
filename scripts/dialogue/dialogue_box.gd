extends Control

const choice_box_scene = preload("res://scenes/choice_hud.tscn")

onready var text_label = $RichTextLabel
onready var anim = $AnimationPlayer
var page 
var dialogue
var active

func _ready():
	anim.play("restore_size")
	Global.connect("dialog_finished", self, "_on_dialog_finished")
	hide()
	active = false
	page = 0
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_accept") and active:
		if text_label.visible_characters > text_label.get_total_character_count():
			if page < dialogue.size()-1:
				page += 1
				text_label.bbcode_text = dialogue[str(page)]["text"]
				text_label.visible_characters = 0
				
				#if this line of dialog has a choice, load che choice hud!
				if "choices" in dialogue[str(page)]:
					print(dialogue[str(page)]["choices"].values())
					var choice_box_instance = choice_box_scene.instance()
					var choices = dialogue[str(page)]["choices"].values()
					
					anim.play("reduce_size")
					add_child(choice_box_instance)
					for choice in choices:
						choice_box_instance.add_option(choice)
						pass
					
			else:
				Global.emit_signal("dialog_finished")
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
	Global.time_stop = true
	text_label.visible_characters = 0 
	page = 0
	dialogue = load_dialogue(interagibile_file_path)
	text_label.bbcode_text = dialogue[str(page)]["text"]

func play_dialogue() -> void:
	pass

func _on_Timer_timeout():
	if text_label.visible_characters <= text_label.get_total_character_count() + 1:
		text_label.visible_characters += 1
	pass # Replace with function body.

func _on_dialog_finished():
	#hide....
	self.hide()
	anim.play("restore_size")
	var timer2 = $Timer2
	timer2.start()
	
	pass # Replace with function body.

func _on_Timer2_timeout():
	active = false
	Global.time_stop = false
	pass # Replace with function body.
