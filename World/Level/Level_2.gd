extends LevelGenerator

func _ready():
	var current_scene = get_tree().current_scene.name
	
	set_quantity_enemies(4)
	set_level_number(int(current_scene) + 1)
	
	generate_level()
