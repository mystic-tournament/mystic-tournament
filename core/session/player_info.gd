class_name PlayerInfo
extends Node


var controller: BaseController
var team: int
var kills: int
var deaths: int
var assists: int
var damage: int
var healing: int


func _init(player_team: int) -> void:
	team = player_team
	# warning-ignore:return_value_discarded
	GameSession.connect("started", self, "_on_session_started")


func _on_session_started() -> void:
	for id in GameSession.players:
		var hero: BaseHero = GameSession.players[id].controller.character
		# warning-ignore:return_value_discarded
		hero.connect("died", self, "_on_hero_died", [hero])
		# warning-ignore:return_value_discarded
		hero.connect("health_modified", self, "_on_health_modified")


func _on_hero_died(by: BaseHero, who: BaseHero) -> void:
	if by == controller.character:
		kills += 1
	elif who == controller.character:
		deaths += 1


func _on_health_modified(delta: int, by: BaseHero) -> void:
	if by != controller.character:
		return
	if delta < 0:
		damage -= delta
	else:
		healing += delta
