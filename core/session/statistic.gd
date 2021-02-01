class_name Statistic


signal kills_changed(value)
signal deaths_changed(value)
signal assists_changed(value)
signal damage_changed(value)
signal healing_changed(value)

var kills: int setget set_kills
var deaths: int setget set_deaths
var assists: int setget set_assists
var damage: int setget set_damage
var healing: int setget set_healing


func set_kills(value: int) -> void:
	kills = value
	emit_signal("kills_changed", kills)


func set_deaths(value: int) -> void:
	deaths = value
	emit_signal("deaths_changed", deaths)


func set_assists(value: int) -> void:
	assists = value
	emit_signal("assists_changed", assists)


func set_damage(value: int) -> void:
	damage = value
	emit_signal("damage_changed", damage)


func set_healing(value: int) -> void:
	healing = value
	emit_signal("healing_changed", healing)
