extends Node2D
tool


func _draw():
	draw_rect(Rect2(0,0,Game.TILE_WIDTH,Game.TILE_HEIGHT), Color.chocolate)


func _on_Area2D_body_entered(body:KinematicBody2D):
	if body.is_in_group("players"):
		queue_free()
	else:
		print("Unexpected body in dirt: " + str(body))
