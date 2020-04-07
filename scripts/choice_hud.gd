extends Control

var options = []
var n_choices
const text_box_scene = preload("res://scenes/standard_text.tscn")
var text_box_instance

onready var vbox = $background/VBoxContainer
onready var bg = $background
onready var arrow = $background/arrow
onready var anim = $AnimationPlayer
onready var dialogue_box = get_tree().get_root().get_node("Scene").find_node("dialogue_box")
onready var clock = get_tree().get_root().get_node("Scene").find_node("clock")

var arrow_index
var arrow_starting_pos
var active = true

var timer2

func _ready():
	Global.connect("choice_executed", self, "_on_choice_executed")
	anim.play("come_in")
	arrow_starting_pos = arrow.rect_position
	arrow_index = 0
	set_process_input(true)
	n_choices = vbox.get_child_count()

func _on_choice_executed():
	# togli l'hud
	hide()
	dialogue_box.anim.play("restore_size")
	dialogue_box.hide()
	
	# 2: aspetta che il tempo scorra
	Global.time_stop = false
	yield(clock, "activity_finish")
	
	# 3: fai tornare a muovere il player
	Global.can_move = true
	dialogue_box.active = false
	
	# 4: distruggi self
	dialogue_box.choice_box_instance = null
	queue_free()

func _input(event):
	if active:
		if event.is_action_pressed("move_down"):
			move_arrow_down(80)
		if event.is_action_pressed("move_up"):
			move_arrow_up(80)
		if event.is_action_pressed("ui_accept"):
			execute_option(arrow_index)
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
	active = false
	if index != n_choices -1:
		assert(options[index] in Global.activities_dict)
		if can_perform_activity(options[index]):
			Global.perform_activity(options[index])
			Global.emit_signal("choice_executed")
		else:
			print("can't execute!")
			execute_null_action()
	else:
		execute_null_action()
	pass

func execute_null_action():
	# togli l'hud
		hide()
		dialogue_box.anim.play("restore_size")
		dialogue_box.hide()
		
		# 3: fai tornare a muovere il player
		Global.can_move = true
		
		#time window per il dialogo
		timer2 = Timer.new()
		add_child(timer2)
		timer2.wait_time = 0.3
		timer2.start()
		yield(timer2, "timeout")
		dialogue_box.active = false
		
		# 4: distruggi self
		dialogue_box.choice_box_instance = null
		queue_free()
		pass

func can_perform_activity(activity_name):
	var sanity_bonus = int(Global.activities_dict[activity_name]["Sanity"])
	var energy_bonus = int(Global.activities_dict[activity_name]["Energy"])
	var productivity_bonus = int(Global.activities_dict[activity_name]["Productivity"])
	var time_spent = int(Global.activities_dict[activity_name]["Time"])
	
	if Global.sanity + sanity_bonus < 0 or Global.energy + energy_bonus < 0:
		return false
	else:
		return true
	pass
	

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
