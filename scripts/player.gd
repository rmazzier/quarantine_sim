extends KinematicBody2D

export var max_speed = 600
export var acceleration = 3000
export var deceleration = 3000

var velocity = Vector2.ZERO
var looking_dir = Vector2.DOWN
var can_interact = false

#stats
var sanity
var energy
var productivity

onready var anim = $AnimationPlayer
onready var ray = $RayCast2D
onready var dialog_box = get_tree().get_root().get_node("Scene").find_node("dialogue_box")

func _ready():
	set_process_input(true)
	
func _input(event):
	if can_interact and event.is_action_pressed("ui_accept") and dialog_box.active == false and dialog_box.visible == false:
		var item = ray.get_collider()
		if "dialogue_file_path" in item:
			var json_path = item.dialogue_file_path
			dialog_box.interact(json_path)
		
 
func _physics_process(delta):
		
	var input_vec = Vector2.ZERO
	
	if Global.can_move:
	
		input_vec.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		input_vec.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		input_vec = input_vec.normalized()

	
	if input_vec != Vector2.ZERO:
		velocity = velocity.move_toward(input_vec * max_speed, acceleration * delta)
		looking_dir = input_vec
		#play idle animation based on looking direction
		#print(look_dir_to_str(looking_dir))
		anim.play("run_%s" % look_dir_to_str(looking_dir) )
		
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
		
		anim.play("idle_%s" % look_dir_to_str(looking_dir) )
		
		
	
	var movement_info = move_and_slide(velocity)
	ray.cast_to = looking_dir.normalized() * 70
	
	
	if ray.is_colliding() and ray.get_collider().is_in_group("interagibile"):
		can_interact = true
	else:
		can_interact = false
	
	pass

func look_dir_to_str(vec2):
	if vec2 == Vector2.RIGHT:
		return "right"
	elif vec2 == Vector2.LEFT:
		return "left"
	elif vec2 == Vector2.UP:
		return "up"
	elif vec2 == Vector2.DOWN:
		return "down"
	
	#if input vec is diagonal, take the x component as the looking direction
	elif vec2.x > 0:
		return "right"
	else:
		return "left"
	pass

