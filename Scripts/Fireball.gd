extends Node2D

var speed = 100
var hit = false

func _physics_process(delta):
	if hit == false:
		global_position += transform.x * speed * delta

func _on_FireBall_area_entered(area):
	print("fireball area entered")
	if area.is_in_group("Enemy"):
		hit = true
		get_node("AnimatedSprite2D").play("Hit")
		area.get_parent().health -= 1
		print(area.get_parent().health, "skele health")


func _on_animatedSprite_animation_finished():
	if get_node("AnimatedSprite").animation == "Hit":
		queue_free()

func _ready():
	print("fireball spawned")
