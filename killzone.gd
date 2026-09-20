extends Area2D
@onready var sound = $AudioStreamPlayer2D2
@onready var colission = $CollisionShape2D
var is_dying: bool = false

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("player") and not is_dying:
		is_dying = true
		
		GlobalManager.clicks -= GlobalManager.clicks / 5
		
		Sidetransition.anim_player.speed_scale = 2.5
		
		Sidetransition.change_scene("res://Scenes/main.tscn")
		
		sound.play()
		
		await sound.finished
		get_tree().paused = true
		colission.set_deferred("disabled", true)
		
 		
