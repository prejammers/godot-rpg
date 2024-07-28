extends Area2D
@onready var iceWall = $IceSound
var hit = false
var speed = 0

func _physics_process(delta):
	if hit == false:
		global_position += transform.x * speed * delta
# Called when the node enters the scene tree for the first time.
func _ready():
	#add_child(iceWall)
	$AnimatedSprite2D.play("Summon")
	iceWall.play()
	print("icewall spawned")
	await get_tree().create_timer(5).timeout
	queue_free()



func fireball_deal_damage():
	pass
