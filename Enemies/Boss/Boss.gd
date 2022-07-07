extends KinematicBody2D

class_name Boss

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

signal enemy_died

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 4

enum {
	IDLE,
	WANDER,
	CHASE,
	ATTACK
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = CHASE

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hutbox = $Hurtbox
onready var soft_collision = $SoftCollision
onready var wander_controller = $WanderController
onready var timer = $AnimationPlayer/Timer

func _ready():
	state = pick_random_state([IDLE, WANDER, ATTACK])
	
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
			seek_player()
			
			if wander_controller.get_time_left() == 0:
				update_wander()
		CHASE:
			animation_player.play("chase")
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				sprite.flip_h = velocity.x < 0
		ATTACK:
			attack_state(delta)
			
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)
	
func attack_state(delta):
	velocity = Vector2.ZERO
	animation_player.play("attack")

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wander_controller.start_wander_timer(rand_range(1, 3))
	
func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func seek_player():
	animation_player.play("chase")
	if playerDetectionZone.can_see_player():
		state = ATTACK

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 100
	hutbox.create_hit_effect()

func _on_Stats_no_health():
	queue_free()
	emit_signal("enemy_died")
	var enemy_death_effect = EnemyDeathEffect.instance()
	get_parent().add_child(enemy_death_effect)
	enemy_death_effect.global_position = global_position

func attack_animation_finished():
	state = CHASE
	timer.start(rand_range(0.4, 2))

func _on_Timer_timeout():
	state = ATTACK
