class_name BaseAbility


signal used
signal cooldown_changed

var cooldown: int


func use(_caster: BaseHero) -> void:
	emit_signal("used")


func set_cooldown(value: int) -> void:
	cooldown = value
	emit_signal("cooldown_changed")
