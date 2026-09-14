extends Sprite2D

@onready var sprite: Sprite2D = $"."

var bounce: Tween
var flash: Tween
var clicks: int = 0
var base_scale: Vector2

func _ready() -> void:
	base_scale = sprite.scale

func _on_area_2d_mouse_entered() -> void:
	print("1")


func _on_area_2d_mouse_exited() -> void:
	print("2")

func animate() -> void:
	if bounce and bounce.is_valid():
		bounce.kill()
	sprite.scale = base_scale * Vector2(0.85, 0.85)
	bounce = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	bounce.tween_property(sprite, "scale", base_scale, 0.4)
	
	

func white():
	if flash and flash.is_valid():
		flash.kill()
	sprite.modulate = Color(10, 10, 10)
	flash = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	flash.tween_property(sprite, "modulate", Color(1, 1, 1),0.25)
	
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			clicks += 1
			print(clicks)
			white()
			animate()
