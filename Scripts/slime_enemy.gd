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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if health <= 0:
		queue_free()
		
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
	if area.is_in_group("fireball"):
		health -= 3.5
		print(health)
	pass # Replace with function body.
	
#func AnimationLoop():
	#animation = anim_mode + "_" + anim_direction
	#get_node ("AnimationPlayer").play(animation)

