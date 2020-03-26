extends Control

onready var productivity_bar = $productivity_bar
onready var sanity_bar = $sanity_bar
onready var energy_bar = $energy_bar
onready var player =  get_tree().get_root().get_node("Scene").find_node("player")

onready var bar_speed = 20

func _ready():
	set_process_input(true)
	productivity_bar.value = Global.productivity
	sanity_bar.value = Global.sanity
	energy_bar.value = Global.energy
	pass

func _process(delta):
	if productivity_bar.value < Global.productivity:
		productivity_bar.value += delta * bar_speed
	if energy_bar.value < Global.energy:
		energy_bar.value += delta * bar_speed
	if sanity_bar.value < Global.sanity:
		sanity_bar.value += delta * bar_speed

func add_productivity(value):
	if Global.productivity + value <= 100:
		Global.productivity += value
	else:
		Global.productivity = 100

func add_sanity(value):
	if Global.sanity + value <= 100:
		Global.sanity += value
	else:
		Global.sanity = 100

func add_energy(value):
	if Global.energy + value <= 100:
		Global.energy += value
	else:
		Global.energy = 100

#func update_wheel():
#	productivity_bar.value = Global.productivity
#	sanity_bar.value = Global.sanity
#	energy_bar.value = Global.energy
