class_name PlayerInfo
extends Node


signal kills_changed(kills)
signal deaths_changed(deaths)
signal assists_changed(assists)
signal damage_changed(damage)
signal healing_changed(healing)

var controller: BaseController
var team: int
var kills: int setget set_kills
var deaths: int setget set_deaths
var assists: int setget set_assists
var damage: int setget set_damage
var healing: int setget set_healing


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
		self.kills += 1
	elif who == controller.character:
		self.deaths += 1


func _on_health_modified(delta: int, by: BaseHero) -> void:
	if by != controller.character:
		return
	if delta < 0:
		self.damage -= delta
	else:
		self.healing += delta


func set_kills(value: int) -> void:
	kills = value
	emit_signal("kills_changed", value)


func set_deaths(value: int) -> void:
	deaths = value
	emit_signal("deaths_changed", value)


func set_assists(value: int) -> void:
	assists = value
	emit_signal("assists_changed", value)


func set_damage(value: int) -> void:
	damage = value
	emit_signal("damage_changed", value)


func set_healing(value: int) -> void:
	healing = value
	emit_signal("healing_changed", value)
