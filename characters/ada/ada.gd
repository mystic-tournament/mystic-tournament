class_name Ada
extends BaseHero


func _ready() -> void:
	mesh_instance = $MeshInstance
	projectile_spawn_pos = $MeshInstance/FrostBoltSpawn
	set_ability(Abilities.BASE_ATTACK, FrostBolt.new())
	set_ability(Abilities.ABILITY1, FrostPath.new())
