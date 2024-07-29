extends Area2D
@onready var iceWall = $IceSound
@onready var healthBar = $IcewallHealthBar
var hit = false
var speed = 0
var health = 2
var dead = false

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
	$AnimatedSprite2D.play("Destruction")
	await get_tree().create_timer(2).timeout
	queue_free()

func fireball_deal_damage():
	pass


		
func _on_area_entered(area):
	var damage
	if area.has_method("arrow"):
		damage = 1
		take_damage(damage)
		healthBar.value = health
	

func take_damage(damage):
	
	health = health - damage
	modulate = Color.DARK_RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	if health <= 0 and !dead:
		death()
		
func death():
	dead = true
	#var tween = create_tween()
	get_node("icewall_combatbox").disabled = true 
	$AnimatedSprite2D.play("Destruction")
	await get_tree().create_timer(2).timeout
	queue_free()



