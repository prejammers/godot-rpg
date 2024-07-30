extends Node2D

var speed = 300
var hit = false
@onready var fireshoot = $Fireball_shoot
@onready var firehit = $Fireball_hit
@export var firedamage = 1
func _physics_process(delta):
	if hit == false:
		global_position += transform.x * speed * delta

func _on_FireBall_area_entered(area):
	print("fireball area entered")
	if area.has_method("enemy"):
		hit = true
		speed = 0
		$AnimatedSprite2D.play("Hit")
		#get_tree().call_group("Enemy","enemy_combatbox")
		#area.get_parent().health -= 5
		#print(area.get_parent().health, "skele health")
#_on_FireBall_area_entered

func _on_animatedSprite_animation_finished():
	if $AnimatedSprite2D.animation == "Hit":
		speed = 0
		queue_free()

func _ready():
	$AnimatedSprite2D.play("Travel")
	fireshoot.play()
	print("fireball spawned")

func _on_body_entered(body):
	if body.name == "Player":
		pass
	else: 
		speed = 0
		$AnimatedSprite2D.play("Hit")
		firehit.play()
		await get_tree().create_timer(1).timeout
		queue_free()
		
		
func fireball_deal_damage():
	pass

#
#func _on_area_entered(area):
	#queue_free()
	#pass # Replace with function body.
