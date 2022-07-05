class_name Level
extends Node2D

signal no_enemies

var _quantity_enemies setget set_quantity_enemies
var _level_number setget set_level_number

const Player = preload("res://Player/Player.tscn")
const Robot = preload("res://Enemies/Mob/Robot.tscn")

func _init(quantity_enemies, level_number):
	self._quantity_enemies = quantity_enemies
	self._level_number = level_number
	
func set_quantity_enemies(value):
	_quantity_enemies = value
	
func get_quantity_enemies():
	return _quantity_enemies
	
func set_level_number(value):
	_level_number = value
	
func get_level_number():
	return _level_number

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = Player.instance()
	player.position = Vector2(22, 11)*16

func create_enemies():
	pass
	
func create_player():
	pass
	
func are_all_enemies_dead():
	if(get_quantity_enemies() == 0):
		return true
	return false

func _input(event):
	if event.is_action_pressed("ui_accept"):
		print("aaaaaaaa")
		get_tree().reload_current_scene()
