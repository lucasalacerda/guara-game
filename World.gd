extends Node2D

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]
const Player = preload("res://Player/Player.tscn")
const Exit = preload("res://World/ExitDoor.tscn")
const RemoteCamera = preload("res://Utils/RemoteCameraPlayer.tscn")
var borders = Rect2(1, 1, 31, 21)

onready var tileMap = $CliffMetalFloor
var count = 0

func _ready():
#
#	for n in tileMap.get_used_cells():
#		tileMap.set_cellv(n, -1)
	count += 1
	print(count)
	randomize()
	generate_level()


	
#	print(get_tree().get_root().find_node("Camera2D", true, false).current)
#	print(get_tree().get_root().find_node("YSort", true, false).sort_enabled)
#	print(get_tree().get_root().find_node("Player", true, false).get_parent().name)
#	print(get_tree().get_root().find_node("RemoteTransform2D", true, false).remote_path)
	
#	tileMap.update_bitmask_region(borders.position, borders.end)

func render_player(remoteTransform2D, node, pos):
	var player = Player.instance()
	player.add_child(remoteTransform2D)
	remoteTransform2D.set_remote_node(NodePath(node))
	player.position = pos*16

	return player


func generate_level():
	

	var walker = Walker.new(Vector2(19, 11), borders)
	var map = walker.walk(800)
	
	var remoteTransform2D = RemoteCamera.instance()

	var player_cam_node = get_tree().get_root().find_node("Camera2D",true,false)
	var ysort_node = get_tree().get_root().find_node("YSort",true,false)
	var player = render_player(remoteTransform2D, player_cam_node.get_path(), map.front())

	ysort_node.add_child(player)
	
#	print(player.position)
#	print(map.front())
	
	if(!get_tree().get_root().find_node("Robot", true, false)):
		var exit = Exit.instance()
		add_child(exit)
		exit.position = walker.get_end_room().position*16
		exit.connect("leaving_level", self, "reload_level")
	
	
	
#	for room in map:
#		print(room)
	
	walker.queue_free()
	for location in map:
		tileMap.set_cellv(location, -1)
	tileMap.update_bitmask_region(borders.position, borders.end)
	
func reload_level():
	get_tree().reload_current_scene()
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
		reload_level()
