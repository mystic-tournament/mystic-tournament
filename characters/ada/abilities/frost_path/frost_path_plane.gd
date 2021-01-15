class_name FrostPathPlane
extends KinematicBody


const LIFETIME: int = 3
const SPEED: float = 13.75

onready var _animation_player: AnimationPlayer = $AnimationPlayer
onready var _mesh_instance: MeshInstance = $MeshInstance


func _ready() -> void:
	# Increase the size of the object along with movement to create the illusion
	# that the object is enlarging forward
	_animation_player.play("extend")

	# warning-ignore:return_value_discarded
	_animation_player.connect("animation_finished", self, "_on_animation_finished")
	# warning-ignore:return_value_discarded
	get_tree().create_timer(LIFETIME).connect("timeout", self, "queue_free")


func _physics_process(_delta: float) -> void:
	# warning-ignore:return_value_discarded
	move_and_slide(-global_transform.basis.z * SPEED, Vector3.UP)
	if is_on_wall():
		_animation_player.stop()
		set_physics_process(false)


func height() -> float:
	return _mesh_instance.mesh.size.y


# TODO 4.0: Unbind _anim_name and connect directly
func _on_animation_finished(_anim_name: String) -> void:
	set_physics_process(false)
