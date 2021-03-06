class_name HUD
extends Control
# Displays elements overlaid on the screen.
# Every human-controlled player in the game has their own instance of the this class which draws separately of other UI.


onready var _abilities: HBoxContainer = $Abilities
onready var _hp_bar: ValueBar = $VBox/HBox/HPBar


func _ready() -> void:
	var controller: BaseController = GameSession.get_current_player().get_controller()
	var hero: BaseHero = controller.character
	for i in _abilities.get_child_count():
		var ability_hud: AbilityHUD = _abilities.get_child(i)
		ability_hud.action = PlayerController.ABILITY_ACTIONS[i]
		ability_hud.ability = hero.get_ability(i)

	# warning-ignore:return_value_discarded
	controller.connect("health_changed", _hp_bar, "set_value_smoothly")
	_hp_bar.reset(hero.health, hero.max_health)
