extends KinematicBody2D
tool

var speed := 200
var _direction := Vector2(1,0)

func _draw():
	draw_rect(Rect2(0,0,Game.TILE_WIDTH, Game.TILE_HEIGHT), Color.green)


func _physics_process(delta):
	var collision := move_and_collide(_direction * speed * delta)
	if collision != null:
		if collision.collider.is_in_group("tiles"):
			_direction *= -1
			
