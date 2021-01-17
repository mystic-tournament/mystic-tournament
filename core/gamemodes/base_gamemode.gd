class_name BaseGamemode


func _init() -> void:
	# warning-ignore:return_value_discarded
	GameSession.connect("started", self, "_on_session_started")


static func name() -> String:
	return String()


static func additional_settings() -> Array:
	return []


func _on_session_started() -> void:
	for id in GameSession.players:
		var hero: BaseHero = GameSession.players[id].controller.character
		# warning-ignore:return_value_discarded
		hero.connect("died", self, "_on_hero_died", [hero])


func _on_hero_died(_by: BaseHero, who: BaseHero) -> void:
	who.visible = false
	yield(GameSession.get_tree().create_timer(who.get_level()), "timeout") # TODO: Use formula
	who.respawn(Vector3(0, 5, 0))
	who.visible = true
