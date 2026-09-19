extends Sprite2D

@onready var sprite: Sprite2D = $"."
@onready var score_label: RichTextLabel = $"../HUD/ScoreLabel"
@onready var bpm_label: RichTextLabel = $"../HUD/BPM"
@onready var flash_overlay: ColorRect = $"../CanvasLayer/Flash_Overlay"
@onready var vigenette_overlay: ColorRect = $"../CanvasLayer/Vigenette"
@onready var upgrades_panel = $"../CanvasLayer/Sidebar"

@onready var falling_button3 = $"../Button2"
var t1 = 0.0
var t2 = 0.0

var double_rain_timer = Timer
var bounce: Tween
var flash: Tween
var score: Tween

var clicks: int = 0
var noob_auto_clicker_cost: int = 150
var noob_upgrade_level: float = 0
var pro_auto_clicker_cost: int = 750
var pro_upgrade_level: float = 0
var hacker_auto_clicker_cost: int  = 1500
var hacker_upgrade_level: float = 0
var auto_clickers: int = 0
var falling3 = false
var double_clicks: bool = false
var double_timer : Timer 
var upgrade_cost: float = 10
var upgrade_level : float = 1
var click_power: int = 1
var base_scale: Vector2
var label_base_scale: Vector2 = Vector2.ONE

var spawn_radius: float = 240.0

var timestamp: Array[float] = []
var sample_window: float = 3
var current_sample_window_time: float = 0.0 
var clicks_in_sample_window: float = 0.0
var current_bpm: float = 0.0

func spawn_falling_button2():
	if falling3 or double_clicks:
		return
	falling_button2.visible = true
	falling_button2.position.x = randf_range(0, 1000)
	falling_button2.position.y = -100
	falling = true

func spawn_falling_button():
	falling_button.visible = true
	falling_button.position.x = randf_range(0, 1000)
	falling_button.position.y = -100
	falling = true

func spawn_falling_button3():
	falling_button3.visible = true
	falling_button3.position.x = randf_range(0, 1000)
	falling_button3.position.y = -100
	falling3 = true

func _process(delta: float) -> void:
	if current_sample_window_time <= 0:
		current_sample_window_time = sample_window
		current_bpm = clicks_in_sample_window / sample_window
		clicks_in_sample_window = 0
		update_bpm_ui()
	else:
		current_sample_window_time -= delta
		print(clicks_in_sample_window)
	
	if falling:
		falling_button.position.y += fall_speed * delta
		t1 += delta*5
		falling_button.position.x += sin(t1)*2
	
	if falling3:
		falling_button3.position.y += fall_speed2 * delta
		t2 += delta*5	
		falling_button.position.x += sin(t2)*2

func update_score_ui() -> void:
	if not score_label:
		return
		
		
	score_label.text = "[center][wave amp=30.0 freq=5.0][color=#FFFFFF]" + str(clicks) + " Bread[/color][/wave][/center]"
	
	score_label.pivot_offset = score_label.size / 2.0
	
	if score and score.is_valid():
		score.kill()
		
	score_label.scale = label_base_scale * 1.25
	score = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	score.tween_property(score_label, "scale", label_base_scale, 0.2)
	
func update_bpm_ui() -> void:
	if not bpm_label:
		return
	
	bpm_label.text = "[center][wave amp=30.0 freq=5.0][color=#FFFFFF]" + str(current_bpm).pad_decimals(2) + " BPS[/color]"



func _ready() -> void:
	var auto_timer := Timer.new()
	auto_timer.wait_time = 1.0
	auto_timer.autostart = true
	auto_timer.timeout.connect(auto_click)
	add_child(auto_timer)

	double_rain_timer = Timer.new()
	double_rain_timer.one_shot = true
	double_rain_timer.timeout.connect(spawn_falling_button3)
	add_child(double_rain_timer)

	double_rain_timer.start(randf_range(5.0, 20.0))

	var random_timer := Timer.new()
	random_timer.wait_time = randf_range(0.5, 15.0)
	random_timer.autostart = true
	random_timer.timeout.connect(spawn_falling_button)
	add_child(random_timer)

	double_timer = Timer.new()
	double_timer.wait_time = 7.5
	double_timer.one_shot = true
	double_timer.timeout.connect(_on_double_timer_timeout)
	add_child(double_timer)

	var random_timer2 := Timer.new()
	random_timer2.wait_time = randf_range(0.5, 40.0)
	random_timer2.autostart = true
	random_timer2.timeout.connect(spawn_falling_button2)
	add_child(random_timer2)

	falling_button3.visible = false

	base_scale = sprite.scale
	
	if score_label:
		score_label.pivot_offset = score_label.size / 2.0
		label_base_scale = score_label.scale
		update_score_ui()
		update_bpm_ui()
	
	falling_button.visible = false
	
	update_tea_panel()
	update_baguette_panel()
	update_espresso_panel()
	update_matcha_panel()

func add_bread(amount: int) -> void:
	if double_clicks:
		amount *= 2

	clicks += amount
	clicks_in_sample_window += amount
	update_score_ui()
	update_baguette_panel()

func update_baguette_panel() -> void:
	if upgrades_panel and upgrades_panel.has_method("update_baguette_ui"):
		upgrades_panel.update_baguette_ui(upgrade_cost, upgrade_level)
	
func update_tea_panel() -> void:
	if upgrades_panel and upgrades_panel.has_method("update_tea_ui"):
		upgrades_panel.update_tea_ui(noob_auto_clicker_cost, noob_upgrade_level)

