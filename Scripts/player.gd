extends CharacterBody2D

var current_dir = "none"
const SPEED = 150
var max_hp = 10
var cur_hp = 10


func _ready():
	$PlayerAnimation.play("idle_down")
func _physics_process(delta):
	player_movement(delta)
	get_input()
	move_and_slide()
	
func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * SPEED
	
	
func player_movement(delta):
	
	if Input.is_action_pressed("right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = SPEED
		velocity.y = 0
	elif Input.is_action_pressed("left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -SPEED
		velocity.y = 0
	elif Input.is_action_pressed("down"):
		current_dir = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = SPEED
	elif Input.is_action_pressed("up"):
		current_dir = "up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -SPEED
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
		
func play_anim(movement):
	var dir = current_dir
	var anim = $"Character Sprite"
	
	if dir == "right":
		if movement == 1:
			$PlayerAnimation.play("walk_right")
		elif movement == 0:
			#anim.play("side_idle")
			$PlayerAnimation.play("idle_right")
	if dir == "left":
		if movement == 1:
			$PlayerAnimation.play("walk_left")
			#anim.play("walking")
		elif movement == 0:
			#anim.play("side_idle")
			$PlayerAnimation.play("idle_left")
	if dir == "up":
		if movement == 1:
			$PlayerAnimation.play("walk_up")
			#anim.play("walk_up")
		elif movement == 0:
			$PlayerAnimation.play("idle_up")
			#anim.play("idle_up")
	if dir == "down":
		if movement == 1:
			$PlayerAnimation.play("walk_down")
			#anim.play("walk_down")
		elif movement == 0:
			$PlayerAnimation.play("idle_down")
			#anim.play("idle_down")

func player():
	pass
