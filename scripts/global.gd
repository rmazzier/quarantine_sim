extends Node

#player stats
var sanity
var energy
var productivity

func _ready():
	#prendi le stats dal save file!
	
	#per ora le setto a valori random (da 1 a 100)
	sanity = 60
	energy = 40
	productivity = 50
	
	pass 

