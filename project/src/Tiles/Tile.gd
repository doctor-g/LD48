extends Node2D
tool

var value := 0

var _color := Color.chocolate


func _draw():
	draw_rect(Rect2(0,0,Game.TILE_WIDTH,Game.TILE_HEIGHT), _color)


func _on_Area2D_body_entered(body:KinematicBody2D):
	if body.is_in_group("players"):
		queue_free()
	else:
		print("Unexpected body in dirt: " + str(body))
