extends Node2D


const DIG_DURATION = 0.5

var value := 0
var random_orientation := true

var _digging := false
var _progress := 0.0

func _ready():
	if random_orientation:
		$Sprite.flip_h = randf() < 0.5
		$Sprite.flip_v = randf() < 0.5

	# Use a different instance per each
	$Sprite.material = $Sprite.material.duplicate()


func dig():
	$CollisionShape2D.disabled = true
	$DigParticles.emitting = true
	
	# Play the sfx with some variation in pitch
	$DigSound.pitch_scale = rand_range(1.0, 1.5)
	$DigSound.play()
	
	_digging = true


func _on_Area2D_body_entered(body:KinematicBody2D):
	if body.is_in_group("players"):
		queue_free()
	else:
		print("Unexpected body in dirt: " + str(body))


func _process(delta):
	if not _digging:
		return
	
	_progress = min(_progress+delta, DIG_DURATION)
	var percent := _progress / DIG_DURATION
	$Sprite.material.set_shader_param("burn_position", percent)
	
	if _progress == DIG_DURATION:
		queue_free()
