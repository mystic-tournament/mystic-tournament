class_name BaseController
extends Node
# TODO: Extend from https://github.com/godotengine/godot/pull/37200


# Signals connected to assigned character
signal died(by)
signal health_modified(delta, by)
signal ability_changed(idx, ability)
signal health_changed(value)

var input_enabled: bool = true
var character: BaseHero setget set_character

# TODO 4.0: Use Player type (cyclic dependency)
var _player


# TODO 4.0: Use Player type for player (cyclic dependency)
func _init(player) -> void:
	_player = player


func set_character(new_character: BaseHero) -> void:
	character = new_character
	character.set_network_master(get_network_master(), true)
	character._controller = self
	# warning-ignore:return_value_discarded
	character.connect("died", self, "_emit_died_signal")
	# warning-ignore:return_value_discarded
	character.connect("health_modified", self, "_emit_health_modified_signal")
	# warning-ignore:return_value_discarded
	character.connect("ability_changed", self, "_emit_ability_changed_signal")
	# warning-ignore:return_value_discarded
	character.connect("health_changed", self, "_emit_health_changed_signal")


# TODO 4.0: Use Player return type (cyclic dependency)
func get_player():
	return _player


func _emit_died_signal(by: BaseHero) -> void:
	emit_signal("died", by.get_controller())


func _emit_health_modified_signal(delta: int, by: BaseHero) -> void:
	emit_signal("health_modified", delta, by.get_controller())


func _emit_ability_changed_signal(idx: int, ability: BaseAbility) -> void:
	emit_signal("ability_changed", idx, ability)


func _emit_health_changed_signal(value: int) -> void:
	emit_signal("health_changed", value)
