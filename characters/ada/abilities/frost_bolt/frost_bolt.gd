class_name FrostBolt
extends BaseAbility


func use(caster: BaseHero, transform: Transform) -> void:
	var frost_bold: KinematicBody = preload("res://characters/ada/abilities/frost_bolt/frost_bolt_projectile.tscn").instance()
	frost_bold.global_transform = transform
	frost_bold.caster = caster
	GameSession.map.add_child(frost_bold)
