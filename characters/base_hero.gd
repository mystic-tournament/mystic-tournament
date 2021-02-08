class_name BaseHero
extends KinematicBody


signal died(by)
signal health_modified(delta, by)
signal ability_changed(idx, ability)
signal health_changed(value)

enum Abilities {
	BASE_ATTACK,
	ABILITY1,
	ABILITY2,
	ABILITY3,
	ULTIMATE,
}

const MOVE_SPEED = 10
const JUMP_IMPULSE = 4

sync var max_health: int = 20
sync var health: int = max_health setget set_health

var velocity: Vector3

var _projectile_spawn_pos: Position3D
var _mesh_instance: MeshInstance
var _motion: Vector3
var _abilities: Array
var _ability_cooldowns: Array
# TODO 4.0: Use BaseController type (cyclic dependency)
var _controller

onready var _floating_text: FloatingText = $FloatingText
onready var _rotation_tween: Tween = $RotationTween
onready var _collision: CollisionShape = $Collision


func _init() -> void:
	_abilities.resize(Abilities.size())
	_ability_cooldowns.resize(Abilities.size())
	rset_config("global_transform", MultiplayerAPI.RPC_MODE_REMOTE)


func move(delta: float, direction: Vector3, jumping: bool) -> void:
	_motion = _motion.linear_interpolate(direction * MOVE_SPEED, Parameters.get_motion_interpolate_speed() * delta)

	var new_velocity: Vector3
	if is_on_floor() and velocity.length() < MOVE_SPEED:
		new_velocity = _motion
		if jumping:
			new_velocity.y = JUMP_IMPULSE
		else:
			new_velocity.y = -Parameters.get_gravity()
	else:
		new_velocity = velocity.linear_interpolate(_motion, Parameters.get_velocity_interpolate_speed() * delta)
		new_velocity.y = velocity.y - Parameters.get_gravity() * delta

	velocity = move_and_slide(new_velocity, Vector3.UP, true)
	# TODO: Replace with https://github.com/godotengine/godot/pull/37200
	rset_unreliable("global_transform", global_transform)


puppetsync func rotate_smoothly_to(y_radians: float) -> void:
	# warning-ignore:return_value_discarded
	_rotation_tween.interpolate_property(_mesh_instance, "rotation:y", _mesh_instance.rotation.y,
			y_radians, 0.1, Tween.TRANS_SINE, Tween.EASE_OUT)
	# warning-ignore:return_value_discarded
	_rotation_tween.interpolate_property(_collision, "rotation:y", _collision.rotation.y,
			y_radians, 0.1, Tween.TRANS_SINE, Tween.EASE_OUT)
	# warning-ignore:return_value_discarded
	_rotation_tween.start()


# TODO 4.0: Use BaseAbility type for ability (cyclic dependency)
func set_ability(idx: int, ability) -> void:
	assert(ability, "Ability cannot be null")
	assert(_abilities[idx] == null, "Ability cannot be set twice")

	_abilities[idx] = ability
	if ability.cooldown != 0:
		var cooldown_timer := GameTimer.new()
		cooldown_timer.wait_time = ability.cooldown
		cooldown_timer.one_shot = true
		_ability_cooldowns[idx] = cooldown_timer
		add_child(cooldown_timer)
		# warning-ignore:return_value_discarded
		ability.connect("used", cooldown_timer, "start")
		# warning-ignore:return_value_discarded
		ability.connect("cooldown_changed", cooldown_timer, "set_wait_time")
	emit_signal("ability_changed", idx, ability)


# TODO 4.0: Use BaseAbility type for return type (cyclic dependency)
func get_ability(idx: int):
	return _abilities[idx]


func get_ability_cooldown(idx: int) -> GameTimer:
	return _ability_cooldowns[idx]


func can_use_ability(idx: int) -> bool:
	if _abilities[idx] == null:
		return false
	var cooldown_timer: GameTimer = _ability_cooldowns[idx]
	return not cooldown_timer or cooldown_timer.is_stopped()


puppetsync func use_ability(idx: int) -> void:
	_abilities[idx].use(self)


func get_level() -> int:
	return 1 # TODO: Use internal variable


func get_rotation_time() -> float:
	return _rotation_tween.get_runtime()


func modify_health(delta: int, by: BaseHero) -> void:
	if health <= 0:
		return
	_floating_text.show_text(delta)
	# TODO 4.0: Remove extra self
	self.health = health + delta
	emit_signal("health_modified", delta, by)
	if health <= 0:
		visible = false
		emit_signal("died", by)


func set_health(value: int) -> void:
	health = value
	emit_signal("health_changed", health)


func respawn(position: Vector3) -> void:
	translation = position
	visible = true
	# TODO 4.0: Remove extra self
	self.health = max_health
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func get_projectile_spawn_pos() -> Position3D:
	return _projectile_spawn_pos


func get_mesh_instance() -> MeshInstance:
	return _mesh_instance


# TODO 4.0: Use BaseController return type (cyclic dependency)
func get_controller():
	return _controller
