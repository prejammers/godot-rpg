extends CharacterBody2D

var current_dir = "none"
const SPEED = 300

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
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("Walking")
		elif movement == 0:
			anim.play("Idle")
			
	
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("Walking")
		elif movement == 0:
			anim.play("Idle")
