extends CharacterBody2D

var SPEED = 40
var health = 50
var player_chase = true
var player_colliding: bool = false
var hit_cooldown:bool = false
var direction = null
var dead = false
@onready var healthBar = $EntityHealthBar
@onready var death_sound = $Explosion 
@onready var player = get_tree().get_first_node_in_group("Player")
var exp_gem = preload("res://Objects/experience_gem.tscn")
@onready var loot_base = get_tree().get_first_node_in_group("loot")
@export var experience = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
		
	if player_colliding == true and hit_cooldown == false:
		
		
		hit_cooldown = true
		start_timer()
		
	if player_chase:
		var target_position = player.position
		var direction = global_position.direction_to(player.global_position)
		var velocity = direction * SPEED
		move_and_collide(velocity * delta)
		#print(direction)
		if direction.y > 0: #move down
			#if direction.y * 1 > direction.x * 1:
				$SlimeAnimation.play("slime_walk_down")
		elif direction.y < 0: #move up
				$SlimeAnimation.play("slime_walk_up")  
		if direction.x > 0: #move right
			if direction.x * 1 > direction.y * 1:
				$SlimeAnimation.play("slime_walk_right")
		elif direction.x < 0: #move left
			if direction.x * 1 < direction.y * 1:
				$SlimeAnimation.play("slime_walk_left") 



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

func _on_player_collision_2_area_entered(area):
	var damage
	if area.has_method("fireball_deal_damage"):
		damage = 5
		take_damage(damage)
		healthBar.value = health
	pass # Replace with function body.
	
#func AnimationLoop():
	#animation = anim_mode + "_" + anim_direction
	#get_node ("AnimationPlayer").play(animation)

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
	var tween = create_tween()
	death_sound.play()
	get_node("CollisionShape2D").disabled = true 
	$SlimeAnimation.play("death_animation")
	player_chase = false
	tween.tween_property($Sprite2D, "scale", Vector2(5,5), 1.5)
	var new_gem = exp_gem.instantiate()
	new_gem.global_position = global_position
	new_gem.experience = experience
	loot_base.call_deferred("add_child",new_gem)
	await get_tree().create_timer(.7).timeout
	queue_free()
