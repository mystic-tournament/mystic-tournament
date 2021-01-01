class_name HUD
extends Control
# Displays elements overlaid on the screen.
# Every human-controlled player in the game has their own instance of the this class which draws separately of other UI.


onready var _abilities: HBoxContainer = $Abilities
onready var _hp_bar: ValueBar = $VBox/HBox/HPBar


func _ready() -> void:
	for i in _abilities.get_child_count():
		_abilities.get_child(i).set_action_index(i)


func set_health(health: int) -> void:
	_hp_bar.set_value_smoothly(health)


func reset_health(current_health: int, max_health: int) -> void:
	_hp_bar.reset(current_health, max_health)
