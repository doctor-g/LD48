extends KinematicBody2D
tool

var speed := 200
var _direction := Vector2(1,0)
var _stunned := false

var _color := Color.green

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


func damage():
	print("Enemy has died")
	queue_free()
