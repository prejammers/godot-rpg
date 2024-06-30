extends CharacterBody2D

const SPEED = 40
var player_chase = false
var player = null
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_chase:
		position += (player.position - position)/SPEED


func _on_player_detection_body_entered(body):
	player = body
	player_chase = true

func _on_player_detection_body_exited(body):
	player = null
	player_chase = false
