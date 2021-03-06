extends Area2D

export var speed := 400

var direction := Vector2.ZERO
var creator : Node2D

func _physics_process(delta):
	position += direction * speed * delta
	for body in get_overlapping_bodies():
		if body.is_in_group("tiles") or body.is_in_group("barriers"):
			queue_free()
		elif body.is_in_group("players") and body != creator:
			body.stun()
			queue_free()
		elif body.is_in_group("enemies"):
			body.stun()
			queue_free()
