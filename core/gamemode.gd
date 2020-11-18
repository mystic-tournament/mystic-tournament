extends Node
# Represents current game rules


signal game_started
signal game_about_to_start

var teams: Array
var map: Node = preload("res://maps/workshop_plane.tscn").instance()


puppetsync func start_game() -> void:
	emit_signal("game_about_to_start")
	var hero_scene: PackedScene = load("res://characters/ada/ada.tscn")
	for team in Gamemode.teams:
		for network_id in team:
			if network_id == 0:
				continue
			var player: Ada = hero_scene.instance()
			player.set_name("Player" + str(network_id))
			player.set_controller(PlayerController.new())
			player.set_network_master(network_id, true)
			Gamemode.map.add_child(player)
	emit_signal("game_started")
