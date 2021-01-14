extends KinematicBody


const SPEED: int = 20

var caster: BaseHero


func _physics_process(delta: float) -> void:
	var collision: KinematicCollision = move_and_collide(-global_transform.basis.z * delta * SPEED)
	if not collision:
		return

	if collision.collider.has_method("modify_health"):
		collision.collider.modify_health(-10, caster)
	queue_free()
