extends Area2D

var speed = 300

func _ready():
	set_as_top_level(true)
	
func _process(delta):
	position += Vector2.RIGHT.rotated(rotation) * speed * delta
	
func arrow():
	pass

func _on_area_entered(area):
	if area.has_method("fireball_deal_damage") or area.is_in_group("Player") or area.is_in_group("Object"):
		queue_free()
	


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
