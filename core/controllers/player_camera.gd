class_name PlayerCamera
extends SpringArm
# Represents the player's point of view; how the player sees the world.
# For this reason, cameras only have relevance to human-controlled players.


const MOUSE_ROTATION_SPEED := 0.002
const AXIS_ROTATION_SPEED := 0.03
const AXIS_DEADZONE := 0.03
const ZOOM_SPEED := 0.5

onready var _camera: Camera = $Camera


func _ready() -> void:
	if OS.is_window_focused():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(_delta: float) -> void:
	var vertical_axis: float = Input.get_joy_axis(0, JOY_AXIS_2)
	if abs(vertical_axis) > AXIS_DEADZONE:
		rotation.y -= vertical_axis * AXIS_ROTATION_SPEED

	var horizontal_axis: float = Input.get_joy_axis(0, JOY_AXIS_3)
	if abs(vertical_axis) > AXIS_DEADZONE:
		rotation.x -= horizontal_axis * AXIS_ROTATION_SPEED
		rotation.x = clamp(rotation.x, -PI / 2, 0.7)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cursor"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("zoom_in"):
		spring_length += ZOOM_SPEED
	elif event.is_action_pressed("zoom_out"):
		spring_length -= ZOOM_SPEED
	elif Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		rotation.y -= event.relative.x * MOUSE_ROTATION_SPEED
		rotation.x -= event.relative.y * MOUSE_ROTATION_SPEED
		rotation.x = clamp(rotation.x, -PI / 2, 0.7)
