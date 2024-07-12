extends CharacterBody2D

## Combat variables
var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var max_hp = 10
var cur_hp = 10
var player_alive = true

const FireBall = preload("res://Scenes/Fireball.tscn")

var current_dir = "none"
const SPEED = 150

var shoot_cooldown: bool = false


func _ready():
	$PlayerAnimation.play("idle_down")
	
func _process(delta):
	pass
	
func _physics_process(delta):
	player_movement(delta)
	get_input()
	move_and_slide()
	enemy_attack()
	
	if cur_hp <= 0:
		player_alive = false #add whatever death needs to be added (respawn, back to menu, etc.)
		cur_hp = 0
		print("Player died")
	
func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * SPEED

func start_timer():
	while true:
		await get_tree().create_timer(1.0).timeout
		shoot_cooldown = false
		
func Shoot():
	if not shoot_cooldown:
		shoot_cooldown = true
		var fireball = FireBall.instantiate()
		get_parent().add_child(fireball)
		fireball.global_transform = $Aim.global_transform
		start_timer()
		
	
func player_movement(delta):
	if Input.is_action_pressed("fire") and shoot_cooldown == false:
		Shoot()
		
	if Input.is_action_pressed("alt_fire"):
		pass
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
	
	if velocity != Vector2.ZERO and not $Footsteps.is_playing():
		footsteps_sound()
		
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

func _on_player_combatbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = true

func _on_player_combatbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = false
		
func _on_player_combatbox_area_entered(area):
	if area.has_method("arrow"):
		enemy_in_attack_range = true
		
func _on_player_combatbox_area_exited(area):
	if area.has_method("arrow"):
		#how to do damage on contact?
		enemy_in_attack_range = false
		
func enemy_attack():
	if enemy_in_attack_range and enemy_attack_cooldown == true:
		cur_hp -= 2
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		$DamageSound.play()
		print("Player's health is %s" % [str(cur_hp)])
		



func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true


<<<<<<< HEAD
func footsteps_sound():
	var index = str(randi() % 3 + 1)
	$Footsteps.stream = load("res://Audio/sound_effects/player_footstep" + index + ".wav")
	$Footsteps.pitch_scale = randf_range(0.95, 1.1)
	$Footsteps.play()


=======



>>>>>>> main

