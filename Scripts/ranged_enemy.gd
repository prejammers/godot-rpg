extends CharacterBody2D

var SPEED = 30
var health = 15
var player = null
var player_is_near := false
var player_is_colliding := false
var hit_cooldown := false
var is_shooting := false
var player_chase = false
var direction = null
var dead = false
@onready var healthBar = $EntityHealthBar
@onready var death_sound = $Explosion 
@onready var projectile_scene = load("res://Scenes/enemy_fireball.tscn")
var exp_gem = preload("res://Objects/experience_gem.tscn")
@onready var loot_base = get_tree().get_first_node_in_group("loot")
@export var experience = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if $Timer.time_left == 0 and player_is_near and not is_shooting:
		is_shooting = true
		$Timer.start()
		shoot_projectile()
	
	# Enemy will move only if player is too far
	if player and not player_is_near:
		var target_position = global_position.direction_to(player.global_position) #player.position
		var direction = global_position.direction_to(player.global_position)
		var velocity = direction * SPEED
		move_and_collide(velocity * delta)
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

func _on_hurtbox_area_entered(area):
	var damage
	if area.has_method("fireball_deal_damage"):
		damage = 5
		take_damage(damage)
		healthBar.value = health
	pass # Replace with function body.

func take_damage(damage):
	
	health = health - damage
	modulate = Color.DARK_RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	if health <= 0 and !dead:
		death()
		
func death():
	dead = true
	player_chase = false
	SPEED = 0
	#var tween = create_tween()
	death_sound.play()
	get_node("CollisionShape2D").disabled = true 
	#$CPUParticles2D.emitting = false
	$WizardAnimation.play("death_animation")
	player_chase = false
	var new_gem = exp_gem.instantiate()
	new_gem.global_position = global_position
	new_gem.experience = experience
	loot_base.call_deferred("add_child",new_gem)
	#tween.tween_property($Sprite2D, "scale", Vector2(3,3), 1.5)
	await get_tree().create_timer(.7).timeout
	queue_free()


