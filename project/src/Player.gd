extends KinematicBody2D
tool

export var prefix := "p1_"
export var speed := 220

func _physics_process(delta):
	var direction := Vector2.ZERO
	
	if Input.is_action_pressed(prefix + "move_left"):
		direction.x -= 1
	if Input.is_action_pressed(prefix + "move_right"):
		direction.x += 1
	# Give horizontal movement priority over vertical movement.
	if direction.x == 0:
		if Input.is_action_pressed(prefix + "move_down"):
			direction.y += 1
		if Input.is_action_pressed(prefix + "move_up"):
			direction.y -= 1
	
	move_and_collide(direction * speed * delta)
	
	
func _draw():
	draw_rect(Rect2(0,0, Game.TILE_WIDTH, Game.TILE_HEIGHT), Color.rebeccapurple)
