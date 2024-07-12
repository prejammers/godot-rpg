extends CharacterBody2D

const SPEED = 30
var player = null
var player_is_near := false
var player_is_colliding := false
var hit_cooldown := false
var is_shooting := false
var player_chase = false
var direction = null

@onready var projectile_scene = load("res://Scenes/arrow.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if player_is_colliding == true and hit_cooldown == false:
		player.cur_hp = player.cur_hp - 1
		hit_cooldown = true
		set_hit_cooldown_timer()
		
	if player_chase:
		var target_position = player.position
		direction = (target_position - position).normalized()
		var velocity = direction * SPEED
		move_and_collide(velocity * delta)
		print(direction)
		if direction.y > 0: #move down
			#if direction.y * 1 > direction.x * 1:
				$BowAnimation.play("bow_down")
		elif direction.y < 0: #move up
				$BowAnimation.play("bow_up")  
		if direction.x > 0: #move right
			if direction.x * 1 > direction.y * 1:
				$BowAnimation.play("bow_right")
		elif direction.x < 0: #move left
			if direction.x * 1 < direction.y * 1:
				$BowAnimation.play("bow_left") 
	
	if $Timer.time_left == 0 and player_is_near and not is_shooting:
		is_shooting = true
		$Timer.start()
		shoot_projectile()
	
	# Enemy will move only if player is too far
	if player and not player_is_near:
		var target_position = player.position
		var direction = (target_position - self.position).normalized()
		var velocity = direction * SPEED
		move_and_collide(velocity * delta)
		
	
	

func set_hit_cooldown_timer():
	while true:
		await get_tree().create_timer(1.0).timeout
		hit_cooldown = false


func shoot_projectile():
	$AimToPlayer.look_at(player.global_position)
	var projectile : Area2D = projectile_scene.instantiate()
	projectile.global_position = self.global_position
	projectile.rotation_degrees = $AimToPlayer.rotation_degrees
	get_tree().current_scene.add_child(projectile)
<<<<<<< HEAD
	$ShootSound.pitch_scale = 1.25 - (0.002 * global_position.distance_to(player.global_position))
	$ShootSound.play()
	is_shooting = false
	
=======
	is_shooting = false
>>>>>>> main


func _on_player_detection_body_entered(body):
	player = body
	player_is_near = true
	$Timer.start()
	player_chase = true

func _on_player_detection_body_exited(body):
	player_is_near = false
	$Timer.stop()
	player_chase = false


func _on_hurtbox_body_entered(body):
	player = body
	player_is_colliding = true

func _on_hurtbox_body_exited(body):
	player_is_colliding = false
