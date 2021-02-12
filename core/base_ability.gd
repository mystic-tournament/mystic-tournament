class_name BaseAbility


signal used

var _cooldown: AbilityCooldown


func use(_caster: BaseHero) -> void:
	if _cooldown:
		_cooldown.start()
	emit_signal("used")


func get_cooldown() -> AbilityCooldown:
	return _cooldown