func update_espresso_panel() -> void:
	if upgrades_panel and upgrades_panel.has_method("update_espresso_ui"):
		upgrades_panel.update_espresso_ui(pro_auto_clicker_cost, pro_upgrade_level)

func update_matcha_panel() -> void:
	if upgrades_panel and upgrades_panel.has_method("update_matcha_ui"):
		upgrades_panel.update_matcha_ui(hacker_auto_clicker_cost, hacker_upgrade_level)
		
func _on_area_2d_mouse_entered() -> void:
	pass


func _on_area_2d_mouse_exited() -> void:
	pass

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
	label.text = "+" + str(click_power)
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

func spawn_cost_label(amount: int) -> void:
	var label = Label.new()
	label.text = "-" + str(amount)
	label.add_theme_font_size_override("font_size", 28)
	label.modulate = Color(1.0, 0.2, 0.2)
	
	var canvas = get_node_or_null("../CanvasLayer")
	if canvas:
		canvas.add_child(label)
	else:
		get_tree().current_scene.add_child(label)
	
	var spawn_pos = get_global_mouse_position() + Vector2(randf_range(-15, 15), randf_range(-15, 15))
	label.global_position = spawn_pos
	
	get_tree().current_scene.add_child(label)
	var tween:= label.create_tween().set_parallel(true)
	label.scale = Vector2(0.5, 0.5)
	
	tween.tween_property(label, "scale", Vector2(1.2, 1.2), 0.15)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(label, "position:y", label.position.y - 60, 0.6)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		
	tween.tween_property(label, "modulate:a", 0.0, 0.6).set_delay(0.1)
	
	tween.chain().tween_callback(label.queue_free)
	
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			add_bread(click_power)
			white()
			animate()
			spawn_label()
			update_score_ui()

func _on_button_pressed() -> void:
	print("BUTTON CLICKED")
	print("Clicks: ", clicks)
	print("Cost: ", upgrade_cost)
	print("Power: ", click_power)

	if clicks >= upgrade_cost:
		var spent: int = int(upgrade_cost)
		print("ENOUGH BREAD")
		clicks -= upgrade_cost
		click_power += 1
		spawn_cost_label(spent)
		upgrade_cost *= 1.5
		upgrade_level += 0.5
		$"../Label".text = str(upgrade_cost)
		update_score_ui()
		update_baguette_panel()
	else:
		print("NOT ENOUGH BREAD")
		
		

func auto_click():
	if auto_clickers >= 0:
		add_bread(auto_clickers)
		
		update_score_ui()


const max_noob_level: int = 100

func _on_button_2_pressed() -> void:
	if noob_upgrade_level >= max_noob_level:
		print("max level")
		return
		
	if clicks >= noob_auto_clicker_cost:
		var spent: int = int(noob_auto_clicker_cost)
		clicks -= noob_auto_clicker_cost
		spawn_cost_label(spent)
		noob_upgrade_level += 1
		noob_auto_clicker_cost *= 1.2
		auto_clickers += 1
		update_score_ui()
		update_tea_panel()
		
		
		
		
		

@onready var falling_button = $"../Button1"
@onready var falling_button2 = $"../Button2"

var falling = false
var fall_speed = 250.0
var fall_speed2 = 400.0



func _on_button_1_pressed() -> void:
	clicks += 10 * upgrade_level
	falling_button.visible = false
	update_score_ui()
	

var frenzy_duration: float = 6.0

func trigger_frenzy() -> void:
	var sequence := create_tween()
	
	sequence.tween_property(flash_overlay, "modulate:a", 1.0, 0.15)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	sequence.tween_property(flash_overlay, "modulate:a", 0.0, 0.35)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	sequence.tween_property(vigenette_overlay, "modulate:a", 1.0, 0.35)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	sequence.tween_interval(frenzy_duration)
	
	sequence.tween_property(flash_overlay, "modulate:a", 1.0, 0.15)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	
	sequence.tween_property(flash_overlay, "modulate:a", 0.0, 0.35)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	sequence.parallel().tween_property(vigenette_overlay, "modulate:a", 0.0, 0.5)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)

func _on_button_3_pressed() -> void:
	falling_button3.visible = false
	falling3 = false
	
	trigger_frenzy()
	click_power *= 2
	double_timer.start()
	trigger_frenzy()
	


func _on_double_timer_timeout() -> void:
	click_power /= 2
	
	double_rain_timer.start(randf_range(5.0, 20.0))
	

const  max_pro_level: int = 3

func _on_pro_button_pressed() -> void:
	if pro_upgrade_level >= max_pro_level:
		print("max level")
		return
		
	if clicks >= pro_auto_clicker_cost:
		var spent: int = int(pro_auto_clicker_cost)
		clicks -= pro_auto_clicker_cost
		spawn_cost_label(spent)
		pro_upgrade_level += 1
		auto_clickers += 5
		update_score_ui()

const max_hacker_level: int = 3

func _on_hacker_button_pressed() -> void:
	if hacker_upgrade_level >= max_hacker_level:
		print("max level")
		return
		
	if clicks >= hacker_auto_clicker_cost:
		var spent: int = int(hacker_auto_clicker_cost)
		clicks -= hacker_auto_clicker_cost
		spawn_cost_label(spent)
		hacker_upgrade_level += 1
		auto_clickers += 10
		update_score_ui()
