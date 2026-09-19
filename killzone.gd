extends Area2D
@onready var sound = $AudioStreamPlayer2D2

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("player"):
		$AudioStreamPlayer2D.play()
