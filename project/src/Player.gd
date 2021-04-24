class_name Player
extends KinematicBody2D

# The player "number", starting with zero.
export var index := 0 setget _set_index
export var speed := 220.0 setget _set_speed

var _seconds_per_tile := _compute_seconds_per_tile()
var _prefix : String = "p1_"
var _moving := false
var _start_location := Vector2.ZERO
var _target_location := Vector2.ZERO
var _accumulated_time := 0.0
var _playable_area := Rect2(0,0,Game.WIDTH * Game.TILE_WIDTH, Game.HEIGHT * Game.TILE_HEIGHT)
var _facing := Vector2.RIGHT

onready var _shot_cooldown_timer := $ShotCooldownTimer

func _physics_process(delta):
	if _can_shoot() and Input.is_action_just_pressed(_prefixed("fire")):
		var projectile : Node2D = preload("res://src/Projectile.tscn").instance()
		projectile.position = position
		projectile.direction = _facing
		get_parent().add_child(projectile)
		_shot_cooldown_timer.start()
		
	
	if not _moving:
		var input_direction := Vector2.ZERO	
		if Input.is_action_pressed(_prefixed("move_left")):
			input_direction.x -= 1
			_facing = Vector2.LEFT
		if Input.is_action_pressed(_prefixed("move_right")):
			input_direction.x += 1
			_facing = Vector2.RIGHT
		# Give horizontal movement priority over vertical movement.
		if input_direction.x == 0:
			if Input.is_action_pressed(_prefixed("move_down")):
				input_direction.y += 1
				_facing = Vector2.DOWN
			if Input.is_action_pressed(_prefixed("move_up")):
				input_direction.y -= 1
				_facing = Vector2.UP
		
		if input_direction != Vector2.ZERO:
			_start_location = position
			_target_location = position + Game.TILE_SIZE * input_direction
			_moving = true
	
	else:
		_accumulated_time += delta
		var percent := min(_accumulated_time / _seconds_per_tile, 1.0)
		var destination = _start_location.linear_interpolate(_target_location, percent)
		
		if not _playable_area.has_point(destination):
			_moving = false
			_accumulated_time = 0
			return
		
		var collision := move_and_collide(destination - position)
		if collision != null:
			# If players run into each other, both are obliterated
			if collision.collider.is_in_group("players"):
				collision.collider.damage()
				damage()
			# If a player runs into an enemy, it is obliterated
			elif collision.collider.is_in_group("enemies"):
				if collision.collider.is_stunned():
					collision.collider.damage()
				else:
					damage()
			# If a player runs into dirt, dig it out
			elif collision.collider.is_in_group("tiles"):
				Game.add_points(index, 5)
				collision.collider.queue_free()
			
		if percent >= 1.0:
			_moving= false
			_accumulated_time = 0


func _can_shoot()->bool:
	return _shot_cooldown_timer.time_left == 0


func _prefixed(event:String)->String:
	return _prefix + event


func _set_index(value:int)->void:
	assert (value>=0)
	index = value
	_prefix = "p%d_" % (index+1)


func _draw():
	draw_rect(Rect2(0,0, Game.TILE_WIDTH, Game.TILE_HEIGHT), Color.rebeccapurple)


func _set_speed(value:float)->void:
	speed = value
	_seconds_per_tile = _compute_seconds_per_tile()


func _compute_seconds_per_tile()->float:
	return Game.TILE_WIDTH / speed


func damage():
	print("Alas, I am dead")
	queue_free()
