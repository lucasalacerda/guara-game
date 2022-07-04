extends Node2D

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]
const Player = preload("res://Player/Player.tscn")
const Robot = preload("res://Enemies/Mob/Robot.tscn")
const FlyingRobot = preload("res://Enemies/Mob/FlyingRobotOne.tscn")
const Exit = preload("res://World/ExitDoor.tscn")
const RemoteCamera = preload("res://Utils/RemoteCameraPlayer.tscn")

var borders = Rect2(1, 1, 40, 22)
var enemies = []
var stats = StageStats.new()

onready var tileMap = $CliffMetalFloor

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

	var walker = Walker.new(Vector2(20, 11), borders)
	var map = walker.walk(400)
	
	var remoteTransform2D = RemoteCamera.instance()

	var player_cam_node = get_tree().get_root().find_node("Camera2D",true,false)
	var ysort_node = get_tree().get_root().find_node("YSort",true,false)
	render_player(ysort_node, remoteTransform2D, player_cam_node.get_path(), map.front())

	render_robots(ysort_node, 2, map)
#	print(player.position)
#	print(map.front())
	
	var exit = Exit.instance()
	add_child(exit)
	exit.position = walker.get_end_room().position*16
	exit.connect("leaving_level", self, "reload_level")
	
	walker.queue_free()
	for location in map:
		tileMap.set_cellv(location, -1)
	tileMap.update_bitmask_region(borders.position, borders.end)
	
func reload_level():
	get_tree().reload_current_scene()
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
		reload_level()
