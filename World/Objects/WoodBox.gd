extends StaticBody2D

func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()

func create_grass_effect():
	var WoodBoxEffect = load("res://Effects/WoodBoxEffect.tscn")
	var box_effect = WoodBoxEffect.instance()
		
	var world = get_tree().current_scene
	world.add_child(box_effect)
	box_effect.global_position = global_position

