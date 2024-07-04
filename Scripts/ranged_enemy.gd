extends CharacterBody2D

const SPEED = 30
var player = null
var player_is_near := false
var player_is_colliding := false
var hit_cooldown := false
var is_shooting := false

@onready var projectile_scene = load("res://Scenes/arrow.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if player_is_colliding == true and hit_cooldown == false:
		player.cur_hp = player.cur_hp - 1
		hit_cooldown = true
		set_hit_cooldown_timer()
	
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
	var projectile : RigidBody2D = projectile_scene.instantiate()
	projectile.global_position = self.global_position
	projectile.rotation_degrees = $AimToPlayer.rotation_degrees
	get_tree().current_scene.add_child(projectile)
	is_shooting = false


func _on_player_detection_body_entered(body):
	player = body
	player_is_near = true
	$Timer.start()

func _on_player_detection_body_exited(body):
	player_is_near = false
	$Timer.stop()


func _on_hurtbox_body_entered(body):
	player = body
	player_is_colliding = true

func _on_hurtbox_body_exited(body):
	player_is_colliding = false
