extends Control

var options = []
var n_choices
const text_box_scene = preload("res://scenes/standard_text.tscn")
var text_box_instance

onready var vbox = $background/VBoxContainer
onready var bg = $background
onready var arrow = $background/arrow
onready var anim = $AnimationPlayer

var arrow_index
var arrow_starting_pos

func _ready():
	anim.play("come_in")
	arrow_starting_pos = arrow.rect_position
	arrow_index = 0
	set_process_input(true)
	n_choices = vbox.get_child_count()

func _input(event):
	if event.is_action_pressed("move_down"):
		move_arrow_down(80)
	if event.is_action_pressed("move_up"):
		move_arrow_up(80)
	if event.is_action_pressed("ui_accept"):
		execute_option(arrow_index)
		queue_free()
	if event.is_action_pressed("move_right"):
		add_option("sample")
	pass

func move_arrow_down(amount):
	if arrow_index < n_choices-1:
		arrow.rect_position.y += amount
		arrow_index +=1
		print(arrow_index)
	pass

func move_arrow_up(amount):
	if arrow_index > 0:
		arrow.rect_position.y -= amount
		arrow_index -=1
		print(arrow_index)
	pass

func add_option(text):
	""" Add the option with the text you """
	text_box_instance = text_box_scene.instance()
	vbox.add_child(text_box_instance)
	text_box_instance.bbcode_text = text
	options.append(text)
	n_choices = vbox.get_child_count()
	if n_choices > 1:
		resize_bg(80)
	pass

func execute_option(index):
	print(options[index])

func resize_bg(amount):
	bg.rect_position.y -= amount
	bg.rect_size.y += amount
	pass
