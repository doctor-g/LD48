extends Node2D
tool

var value := 0

func _on_Area2D_body_entered(body:KinematicBody2D):
	if body.is_in_group("players"):
		queue_free()
	else:
		print("Unexpected body in dirt: " + str(body))
