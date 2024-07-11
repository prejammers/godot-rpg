extends CharacterBody2D

const SPEED = 30
var player = null
var player_is_near := false
var player_is_colliding := false
var hit_cooldown := false
var is_shooting := false
var player_chase = false
var direction = null

@onready var projectile_scene = load("res://Scenes/enemy_fireball.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if player_is_colliding == true and hit_cooldown == false:
		player.cur_hp = player.cur_hp - 1
		hit_cooldown = true
		set_hit_cooldown_timer()
	
	# Enemy will move only if player is too far
	if player and not player_is_near:
		var target_position = player.position
		direction = (target_position - position).normalized()
		var velocity = direction * SPEED
		move_and_collide(velocity * delta)
		if not $WizardAnimation.is_playing():
			if direction.y > 0: #move down
				#if direction.y * 1 > direction.x * 1:
					$WizardAnimation.play("wizard_down")
			elif direction.y < 0: #move up
					$WizardAnimation.play("wizard_up")  
			if direction.x > 0: #move right
				if direction.x * 1 > direction.y * 1:
					$WizardAnimation.play("wizard_right")
			elif direction.x < 0: #move left
				if direction.x * 1 < direction.y * 1:
					$WizardAnimation.play("wizard_left") 
	
	
	if $Timer.time_left == 0 and player_is_near and not is_shooting:
		is_shooting = true
		$Timer.start()
		shoot_projectile()
		
	
	

func set_hit_cooldown_timer():
	while true:
		await get_tree().create_timer(1.0).timeout
		hit_cooldown = false


func shoot_projectile():
	$AimToPlayer.look_at(player.global_position)
	var projectile : CharacterBody2D = projectile_scene.instantiate()
	projectile.global_position = self.global_position
	projectile.rotation_degrees = $AimToPlayer.rotation_degrees
	get_tree().current_scene.add_child(projectile)
	is_shooting = false


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
