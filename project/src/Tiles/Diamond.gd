extends Area2D


func _on_Diamond_body_entered(body):
	if body.is_in_group("players"):
		Game.add_points(body.index, 200)
		queue_free()
