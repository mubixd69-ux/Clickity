extends CanvasLayer

@onready var  color_rect = $ColorRect
@onready var anim_player = $AnimationPlayer

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	color_rect.modulate.a = 0.0
	
func change_scene(target_scene_path: String) -> void:
	anim_player.play("fade_out")
	await anim_player.animation_finished
	
	get_tree().change_scene_to_file(target_scene_path)
	get_tree().paused = false
	
	anim_player.play("fade_back")
	await  anim_player.animation_finished
