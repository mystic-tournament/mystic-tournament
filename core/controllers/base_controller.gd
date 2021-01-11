class_name BaseController
extends Node
# TODO: Extend from https://github.com/godotengine/godot/pull/37200


var input_enabled: bool = true
var character: BaseHero setget set_character


func set_character(new_character: BaseHero) -> void:
	character = new_character
	character.set_network_master(get_network_master(), true)
