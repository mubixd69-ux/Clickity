extends Area2D

var is_triggered = false


func _on_body_entered(body: Node2D) -> void:
	is_triggered = true
	GlobalManager.clicks += GlobalManager.clicks / 5
	Sidetransition.change_scene("res://Scenes/main.tscn")
	get_tree().paused = true
	
