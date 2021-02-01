class_name BaseGamemode


func _init() -> void:
	# warning-ignore:return_value_discarded
	GameSession.connect("started", self, "_on_session_started")


static func name() -> String:
	return String()


static func additional_settings() -> Array:
	return []


func _on_session_started() -> void:
	for i in GameSession.get_players_count():
		var controller: BaseController = GameSession.get_player(i).get_controller()
		# warning-ignore:return_value_discarded
		controller.connect("died", self, "_on_hero_died", [controller])


func _on_hero_died(_by: BaseController, who: BaseController) -> void:
	var who_character: BaseHero = who.character
	who_character.visible = false
	yield(GameSession.get_tree().create_timer(who_character.get_level()), "timeout") # TODO: Use formula
	who_character.respawn(Vector3(0, 5, 0))
	who_character.visible = true
