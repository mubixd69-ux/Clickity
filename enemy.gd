extends Node2D

const speed = 60
var direction = 1

func _process(delta):
	
	if $"ray cast right".is_colliding():
		direction = -1
		$AnimatedSprite2D.flip_h = true
	if $"ray cast left".is_colliding():
		direction = 1
		$AnimatedSprite2D.flip_h = false
	position.x += direction * speed * delta
