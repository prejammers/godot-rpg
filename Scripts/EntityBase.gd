extends CharacterBody2D

@export var hp_max: int = 100: set = set_hp_max
@export var hp: int = hp_max: get = get_hp, set = set_hp
@export var defense: int = 0

@export var SPEED: int = 75

@onready var collShape = $CollisionShape2D


func _physics_process(delta):
	move()

func move():
	pass

func die():
	queue_free()


func _on_hurtbox_area_entered(hitbox):
	var base_damage = hitbox.damage
	self.hp -= base_damage
	print(hitbox.get_parent().name + "'s hitbox touched " + name + "'s hurtbox and dealt " +str(base_damage))
