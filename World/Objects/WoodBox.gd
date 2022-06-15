extends StaticBody2D

const WoodBoxEffect = preload("res://Effects/WoodBoxEffect.tscn")

func create_grass_effect():
	var box_effect = WoodBoxEffect.instance()
	get_parent().add_child(box_effect)
	box_effect.global_position = global_position

func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
