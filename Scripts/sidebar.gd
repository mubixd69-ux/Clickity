extends Control

var collapsed_width: float = 90
var expanded_width: float = 400
var animation_duration: float = 0.25

@onready var baguette_label: RichTextLabel = $Upgrades_panel/Baguette_Text
@onready var tea_label: RichTextLabel = %Tea_Text
@onready var espresso_label: RichTextLabel = $Upgrades_panel/Espresso_Text
@onready var matcha_label: RichTextLabel = $Upgrades_panel/Matcha_Text
@onready var rebirth_label: RichTextLabel = $Upgrades_panel/Rebirth_Text
@onready var minigame_label: RichTextLabel = $Upgrades_panel/Minigame_Text

var tween: Tween

func _ready() -> void:
	clip_contents = true
	custom_minimum_size.x = collapsed_width
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	
	if baguette_label:
		baguette_label.visible = false
	if tea_label:
		tea_label.visible = false
	if espresso_label:
		espresso_label.visible = false
	if matcha_label:
		matcha_label.visible = false
	if rebirth_label:
		rebirth_label.visible = false
	if minigame_label:
		minigame_label.visible = false
func on_mouse_entered() -> void:
	animate_sidebar(expanded_width)
	if baguette_label:
		baguette_label.visible = true
	if tea_label:
		tea_label.visible = true
	if espresso_label:
		espresso_label.visible = true
	if matcha_label:
		matcha_label.visible = true
	if rebirth_label:
		rebirth_label.visible = true
	if minigame_label:
		minigame_label.visible = true
		
func on_mouse_exited() -> void:
	await get_tree().process_frame
	if not get_global_rect().has_point(get_global_mouse_position()):
		if baguette_label:
			baguette_label.visible = false
		if tea_label:
			tea_label.visible = false
		if espresso_label:
			espresso_label.visible = false
		if matcha_label:
			matcha_label.visible = false
		if rebirth_label:
			rebirth_label.visible = false
		if minigame_label:
			minigame_label.visible = false
		animate_sidebar(collapsed_width)
	
	
func animate_sidebar(target_width: float) -> void:
	if tween and tween.is_valid():
		tween.kill()
		
	tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "custom_minimum_size:x", target_width, animation_duration)
	


func _on_button_pressed() -> void:
	print("Bought")
	
func update_baguette_ui(cost: float, level: float) -> void:
	if not is_node_ready():
		await ready
	if baguette_label:
		baguette_label.text = "[b]Baguette: More BPC[/b]\n-----------------\nPRICE: " + str(int(cost))
func update_tea_ui(cost: float, level: float) -> void:
	if not is_node_ready():
		await ready
	if tea_label:
		tea_label.text = "[b]Tea: Adds 1 more BPS[/b]\n------------------\nPRICE: " + str(int(cost))
func update_espresso_ui(cost: float, level: float) -> void:
	if not is_node_ready():
		await ready
	if espresso_label:
		espresso_label.text = "[b]Espresso: Adds 5 more BPS[/b]\n----------------------\nPRICE:  " + str(int(cost))
func update_matcha_ui(cost: float, level: float) -> void:
	if not is_node_ready():
		await ready
	if matcha_label:
		matcha_label.text = "[b]Matcha: Adds 10 more BPS[/b]\n----------------------\nPRICE:  " + str(int(cost))
func update_rebirth_ui(cost: float, rebirth_count: int) -> void:
	if not is_node_ready():
		await ready
	if rebirth_label:
		var discount_percent: int = rebirth_count * 10
		rebirth_label.text = "[b]Rebirth (" + str(rebirth_count) + "/10): " + str(discount_percent) + "% discount[/b]\n-------------------------\nPRICE: " + str(int(cost))
func update_minigame_ui(cost: float) -> void:
	if not is_node_ready():
		await ready
	if minigame_label:
		minigame_label.text = "[b]Minigame Win 20%, lose 20%[/b]\n------------------------\nPRICE:  " + str(cost)
