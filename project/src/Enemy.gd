extends KinematicBody2D

signal died

var speed := 200

var _direction := Vector2(1,0)
var _stunned := false
var _dead := false

onready var _sprite := $AnimatedSprite
onready var _stun_timer := $StunTimer
onready var _burst_particles := $BurstParticles


func _physics_process(delta):
	if not _stunned:
		var collision := move_and_collide(_direction * speed * delta)
		if collision != null:
			if collision.collider.is_in_group("tiles") or collision.collider.is_in_group("barriers"):
				_direction *= -1
			elif collision.collider.is_in_group("players"):
				collision.collider.damage()


func is_stunned() -> bool:
	return _stunned


func stun():
	_stunned = true
	_sprite.playing = false
	_sprite.frame = 0
	
	# If it was previously stunned, add stun length to it
	if _stun_timer.time_left >= 0:
		_stun_timer.start()
	else:
		_stun_timer.time_left = _stun_timer.wait_time
		


func damage():
	_dead = true
	_burst_particles.emitting = true
	$CollisionShape2D.disabled = true
	_sprite.visible = false
	emit_signal("died")
	yield(get_tree().create_timer(1), "timeout")
	queue_free()


func is_dead()->bool:
	return _dead


func _on_StunTimer_timeout():
	_stunned = false
	_sprite.playing = true
	update()


func set_direction(direction:Vector2):
	_direction = direction
