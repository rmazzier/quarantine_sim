extends Control

onready var tween = $Tween
onready var productivity_bar = $productivity_bar
onready var sanity_bar = $sanity_bar
onready var energy_bar = $energy_bar
onready var player =  get_tree().get_root().get_node("Scene").find_node("player")
onready var sanity_text = $VBoxContainer/sanity_text
onready var energy_text = $VBoxContainer/energy_text
onready var productivity_text = $VBoxContainer/productivity_text

onready var bar_speed = 20

func _ready():
	init_hud()
	set_process_input(true)
	pass

func init_hud():
	productivity_bar.value = Global.productivity
	sanity_bar.value = Global.sanity
	energy_bar.value = Global.energy
	
	sanity_text.bbcode_text = "Sanity: %s" % Global.sanity
	energy_text.bbcode_text = "Energy: %s" % Global.energy
	productivity_text.bbcode_text = "Productivity: %s" % Global.productivity
	pass

export var anim_duration = 0.5

func update_wheel(anim_dur):
	if productivity_bar.value != Global.productivity:
		tween.interpolate_property(
			productivity_bar, "value", 
			productivity_bar.value, 
			Global.productivity, 
			anim_dur, Tween.TRANS_EXPO, Tween.EASE_OUT)
		productivity_text.bbcode_text = "Productivity: %s" % Global.productivity
		tween.start()
	if sanity_bar.value != Global.sanity:
		tween.interpolate_property(
			sanity_bar, "value", 
			sanity_bar.value, 
			Global.sanity, 
			anim_dur, Tween.TRANS_EXPO, Tween.EASE_OUT)
		sanity_text.bbcode_text = "Sanity: %s" % Global.sanity
		tween.start()
	if energy_bar.value != Global.energy:
		tween.interpolate_property(
			energy_bar, "value", 
			energy_bar.value, 
			Global.energy, 
			anim_dur, Tween.TRANS_EXPO, Tween.EASE_OUT)
		energy_text.bbcode_text = "Energy: %s" % Global.energy
		tween.start()
