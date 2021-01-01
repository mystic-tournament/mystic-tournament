extends Node


signal started
signal about_to_start

var players: Dictionary # Contains player ids as keys and PlayerInfo as values
var map: Node = preload("res://maps/workshop_plane.tscn").instance()


puppetsync func start_game() -> void:
	emit_signal("about_to_start")
	var hero_scene: PackedScene = load("res://characters/ada/ada.tscn")
	for id in players:
		var hero: Ada = hero_scene.instance()
		hero.set_name("Player" + str(id))
		# warning-ignore:return_value_discarded
		hero.connect("died", self, "_on_hero_died")
		map.add_child(hero)

		var controller := PlayerController.new()
		players[id].controller = controller
		controller.set_network_master(id)
		add_child(controller)
		controller.character = hero
	emit_signal("started")


func respawn_time(level: int) -> int:
	return level # TODO: Use formula


func _on_hero_died(who: BaseHero, _by: BaseHero) -> void:
	who.visible = false
	yield(get_tree().create_timer(respawn_time(who.get_level())), "timeout")
	who.respawn(Vector3(0, 5, 0))
	who.visible = true
