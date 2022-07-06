class_name LevelGenerator

extends Node2D

signal no_enemies

var _quantity_enemies = 0 setget set_quantity_enemies
var _level_number = 0 setget set_level_number

const Player = preload("res://Player/Player.tscn")
const Robot = preload("res://Enemies/Mob/Robot.tscn")
const FlyingRobot = preload("res://Enemies/Mob/FlyingRobotOne.tscn")
const Exit = preload("res://World/ExitDoor.tscn")
const RemoteCamera = preload("res://Utils/RemoteCameraPlayer.tscn")

var walker = Walker.new(Vector2(20, 11), borders)
var remoteTransform2D = RemoteCamera.instance()
var stats = PlayerStats

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]
const borders = Rect2(1, 1, 50, 26)

onready var tileMap = $CliffMetalFloor
onready var player = Player.instance()
onready var player_cam_node = get_tree().get_root().find_node("Camera2D", true, false)
onready var ysort_node = get_tree().get_root().find_node("YSort", true, false)

func set_quantity_enemies(value):
	_quantity_enemies = value
	
func get_quantity_enemies():
	return _quantity_enemies
	
func set_level_number(value):
	_level_number = value
	
func get_level_number():
	return _level_number

func _ready():
	player.position = Vector2(25, 13)*16
	stats.connect("no_health", self, "show_end_game")

func render_player(pos):
	var player = Player.instance()
	player.add_child(remoteTransform2D)
	ysort_node.add_child(player)
	remoteTransform2D.set_remote_node(NodePath(player_cam_node.get_path()))
	player.position = pos*16

func render_robots(map):
	for i in range(get_quantity_enemies()):
		var enemy = Robot.instance()
		if(get_level_number() > 2):
			var rand = randi() % 50
			if(rand >= 25):
				enemy = FlyingRobot.instance()
			else:
				enemy = Robot.instance()
		ysort_node.add_child(enemy)
		map.shuffle()
		var position = map.front()*16
		enemy.position = position
	
func next_level():
	get_tree().change_scene(
		"res://World/Level/Level_{level}.tscn".format({
			"level": get_level_number()
		})
	)

func generate_level():
	var map = walker.walk(400)
	
	var player_cam_node = get_tree().get_root().find_node("Camera2D", true, false)
	var ysort_node = get_tree().get_root().find_node("YSort", true, false)

	render_player(map.front())
	render_robots(map)

	for node in ysort_node.get_children():
		if(node.name.match("*Robot*")):
			node.connect("enemy_died", self, "enemy_died", [walker])

	generate_tilemap(map)
	
func generate_tilemap(map):
	for location in map:
		tileMap.set_cellv(location, -1)
	tileMap.update_bitmask_region(borders.position, borders.end)
	
func show_door(walker):
	var exit = Exit.instance()
	add_child(exit)
	exit.position = walker.get_end_room().position*16
	exit.connect("leaving_level", self, "next_level")

func enemy_died(walker):
	set_quantity_enemies(get_quantity_enemies()-1)
	if(get_quantity_enemies() == 0):
		show_door(walker)
	
func show_end_game():
	print("ACABOU! VALEU")
