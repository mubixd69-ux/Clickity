extends Sprite2D

@onready var sprite: Sprite2D = $"."
var flash: Tween

func _on_area_2d_mouse_entered() -> void:
	print("1")


func _on_area_2d_mouse_exited() -> void:
	print("2")

func white():
	if flash and flash.is_valid():
		flash.kill()
	sprite.modulate = Color(10, 10, 10)
	flash = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	flash.tween_property(sprite, "modulate", Color(1, 1, 1),0.25)
	
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			print(3)
			white()
