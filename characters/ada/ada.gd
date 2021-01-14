class_name Ada
extends BaseHero


func _ready() -> void:
	projectile_spawn_pos = $Mesh/FrostBoltSpawn
	set_ability(Abilities.BASE_ATTACK, FrostBolt.new())
