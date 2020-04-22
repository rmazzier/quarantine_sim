extends Control

onready var new_button = $new_button
var main_level_path = "res://scenes/main_scene.tscn"

func _ready():
	new_button.grab_focus()
	pass # Replace with function body.




func _on_new_button_pressed():
	get_tree().change_scene(main_level_path)
	pass # Replace with function body.
