extends Button

@onready var clicker: Sprite2D = $"../Clicker"
var rebirths = 0


func _on_pressed() -> void:
	if clicker.clicks >= 100 :
		rebirths += 1
		clicker.clicks = 0
		clicker.auto_clicker_cost= 500
		clicker.auto_clickers = 0
		clicker.upgrade_cost  = 10
		clicker.upgrade_level  = 1
		clicker.click_power  = 1
