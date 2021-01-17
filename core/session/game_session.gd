extends Node


signal started
signal about_to_start

var players: Dictionary # Contains player ids as keys and PlayerInfo as values
var map: BaseMap
var gamemode: BaseGamemode


puppetsync func start_game() -> void:
	emit_signal("about_to_start")
	var hero_scene: PackedScene = preload("res://characters/ada/ada.tscn")
	for id in players:
		var hero: Ada = hero_scene.instance()
		hero.set_name("Player" + str(id))
		map.add_child(hero)

		var controller := PlayerController.new()
		players[id].controller = controller
		controller.set_network_master(id)
		add_child(controller)
		controller.character = hero
	emit_signal("started")


func current_player() -> PlayerInfo:
	var network_id: int = get_tree().get_network_unique_id()
	return players[network_id]
