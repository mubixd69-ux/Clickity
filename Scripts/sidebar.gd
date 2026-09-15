extends Control

var collapsed_width: float = 90
var expanded_width: float = 300
var animation_duration: float = 0.25

var tween: Tween

func _ready() -> void:
	clip_contents = true
	custom_minimum_size.x = collapsed_width
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	
func on_mouse_entered() -> void:
	animate_sidebar(expanded_width)
	
func on_mouse_exited() -> void:
	await get_tree().process_frame
	if not get_global_rect().has_point(get_global_mouse_position()):
		animate_sidebar(collapsed_width)
	
	
func animate_sidebar(target_width: float) -> void:
	if tween and tween.is_valid():
		tween.kill()
		
	tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "custom_minimum_size:x", target_width, animation_duration)
	


func _on_button_pressed() -> void:
	print("Bought")
