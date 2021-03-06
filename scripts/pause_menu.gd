extends Control


onready var resume_button = $resume_button
onready var settings_button = $settings_button
onready var quit_button = $quit_button

onready var anim = $AnimationPlayer
onready var settings_anim = $settings_anim
onready var quit_anim = $quit_anim
onready var resume_anim = $resume_anim

var init_resume_pos
var init_settings_pos
var init_quit_pos

func _ready():
	init_resume_pos = resume_button.rect_position
	init_settings_pos = settings_button.rect_position
	init_quit_pos = quit_button.rect_position
	hide()

func _input(event):
	if event.is_action_pressed("pause") and get_tree().paused == false:
		#instance pause scene
		pause_game()
	elif event.is_action_pressed("pause") and get_tree().paused == true:
		unpause_game()
		pass
	pass

func pause_game():
	get_tree().paused = true
	show()
	resume_button.grab_focus()

func unpause_game():
	get_tree().paused = false
	hide()
	

func _on_resume_button_focus_entered():
	anim.play("resume_hovered_box")
	resume_anim.play("resume_anim")
	pass 

func _on_resume_button_focus_exited():
	resume_button.rect_position = init_resume_pos
	pass 

func _on_resume_button_pressed():
	unpause_game()
	pass 


func _on_settings_button_focus_entered():
	anim.play("settings_hovered_box")
	settings_anim.play("settings_icon_rotate")
	pass # Replace with function body.


func _on_settings_button_focus_exited():
	settings_anim.stop(true)
	settings_button.get_node("settings_icon").rect_rotation = 0
	
	settings_button.rect_position = init_settings_pos
	pass # Replace with function body.

func _on_settings_button_pressed():
	print("settings pressed")
	pass # Replace with function body.


func _on_quit_button_focus_entered():
	anim.play("quit_hovered_box")
	quit_anim.play("quit_icon_anim")
	pass # Replace with function body.


func _on_quit_button_focus_exited():
	quit_anim.stop()
	
	quit_button.rect_position = init_quit_pos
	pass # Replace with function body.


func _on_quit_button_pressed():
	print("quit pressed")
	get_tree().quit()
	pass # Replace with function body.
