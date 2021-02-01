class_name BaseController
extends Node
# TODO: Extend from https://github.com/godotengine/godot/pull/37200


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


# TODO 4.0: Use Player return type (cyclic dependency)
func get_player():
	return _player
