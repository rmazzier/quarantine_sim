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
		#print(arrow_index)
	pass

func add_option(text):
	# adds the option's text
	text_box_instance = text_box_scene.instance()
	vbox.add_child(text_box_instance)
	text_box_instance.bbcode_text = text
	options.append(text)
	n_choices = vbox.get_child_count()
	
	if text in Global.activities_dict:
		draw_bonus_icons(text)
	
	if n_choices > 1:
		resize_bg(80)
	pass

func execute_option(index):
	#print(options[index])
	if index != n_choices -1:
		Global.perform_activity(options[index])

func resize_bg(amount):
	bg.rect_position.y -= amount
	bg.rect_size.y += amount
	pass

func draw_bonus_icons(text):
	var sprite_container = VBoxContainer.new()
	bg.add_child(sprite_container)
	var bonus_sanity = int(Global.activities_dict[text]["Sanity"])
	var bonus_energy = int(Global.activities_dict[text]["Energy"])
	var bonus_productivity = int(Global.activities_dict[text]["Productivity"])
	var bonuses = {
		"sanity":bonus_sanity, 
		"energy":bonus_energy, 
		"productivity":bonus_productivity}
	var child_num = n_choices-1
	var drawn_sprites = 0
	for bonus in bonuses:
		var sprite = Sprite.new()
		if bonuses[bonus] > 0:
			sprite.texture = load(
				"res://assets/hud/%s_plus_icon.png" % bonus)
		elif bonuses[bonus] < 0:
			sprite.texture = load(
				"res://assets/hud/%s_minus_icon.png" % bonus)
		
		sprite_container.add_child(sprite)
		sprite.position = Vector2(
			vbox.get_child(child_num).rect_position.x + 620 + 40*drawn_sprites,
			-14 + n_choices * 80)
		sprite.scale *= 1.1
		drawn_sprites += 1
