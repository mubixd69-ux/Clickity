extends Button
@onready var sidebar = $"../../../.."

@onready var clicker = $"../../../../../../Clicker"
var rebirths = 0
var rebirth_price: float = 10000

func _ready() -> void:
	update_rebirth_panel()
	
func update_rebirth_panel() -> void:
	sidebar.update_rebirth_ui(rebirth_price, rebirths)
		
func _on_pressed() -> void:
	if clicker.clicks >= rebirth_price and rebirths < 8:
		rebirths += 1
		$"../../POP".play()
		clicker.clicks = 0
		clicker.noob_auto_clicker_cost= 150
		clicker.pro_auto_clicker_cost= 750
		clicker.hacker_auto_clicker_cost= 1500
		clicker.auto_clickers = 0
		clicker.upgrade_cost  = 10
		clicker.noob_upgrade_level  = 1
		clicker.pro_upgrade_level  = 1
		clicker.hacker_upgrade_level  = 1
		clicker.click_power  = 1
		
		clicker.noob_auto_clicker_cost *= 1.0-rebirths*0.1
		clicker.pro_auto_clicker_cost *= 1.0-rebirths*0.1
		clicker.hacker_auto_clicker_cost *= 1.0-rebirths*0.1
		clicker.upgrade_cost *= 1.0-rebirths*0.1
		
		sidebar.update_baguette_ui(clicker.upgrade_cost, clicker.upgrade_level)
		sidebar.update_tea_ui(clicker.noob_auto_clicker_cost, clicker.noob_upgrade_level)
		sidebar.update_espresso_ui(clicker.pro_auto_clicker_cost, clicker.pro_upgrade_level)
		sidebar.update_matcha_ui(clicker.hacker_auto_clicker_cost, clicker.hacker_upgrade_level)
		rebirth_price = rebirth_price * 5

		update_rebirth_panel()
