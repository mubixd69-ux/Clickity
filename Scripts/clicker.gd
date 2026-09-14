extends Sprite2D

@onready var sprite: Sprite2D = $"."

var bounce: Tween
var flash: Tween
var clicks: int = 0
var base_scale: Vector2

var spawn_radius: float = 240.0

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
	
func spawn_label() -> void:
	var label = Label.new()
	label.text = "+1"
	label.add_theme_font_size_override("font_size", 28)
	
	var random_offset = Vector2.RIGHT.rotated(randf() * TAU) * randf_range(20, spawn_radius)
	label.global_position = global_position + random_offset
	
	get_tree().current_scene.add_child(label)
	
	var tween := label.create_tween().set_parallel(true)
	label.scale = Vector2(0.5, 0.5)
	tween.tween_property(label, "scale", Vector2(1.2, 1.2), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(label, "position:y", label.position.y - 60, 0.6).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "modulate:a", 0.0, 0.6).set_delay(0.1)
	
	tween.chain().tween_callback(label.queue_free)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			clicks += 1
			print(clicks)
			white()
			animate()
			spawn_label()
