class_name HUD
extends Control


var character: BaseHero setget set_character

onready var _abilities = $Abilities


func _ready() -> void:
	for index in _abilities.get_child_count():
		_abilities.get_child(index).set_display_action(index)


func set_character(new_character: BaseHero) -> void:
	character = new_character