extends CharacterBody2D

const SPEED = 40
var health = 10
var player_chase = false
var player = null
var player_colliding: bool = false
var hit_cooldown:bool = false
var dead = false
var direction = null
@onready var death_sound = $Explosion 



# Called when the node enters the scene tree for the first time.
func _ready():
	$CPUParticles2D.emitting = true
	modulate = Color.WHITE
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#if health <= 0:
		#queue_free()
	#if player_colliding == true and hit_cooldown == false:
		#player.cur_hp = player.cur_hp - 1
		#print(player.cur_hp)
		#hit_cooldown = true
		#start_timer()
		
	if player_chase:
		var target_position = player.position
		direction = (target_position - position).normalized()
		var velocity = direction * SPEED
		move_and_collide(velocity * delta)
		#print(direction)
		if direction.y > 0: #move down
			#if direction.y * 1 > direction.x * 1:
				$SkeletonAnimation.play("skeleton_walk_down")
		elif direction.y < 0: #move up
				$SkeletonAnimation.play("skeleton_walk_up")  
		if direction.x > 0: #move right
			if direction.x * 1 > direction.y * 1:
				$SkeletonAnimation.play("skeleton_walk_right")
		elif direction.x < 0: #move left
			if direction.x * 1 < direction.y * 1:
				$SkeletonAnimation.play("skeleton_walk_left") 



func start_timer():
	while true:
		await get_tree().create_timer(1.0).timeout
		hit_cooldown = false
		
func _on_player_detection_body_entered(body):
	player = body
	player_chase = true
func _on_player_detection_body_exited(body):
	player = body
	player_chase = false
	
	
func _on_player_collision_body_entered(body):
	player = body
	player_colliding = true
		
	
func _on_player_collision_body_exited(body):
	player = body
	player_colliding = false
	
func enemy():
	pass

#func AnimationLoop():
	#animation = anim_mode + "_" + anim_direction
	#get_node ("AnimationPlayer").play(animation)

#func _on_enemy_combatbox_body_entered(body):
	#if body.has_method("fireball"):
		#$SkeletonAnimation.play("death_explosion") 
		#queue_free()
		##health -= 3.5
		#print(health)
		#pass # Replace with function body.


func _on_enemy_combatbox_area_entered(area):
	var damage
	if area.has_method("fireball_deal_damage"):
		damage = 5
		take_damage(damage)
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
	var SPEED = 0
	var tween = create_tween()
	death_sound.play()
	get_node("CollisionShape2D").disabled = true 
	$CPUParticles2D.emitting = false
	$SkeletonAnimation.play("death_animation")
	player_chase = false
	tween.tween_property($Sprite2D, "scale", Vector2(3,3), 1.5)
	await get_tree().create_timer(2).timeout
	queue_free()
