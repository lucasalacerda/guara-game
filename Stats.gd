extends Node

export(int) var max_health = 2
onready var health = max_health setget set_health

signal no_health

func set_health(value):
	health = value
	if health <= 0:
		emit_signal("no_health")

func _on_Stats_no_health():
	pass # Replace with function body.
