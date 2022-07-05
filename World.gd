extends Node2D


const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]
const Player = preload("res://Player/Player.tscn")
const Robot = preload("res://Enemies/Mob/Robot.tscn")
const Exit = preload("res://World/ExitDoor.tscn")
const RemoteCamera = preload("res://Utils/RemoteCameraPlayer.tscn")
var borders = Rect2(1, 1, 40, 22)
var quantity_enemies = 2
var level_number = 1
var walker = Walker.new(Vector2(20, 11), borders)
onready var level = Level.new(quantity_enemies, level_number)

onready var tileMap = $Level/CliffMetalFloor

func _ready():
#	for i in get_tree().get_root().get_child(1).get_child(0).get_child(3).get_children():
#		print(i.name)
	generate_level()
	print(level.get_quantity_enemies())


func render_player(ysort_node, remoteTransform2D, node, pos):
	var player = Player.instance()
	player.add_child(remoteTransform2D)
	ysort_node.add_child(player)
	remoteTransform2D.set_remote_node(NodePath(node))
	player.position = pos*16

func render_robots(ysort_node, robots_quantity, map):
	for i in range(robots_quantity):
		var robot = Robot.instance()
		ysort_node.add_child(robot)
		map.shuffle()
		var position = map.front()*16
		robot.position = position

func generate_level():
	
	var map = walker.walk(400)
	
	var remoteTransform2D = RemoteCamera.instance()
	var player_cam_node = get_tree().get_root().find_node("Camera2D", true, false)
	var ysort_node = get_tree().get_root().find_node("YSort", true, false)
	render_player(ysort_node, remoteTransform2D, player_cam_node.get_path(), map.front())

	render_robots(ysort_node, level.get_quantity_enemies(), map)

	for node in get_tree().get_root().get_child(1).get_child(0).get_child(3).get_children():
		if(node.name.match("?RobotOne*") || node.name == "RobotOne"):
			node.connect("enemy_died", self, "enemy_died", [walker])

#	walker.queue_free()
	for location in map:
		tileMap.set_cellv(location, -1)
	tileMap.update_bitmask_region(borders.position, borders.end)

func reload_level():
	print("level number: %s" % level.get_level_number())
	level.set_level_number(level.get_level_number()+1)
	get_tree().reload_current_scene()
	if(level.get_level_number() == 5):
		print("parabéns.")
#		get_tree().change_scene("BOSS")
#
#func _input(event):
#	if event.is_action_pressed("ui_accept"):
#		reload_level()

func show_door(walker):
	print("hihi")
	var exit = Exit.instance()
	add_child(exit)
	exit.position = walker.get_end_room().position*16
	exit.connect("leaving_level", self, "reload_level")

func enemy_died(walker):
	level.set_quantity_enemies(level.get_quantity_enemies()-1)
	print(level.get_quantity_enemies())
	if(level.get_quantity_enemies() == 0):
		show_door(walker)

#func _on_Level_no_enemies(position):
#	var exit = Exit.instance()
#	add_child(exit)
#	exit.position = walker.get_end_room().position*16
#	exit.connect("leaving_level", self, "reload_level")
