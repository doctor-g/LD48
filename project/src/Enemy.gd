extends KinematicBody2D
tool

signal died

var speed := 200

var _direction := Vector2(1,0)
var _stunned := false
var _dead := false

var _color := Color.green

onready var _stun_timer := $StunTimer

func _draw():
	draw_rect(Rect2(0,0,Game.TILE_WIDTH, Game.TILE_HEIGHT), _color)


func _physics_process(delta):
	if not _stunned:
		var collision := move_and_collide(_direction * speed * delta)
		if collision != null:
			if collision.collider.is_in_group("tiles") or collision.collider.is_in_group("barriers"):
				_direction *= -1
			elif collision.collider.is_in_group("players"):
				collision.collider.damage()


func is_stunned() -> bool:
	return _stunned


func stun():
	_stunned = true
	_color = Color.bisque
	update() # Force draw to be called
	
	# If it was previously stunned, add stun length to it
	if _stun_timer.time_left >= 0:
		_stun_timer.start()
	else:
		_stun_timer.time_left = _stun_timer.wait_time
		


func damage():
	_dead = true
	emit_signal("died")
	queue_free()


func is_dead()->bool:
	return _dead


func _on_StunTimer_timeout():
	_stunned = false
	_color = Color.green
	update()


func set_direction(direction:Vector2):
	_direction = direction
