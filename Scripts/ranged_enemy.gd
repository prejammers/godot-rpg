extends CharacterBody2D

const SPEED = 30
var player = null
var player_is_near := false
var player_is_colliding := false
var hit_cooldown := false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if player_is_colliding == true and hit_cooldown == false:
		player.cur_hp = player.cur_hp - 1
		hit_cooldown = true
		start_timer()


func start_timer():
	while true:
		await get_tree().create_timer(1.0).timeout
		hit_cooldown = false


func _on_player_detection_body_entered(body):
	player = body
	player_is_near = true

func _on_player_detection_body_exited(body):
	player_is_near = false


func _on_hurtbox_body_entered(body):
	player = body
	player_is_colliding = true

func _on_hurtbox_body_exited(body):
	player_is_colliding = false
