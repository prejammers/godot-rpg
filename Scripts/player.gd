extends CharacterBody2D

## Combat variables
var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var max_hp = 10
var cur_hp = 10
var player_alive = true
@onready var healthBar = $PlayerHealthBar
@onready var death_sound = $Explosion 
const FireBall = preload("res://Scenes/Fireball.tscn")
const IceWall = preload("res://Scenes/IceWall.tscn")
var current_dir = "none"
var SPEED = 100

var experience = 0
var experience_level = 1
var collected_experience = 0

#GUI
@onready var expBar = get_node("GUILayer/GUI/ExperienceBar") 
@onready var lblLevel = get_node("GUILayer/GUI/ExperienceBar/lbl_level")

#var shoot_cooldown: bool = false
var timer = null
var shoot_delay = .5
var shoot_cooldown = true

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit() #exits the game when pressing escape

func _ready():
	#create timer for shoot delay
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(shoot_delay)
	timer.connect("timeout", Callable(self, "on_timeout_complete"))
	add_child(timer)
	$PlayerAnimation.play("idle_down")
	set_expbar(experience, calculate_experiencecap())

#on timer's timeout complete
func on_timeout_complete():
	shoot_cooldown = true
func _process(delta):
	pass
	
func _physics_process(delta):
	player_movement(delta)
	get_input()
	move_and_slide()
	enemy_attack()
	#
	#if cur_hp <= 0:
		##player_alive = false #add whatever death needs to be added (respawn, back to menu, etc.)
		#cur_hp = 0
		##var shoot_cooldown = true
	if cur_hp <= 0 and player_alive:
		death()
func death():
	SPEED = 0
	player_alive = false
	death_sound.play()
	#$PlayerAnimation.play("death_animation")
	play_anim(0)
	await get_tree().create_timer(3).timeout
	get_tree().reload_current_scene()
	print("Player died")
	
func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * SPEED

#func start_timer():
	#while true:
		#await get_tree().create_timer(1.0).timeout
		#shoot_cooldown = false
		
#func Shoot():
	#if not shoot_cooldown:
		#shoot_cooldown = true
		#var fireball = FireBall.instantiate()
		#get_parent().add_child(fireball)
		#fireball.global_transform = $Aim.global_transform
		##start_timer()
		#
#func ice_Wall():
	#if not shoot_cooldown:
		#shoot_cooldown = true
		#var icewall = IceWall.instantiate()
		#get_parent().add_child(icewall)
		#icewall.position = $Aim.get_global_mouse_position()
		#start_timer()
		
func player_movement(delta):
	if Input.is_action_pressed("fire") and shoot_cooldown:
		#Shoot()
		var fireball = FireBall.instantiate()
		get_parent().add_child(fireball)
		fireball.global_transform = $Aim.global_transform
		# Disable shooting until timer's cooldown is complete
		shoot_cooldown = false
		#start timer
		timer.start()
		#$attack_cooldown/label_value.set_text(str(timer.get_time_left()))
		
	if Input.is_action_pressed("IceWall") and shoot_cooldown:
		#var IceWall = IceWall.instance()
		#ice_Wall()
		# Disable shooting until timer's cooldown is complete
		shoot_cooldown = false
		var icewall = IceWall.instantiate()
		get_parent().add_child(icewall)
		icewall.position = $Aim.get_global_mouse_position()
		#start timer
		timer.start()
		
	if Input.is_action_pressed("alt_fire"):
		pass
	if Input.is_action_pressed("right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = SPEED
		velocity.y = 0
		$ParticlesMove.emitting = true
		$ParticlesMove.position.x = -5
		$ParticlesMove.position.y = 0
	elif Input.is_action_pressed("left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -SPEED
		velocity.y = 0
		$ParticlesMove.emitting = true
		$ParticlesMove.position.x = 5
		$ParticlesMove.position.y = 0
	elif Input.is_action_pressed("down"):
		current_dir = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = SPEED
		$ParticlesMove.emitting = true
		$ParticlesMove.position.x = 2
		$ParticlesMove.position.y = -5
	elif Input.is_action_pressed("up"):
		current_dir = "up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -SPEED
		$ParticlesMove.emitting = true 
		$ParticlesMove.position.x = 2
		$ParticlesMove.position.y = 5
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
		$ParticlesMove.emitting = false
		
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
	elif player_alive == false and movement == 0:
		$PlayerAnimation.play("death_animation")
		$ParticlesMove.emitting = false

func player():
	pass

func _on_player_combatbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = true

func _on_player_combatbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = false
		
func _on_player_combatbox_area_entered(area):
	if area.has_method("arrow") == true:
		cur_hp -= 2
		healthBar.value = cur_hp
		$attack_cooldown.start()
		print("Player's health is %s" % [str(cur_hp)])
	#if area.is_in_group("fireball"):
		#pass
		
func _on_player_combatbox_area_exited(area):
	if area.has_method("arrow"):
		#how to do damage on contact?
		enemy_in_attack_range = false
		
func enemy_attack():
	if enemy_in_attack_range and enemy_attack_cooldown == true:
		cur_hp -= 2
		healthBar.value = cur_hp
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print("Player's health is %s" % [str(cur_hp)])
		

func music(delta):
	if $AudioStreamPlayer.playing == false: 
		$AudioStreamPlayer.play = true
		

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true









func _on_grab_area_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self


func _on_collect_area_area_entered(area):
	if area.is_in_group("loot"):
		var gem_exp = area.collect()
		calculate_experience(gem_exp)
		
func calculate_experience(gem_exp):
	var exp_required = calculate_experiencecap()
	collected_experience += gem_exp
	if experience + collected_experience >= exp_required: #level up
		collected_experience -= exp_required - experience
		experience_level += 1
		lblLevel.text = str("Level: ",experience_level) 
		experience = 0
		exp_required = calculate_experiencecap()
		calculate_experience(0)
	else:
		experience += collected_experience
		collected_experience = 0
	
	set_expbar(experience, exp_required)

func calculate_experiencecap():
	var exp_cap = experience_level
	if experience_level < 20: 
		exp_cap = experience_level*5
	elif experience_level < 40:
		exp_cap + 95 * (experience_level - 19)*8
	else:
		exp_cap = 255 + (experience_level - 39)*12
	return exp_cap
func set_expbar(set_value = 1, set_max_value = 100):
	expBar.value = set_value
	expBar.max_value = set_max_value
func levelup():
	if experience_level == 2:
		shoot_delay - .2
