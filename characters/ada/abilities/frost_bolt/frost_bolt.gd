class_name FrostBolt
extends BaseAbility


func use(caster: BaseHero) -> void:
	.use(caster)
	var frost_bold: KinematicBody = preload("res://characters/ada/abilities/frost_bolt/frost_bolt_projectile.tscn").instance()
	frost_bold.global_transform = caster.get_projectile_spawn_pos().global_transform
	frost_bold.caster = caster
	GameSession.map.add_child(frost_bold)
