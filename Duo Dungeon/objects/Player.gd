# Modified from a great script from Rungeon's channel
# https://www.youtube.com/watch?v=zj7cZtSPiFM
extends KinematicBody2D
class_name Player

export(int) var PLAYER_NUMBER = 1

export var gravity = 1000
export var acceleration = 800
export var deacceleration = 800
export var friction = 450
export var current_friction = 500
export var max_horizontal_speed = 130
export var max_fall_speed = 300
export var jump_height = -300
export var double_jump_height = 0 #-200 Disabled for now
export var squash_speed = 0.15

export var INPUT_LEFT = "move_left"
export var INPUT_RIGHT = "move_right"
export var INPUT_UP = "move_up"
export var INPUT_DOWN = "move_down"
export var INPUT_JUMP = "jump"


var vSpeed = 0
var hSpeed = 0

var touching_ground : bool = false # check if we're touching the ground
var touching_wall : bool = false # check if we're touching wall
var is_jumping : bool = false # check are we currently jumping
var is_double_jumping : bool = false # check are we currently double jumping
var air_jump_pressed : bool = false # check if we've pressed jump just before we land
var coyote_time : bool = false #check if we can just JUST after we leave platform 
var can_double_jump : bool = false # check if we can double jump

var motion = Vector2.ZERO
var UP : Vector2 = Vector2(0,-1)

onready var ani = $AnimatedSprite
onready var ray_ground_left = $raycast_container/ray_ground_left
onready var ray_ground_right = $raycast_container/ray_ground_right
onready var ray_wall_left = $raycast_container/ray_wall_left
onready var ray_wall_right = $raycast_container/ray_wall_right

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	#check if we're grounded
	check_ground_logic()
	#check if we're moving/jumping/sliding etc
	if Global.current_player == PLAYER_NUMBER:
		handle_input(delta)
	else:
		zero_input(delta)
	#apply the phsyics once we're done with the previous steps
	do_physics(delta)
	pass
	
func check_ground_logic():
	# check for coyote time ( have we just left platform?)
	var ray_ground_colliding = ray_ground_left.is_colliding() || ray_ground_right.is_colliding()
	if(touching_ground and !ray_ground_colliding):
		touching_ground = false
		coyote_time = true
		yield(get_tree().create_timer(0.2),"timeout") # we pause here for 200 milliseoncds
		coyote_time = false
	#check the m oment we touch ground for first time
	if(!touching_ground and ray_ground_colliding):
		ani.scale = Vector2(1.2,0.8)
	#Set if if we're touching ground or note
	touching_ground = ray_ground_colliding
	if(touching_ground):
		is_jumping = false
		can_double_jump = true
		motion.y = 0
		vSpeed = 0
	pass

func handle_input(var delta):
	handle_movement(delta)
	handle_jumping(delta)
	pass

func zero_input(var delta):
	hSpeed = 0
	pass

func handle_jumping(var _delta):
	if(coyote_time and Input.is_action_just_pressed(INPUT_JUMP)):
		vSpeed = jump_height
		is_jumping = true
		can_double_jump = true
	
	if(touching_ground):
		if((Input.is_action_just_pressed(INPUT_JUMP) or air_jump_pressed) and !is_jumping):
			vSpeed = jump_height
			is_jumping = true
			touching_ground = false
			ani.scale = Vector2(0.5,1.2)
	else:
		#Do variable jump logic
		if(vSpeed < 0 and !Input.is_action_pressed(INPUT_JUMP) and !is_double_jumping):
			vSpeed = max(vSpeed,jump_height / 2)
		if(can_double_jump and Input.is_action_just_pressed(INPUT_JUMP) and !coyote_time):
			vSpeed = double_jump_height
			# ani.play("DOUBLEJUMP")
			is_double_jumping = true
			can_double_jump = false
		#Do some animation logic on the jump
		if(!is_double_jumping and vSpeed <0):
			# ani.play("JUMPUP")
			pass
		elif(!is_double_jumping and vSpeed > 0):
			# ani.play("JUMPDOWN")
			pass
		elif(is_double_jumping and ani.frame == 3):
			is_double_jumping = false
		#check if we're pressing jump just before we land on a platform
		if(Input.is_action_just_pressed(INPUT_JUMP)):
			air_jump_pressed = true
			yield(get_tree().create_timer(0.2),"timeout")
			air_jump_pressed = false
	pass
	
func handle_movement(var delta):
	#check if we're touching wall
	touching_wall = ray_wall_right.is_colliding() || ray_wall_left.is_colliding()
	if(touching_wall):
		hSpeed = 0

	#controller right/keyboard right
	if(Input.get_joy_axis(0,0) > 0.3 or Input.is_action_pressed(INPUT_RIGHT)):
		if(hSpeed <-100):
			hSpeed += (deacceleration * delta)
			if(touching_ground):
				# ani.play("TURN")
				pass
		elif(hSpeed < max_horizontal_speed):
			hSpeed += (acceleration * delta)
			ani.flip_h = false
			if(touching_ground):
				# ani.play("RUN")
				pass
		else:
			if(touching_ground):
				# ani.play("RUN")
				pass
	elif(Input.get_joy_axis(0,0) < -0.3 or Input.is_action_pressed(INPUT_LEFT)):
		if(hSpeed > 100):
			hSpeed -= (deacceleration * delta)
			if(touching_ground):
				# ani.play("TURN")
				pass
		elif(hSpeed > -max_horizontal_speed):
			hSpeed -= (acceleration * delta)
			ani.flip_h = true
			if(touching_ground):
				# ani.play("RUN")
				pass
		else:
			if(touching_ground):
				# ani.play("RUN")
				pass
	else:
		if(touching_ground):
			# ani.play("IDLE")
			pass
		hSpeed -= min(abs(hSpeed),current_friction * delta) * sign(hSpeed)
	
	pass
	
func do_physics(var delta):
	if(is_on_ceiling()):
		motion.y = 10
		vSpeed = 10
	
	vSpeed += (gravity * delta) # apply gravity downwards
	
	vSpeed = min(vSpeed,max_fall_speed) # limit how fast we can fall
	
	#update our motion vector
	motion.y = vSpeed
	motion.x = hSpeed
	
	#apply our motion vectgor to move and slide
	motion = move_and_slide(motion,UP)
	
	#lerp out squash/squeeze scale
	apply_squash_squeeze()
	pass
	
func apply_squash_squeeze():
	ani.scale.x = lerp(ani.scale.x,1,squash_speed)
	ani.scale.y = lerp(ani.scale.y,1,squash_speed)
