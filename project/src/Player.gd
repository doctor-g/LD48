extends KinematicBody2D
tool

export var prefix := "p1_"
export var speed := 220.0 setget _set_speed

var _seconds_per_tile := _compute_seconds_per_tile()

var _moving := false
var _start_location := Vector2.ZERO
var _target_location := Vector2.ZERO
var _accumulated_time := 0.0


func _physics_process(delta):
	if not _moving:
		var input_direction := Vector2.ZERO	
		if Input.is_action_pressed(prefix + "move_left"):
			input_direction.x -= 1
		if Input.is_action_pressed(prefix + "move_right"):
			input_direction.x += 1
		# Give horizontal movement priority over vertical movement.
		if input_direction.x == 0:
			if Input.is_action_pressed(prefix + "move_down"):
				input_direction.y += 1
			if Input.is_action_pressed(prefix + "move_up"):
				input_direction.y -= 1
		
		if input_direction != Vector2.ZERO:
			_start_location = position
			_target_location = position + Game.TILE_SIZE * input_direction
			_moving = true
	
	else:
		_accumulated_time += delta
		var percent := min(_accumulated_time / _seconds_per_tile, 1.0)
		position = _start_location.linear_interpolate(_target_location, percent)
		if percent >= 1.0:
			_moving= false
			_accumulated_time = 0
		
	
func _draw():
	draw_rect(Rect2(0,0, Game.TILE_WIDTH, Game.TILE_HEIGHT), Color.rebeccapurple)


func _set_speed(value:float)->void:
	speed = value
	_seconds_per_tile = _compute_seconds_per_tile()


func _compute_seconds_per_tile()->float:
	return Game.TILE_WIDTH / speed
