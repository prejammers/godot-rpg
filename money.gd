extends Label
var money = 0
var save_path = "user://money"

func save_money():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(money)
	
func load_money():
	if FileAccess.file_exists(save_path):
		print("file found")
		var file = FileAccess.open(save_path, FileAccess.READ)
		money = file.get_var()
	else:
		print("file not found")
		money = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	
	money += 1
	text = str("money ", money)
