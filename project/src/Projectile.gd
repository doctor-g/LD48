extends Area2D

export var speed := 400

var direction := Vector2.ZERO

func _physics_process(delta):
	position += direction * speed * delta
	for body in get_overlapping_bodies():
		if body.is_in_group("tiles") or body.is_in_group("barriers"):
			queue_free()


func _draw():
	draw_circle(Vector2(Game.TILE_WIDTH/2.0, Game.TILE_HEIGHT/2.0), Game.TILE_WIDTH/4.0, Color.yellow)
	
