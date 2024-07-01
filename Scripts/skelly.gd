extends CharacterBody2D

const SPEED = 40
var player_chase = false
var player = null
var player_colliding: bool = false
var hit_cooldown:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if player_colliding == true and hit_cooldown == false:
		player.cur_hp = player.cur_hp - 1
		print(player.cur_hp)
		hit_cooldown = true
		start_timer()
		
	if player_chase:
		var target_position = player.position
		var direction = (target_position - position).normalized()
		var velocity = direction * SPEED
		move_and_collide(velocity * delta)

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
	


