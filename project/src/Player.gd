class_name Player
extends KinematicBody2D

signal died

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
var _stunned := false

var _dead := false # Timing issues can cause death to happen more than once,
				   # so track it here to make sure we don't emit the signal twice.

onready var _sprite := $Sprite
onready var _shot_cooldown_timer := $ShotCooldownTimer
onready var _stun_timer := $StunTimer

func _ready():
	_sprite.frames = load("res://assets/Styles/player_%d_spriteframes.tres" % (index+1))

func _physics_process(delta):
	if _stunned:
		return
	
	if _can_shoot() and Input.is_action_just_pressed(_prefixed("fire")):
		var projectile : Node2D = preload("res://src/Projectile.tscn").instance()
		projectile.position = position + _facing * Game.TILE_WIDTH/2
		projectile.direction = _facing
		projectile.creator = self
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
			_sprite.playing = true
			match _facing:
				Vector2.RIGHT:
					_sprite.flip_h = false
					_sprite.rotation = 0
				Vector2.LEFT:
					_sprite.flip_h = true
					_sprite.rotation = 0
				Vector2.UP:
					_sprite.rotation_degrees = -90
					_sprite.flip_h = false
				Vector2.DOWN:
					_sprite.rotation_degrees = 90
					_sprite.flip_h = false
		else:
			_sprite.playing = false
	
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
					Game.add_points(index, 250)
				else:
					damage()
			# If a player runs into dirt, dig it out
			elif collision.collider.is_in_group("tiles"):
				Game.add_points(index, collision.collider.value)
				collision.collider.dig();
			
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
	_prefix = Game.form_action_prefix(index)


func _set_speed(value:float)->void:
	speed = value
	_seconds_per_tile = _compute_seconds_per_tile()


func _compute_seconds_per_tile()->float:
	return Game.TILE_WIDTH / speed


func damage():
	if not _dead:
		_dead = true
		emit_signal("died")
		queue_free()


func stun():
	_stunned = true
	_stun_timer.start()
	update() # Force draw


func _on_StunTimer_timeout():
	_stunned = false
	update()
