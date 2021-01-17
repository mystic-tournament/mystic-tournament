class_name FrostPath
extends BaseAbility


const IMPULSE_POWER: int = 23
const HEIGHT_GAP: float = 0.02 # To avoid colliding on spawn


func _init() -> void:
	cooldown = 4


func use(caster: BaseHero) -> void:
	.use(caster)
	var plane: FrostPathPlane = preload("res://characters/ada/abilities/frost_path/frost_path_plane.tscn").instance()
	plane.global_transform = caster.mesh_instance.global_transform
	plane.translation.y -= caster.mesh_instance.translation.y # Set position to floor
	GameSession.map.add_child(plane)

	caster.translation.y += plane.height() + HEIGHT_GAP # Move caster above plane
	caster.velocity = -caster.mesh_instance.global_transform.basis.z * IMPULSE_POWER
