class_name PlayerController
extends BaseController
# A PlayerController is the interface between the BaseHero and the human player controlling it.
# It collect player inputs, sends it to other peers and applies it to the controlled character.


const ABILITY_ACTIONS = [
	"base_attack",
	"ability1",
	"ability2",
	"ability3",
	"ultimate",
]

var _camera: PlayerCamera
var _hud: HUD

var _x_strength: float
var _z_strength: float


func _ready() -> void:
	if is_network_master():
		_camera = load("res://core/controllers/player_camera.tscn").instance()
		character.add_child(_camera)

		_hud = load("res://ui/hud/hud.tscn").instance()
		add_child(_hud)
		_hud.character = character
	else:
		set_physics_process(false)
		set_process_input(false)


func _unhandled_input(event: InputEvent):
	if event.is_action("move_left"):
		_x_strength = Input.get_action_strength("move_right") - event.get_action_strength("move_left")
		return
	if event.is_action("move_right"):
		_x_strength = event.get_action_strength("move_right") - Input.get_action_strength("move_left")
		return
	if event.is_action("move_front"):
		_z_strength = Input.get_action_strength("move_back") - event.get_action_strength("move_front")
		return
	if event.is_action("move_back"):
		_z_strength = event.get_action_strength("move_back") - Input.get_action_strength("move_front")
		return
	
	for index in ABILITY_ACTIONS.size():
		if event.is_action_released(ABILITY_ACTIONS[index]) and character.can_use(index):
			character.rpc("rotate_smoothly_to", _camera.rotation.y)
			yield(get_tree().create_timer(character.get_rotation_time()), "timeout")
			character.rpc("use_ability", index)


func _physics_process(delta: float) -> void:
	if not input_enabled:
		return

	var direction := Vector3()
	direction += _camera.global_transform.basis.x * _x_strength
	direction += _camera.global_transform.basis.z * _z_strength
	direction.y = 0

	if direction != Vector3.ZERO:
		character.rpc("rotate_smoothly_to", _camera.rotation.y)
	character.move(delta, direction.normalized(), Input.is_action_just_pressed("jump"))
