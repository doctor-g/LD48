extends Area2D

export var value := 50

func _on_Diamond_body_entered(body):
	if body.is_in_group("players"):
		$PickupSound.play()
		Game.add_points(body.index, value)
		$AnimationPlayer.play("FadeOut")
		$CPUParticles2D.emitting = true
		$CollisionShape2D.set_deferred("disabled", true)
		yield(get_tree().create_timer(1.0), "timeout")
		queue_free()
