extends Node2D

const SceneTwo = preload("res://World/Level/Level_2.tscn")
	
func _process(delta):
	connect("leaving_level", self, "next_level")

func next_level():
	print("hoho")
	get_tree().change_scene("res://World/Level/Level_2.tscn")
	
func _on_TransitionScreen_transitioned():
#	get_tree().change_scene("res://World/Level/Level_2.tscn")
	$CurrentScene.add_child(SceneTwo.instance())
	$CurrentScene.get_child(0).queue_free()
#	$CurrentScene.add_child(SceneTwo.instance())
	print("swapped in sceneTwo")
