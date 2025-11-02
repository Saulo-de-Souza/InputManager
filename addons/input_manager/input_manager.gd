@tool
class_name InputManager extends Node

# EXPORTS **********************************************************
## Device id
@export_range(0, 10, 1, "or_greater") var _device: int = 0
## Left Stick deadzone
@export_range(0.0, 1.0, 0.01) var _left_stick_deadzone: float = 0.2
## Right Stick deadzone
@export_range(0.0, 1.0, 0.01) var _right_stick_deadzone: float = 0.2
## Left Trigger deadzone
@export_range(0.0, 1.0, 0.01) var _left_trigger_deadzone: float = 0.0
## Right Trigger deadzone
@export_range(0.0, 1.0, 0.01) var _right_trigger_deadzone: float = 0.0

@export_category("Mapping")
@export_subgroup("Left Stick")
## Left Stick action name
@export_placeholder("Left Stick action name") var _left_stick_action_name = "left_stick":
	set(value):
		_actions_sticks.erase(_left_stick_action_name)
		_left_stick_action_name = value
		if value != "":
			_actions_sticks[_left_stick_action_name] = get_left_stick
## Corresponding key of negative axis x stick.
@export var _left_stick_key_negative_x: Key = Key.KEY_A:
	set(value):
		_left_stick_key_negative_x = value
## Corresponding key of positive axis x stick.
@export var _left_stick_key_positive_x: Key = Key.KEY_D:
	set(value):
		_left_stick_key_positive_x = value
## Corresponding key of negative axis y stick.
@export var _left_stick_key_negative_y: Key = Key.KEY_W:
	set(value):
		_left_stick_key_negative_y = value
## Corresponding key of positive axis y stick.
@export var _left_stick_key_positive_y: Key = Key.KEY_S:
	set(value):
		_left_stick_key_positive_y = value

@export_subgroup("Right Stick")
## Right Stick action name
@export_placeholder("Right Stick action name") var _right_stick_action_name = "right_stick":
	set(value):
		_actions_sticks.erase(_right_stick_action_name)
		_right_stick_action_name = value
		if value != "":
			_actions_sticks[_right_stick_action_name] = get_right_stick
## Corresponding key of negative axis x stick.
@export var _right_stick_key_negative_x: Key = Key.KEY_J:
	set(value):
		_right_stick_key_negative_x = value
## Corresponding key of positive axis x stick.
@export var _right_stick_key_positive_x: Key = Key.KEY_L:
	set(value):
		_right_stick_key_positive_x = value
## Corresponding key of negative axis y stick.
@export var _right_stick_key_negative_y: Key = Key.KEY_I:
	set(value):
		_right_stick_key_negative_y = value
## Corresponding key of positive axis y stick.
@export var _right_stick_key_positive_y: Key = Key.KEY_K:
	set(value):
		_right_stick_key_positive_y = value

@export_subgroup("Left Trigger")
## Left Trigger action name
@export_placeholder("Left Trigger action name") var _left_trigger_action_name = "aim":
	set(value):
		_actions_triggers.erase(_left_trigger_action_name)
		_left_trigger_action_name = value
		if value != "":
			_actions_triggers[_left_trigger_action_name] = get_left_trigger
## Corresponding key.
@export var _left_trigger_key: Key = Key.KEY_Q:
	set(value):
		_left_trigger_key = value

@export_subgroup("Right Trigger")
## Right Trigger action name
@export_placeholder("Right Trigger action name") var _right_trigger_action_name = "acceleration":
	set(value):
		_actions_triggers.erase(_right_trigger_action_name)
		_right_trigger_action_name = value
		if value != "":
			_actions_triggers[_right_trigger_action_name] = get_right_trigger
## Corresponding key.
@export var _right_trigger_key: Key = Key.KEY_E:
	set(value):
		_right_trigger_key = value

@export_subgroup("Left Shoulder")
## Button Left Shoulder of joystick action name
@export_placeholder("Left Shoulder action name") var _button_left_shoulder_action_name = "push":
	set(value):
		_actions_buttons.erase(_button_left_shoulder_action_name)
		_button_left_shoulder_action_name = value
		if value != "":
			_actions_buttons[_button_left_shoulder_action_name] = \
			get_left_shoulder_pressed if _button_left_shoulder_type == _event_type_enum.PRESSED \
			else get_left_shoulder_realesed if _button_left_shoulder_type == _event_type_enum.RELESED \
			else get_left_shoulder_oneshot if _button_left_shoulder_type == _event_type_enum.ONE_SHOT \
			else get_left_shoulder_toggle
## Button Left Shoulder event action
@export var _button_left_shoulder_type: _event_type_enum = _event_type_enum.PRESSED:
	set(value):
		_actions_buttons.erase(_button_left_shoulder_action_name)
		_button_left_shoulder_type = value
		if _button_left_shoulder_action_name != "":
			_actions_buttons[_button_left_shoulder_action_name] = \
			get_left_shoulder_pressed if _button_left_shoulder_type == _event_type_enum.PRESSED \
			else get_left_shoulder_realesed if _button_left_shoulder_type == _event_type_enum.RELESED \
			else get_left_shoulder_oneshot if _button_left_shoulder_type == _event_type_enum.ONE_SHOT \
			else get_left_shoulder_toggle
## Corresponding key.
@export var _button_left_shoulder_key: Key = Key.KEY_U:
	set(value):
		_button_left_shoulder_key = value

@export_subgroup("Right Shoulder")
## Button Right Shoulder of joystick action name
@export_placeholder("Right Shoulder action name") var _button_right_shoulder_action_name = "grab":
	set(value):
		_actions_buttons.erase(_button_right_shoulder_action_name)
		_button_right_shoulder_action_name = value
		if value != "":
			_actions_buttons[_button_right_shoulder_action_name] = \
			get_right_shoulder_pressed if _button_right_shoulder_type == _event_type_enum.PRESSED \
			else get_right_shoulder_realesed if _button_right_shoulder_type == _event_type_enum.RELESED \
			else get_right_shoulder_oneshot if _button_right_shoulder_type == _event_type_enum.ONE_SHOT \
			else get_right_shoulder_toggle
## Button Right Shoulder event action
@export var _button_right_shoulder_type: _event_type_enum = _event_type_enum.PRESSED:
	set(value):
		_actions_buttons.erase(_button_right_shoulder_action_name)
		_button_right_shoulder_type = value
		if _button_right_shoulder_action_name != "":
			_actions_buttons[_button_right_shoulder_action_name] = \
			get_right_shoulder_pressed if _button_right_shoulder_type == _event_type_enum.PRESSED \
			else get_right_shoulder_realesed if _button_right_shoulder_type == _event_type_enum.RELESED \
			else get_right_shoulder_oneshot if _button_right_shoulder_type == _event_type_enum.ONE_SHOT \
			else get_right_shoulder_toggle
## Corresponding key.
@export var _button_right_shoulder_key: Key = Key.KEY_O:
	set(value):
		_button_right_shoulder_key = value


@export_subgroup("Action Button A")
## Button A of joystick action name
@export_placeholder("Button A action name") var _button_a_action_name = "jump":
	set(value):
		_actions_buttons.erase(_button_a_action_name)
		_button_a_action_name = value
		if value != "":
			_actions_buttons[_button_a_action_name] = \
			get_button_a_pressed if _button_a_type == _event_type_enum.PRESSED \
			else get_button_a_realesed if _button_a_type == _event_type_enum.RELESED \
			else get_button_a_oneshot if _button_a_type == _event_type_enum.ONE_SHOT \
			else get_button_a_toggle
## Button A event action
@export var _button_a_type: _event_type_enum = _event_type_enum.PRESSED:
	set(value):
		_actions_buttons.erase(_button_a_action_name)
		_button_a_type = value
		if _button_a_action_name != "":
			_actions_buttons[_button_a_action_name] = \
			get_button_a_pressed if _button_a_type == _event_type_enum.PRESSED \
			else get_button_a_realesed if _button_a_type == _event_type_enum.RELESED \
			else get_button_a_oneshot if _button_a_type == _event_type_enum.ONE_SHOT \
			else get_button_a_toggle
## Corresponding key.
@export var _button_a_key: Key = Key.KEY_SPACE:
	set(value):
		_button_a_key = value

# TODO: Continuar aqui

# EXPORTS **********************************************************

# SIGNALS **********************************************************
signal on_mouse_motion_changed(value: Vector2)
signal on_device_changed(device: int, connected: bool)
signal on_left_stick_changed(value: Vector2, length: float)
signal on_right_stick_changed(value: Vector2, length: float)
signal on_left_trigger_changed(length: float)
signal on_right_trigger_changed(length: float)
signal on_left_shoulder_changed(pressed: bool)
signal on_right_shoulder_changed(pressed: bool)
signal on_left_stick_button_changed(pressed: bool)
signal on_right_stick_button_changed(pressed: bool)
signal on_button_a_changed(pressed: bool)
signal on_button_b_changed(pressed: bool)
signal on_button_x_changed(pressed: bool)
signal on_button_y_changed(pressed: bool)
signal on_dpad_up_changed(pressed: bool)
signal on_dpad_down_changed(pressed: bool)
signal on_dpad_left_changed(pressed: bool)
signal on_dpad_right_changed(pressed: bool)
signal on_start_changed(pressed: bool)
signal on_select_changed(pressed: bool)
signal on_action_button(action_name: String, pressed: bool)
signal on_action_trigger(action_name: String, value: float)
signal on_action_stick(action_name: String, value: Vector2)
# SIGNALS **********************************************************

var _actions_buttons: Dictionary[String, Callable] = {}
var _actions_sticks: Dictionary[String, Callable] = {}
var _actions_triggers: Dictionary[String, Callable] = {}
enum _event_type_enum {
	## When the button is pressed.
	PRESSED,
	## When the button is released.
	RELESED,
	## Only one shot can be fired when pressing or holding the button.
	ONE_SHOT,
	## It alternates every time you press it. Ideal for changing states, such as lowering a character, etc.
	TOGGLE
	}

var _shift_pressed: bool = false:
	set(value):
		_shift_pressed = value
		_left_stick.x = (sign(_left_stick.x) * (0.5 if not _shift_pressed else 1.0))
		_left_stick.y = (sign(_left_stick.y) * (0.5 if not _shift_pressed else 1.0))

# TODO: Colocar os signals nas propriedades abaixo:

# LEFT STICKS
var _left_stick: Vector2 = Vector2.ZERO:
	set(value):
		if value != _left_stick:
			_left_stick = value
			on_left_stick_changed.emit(get_left_stick(), get_left_stick_length())
			on_action_stick.emit(_left_stick_action_name, get_left_stick()) # TODO: Fazer nos outros
var _left_axis_h: float = 0.0:
	set(value):
		if _left_axis_h != value:
			_left_axis_h = value
			_left_stick = Vector2(_left_axis_h, _left_axis_v)
var _left_axis_v: float = 0.0:
	set(value):
		if _left_axis_v != value:
			_left_axis_v = value
			_left_stick = Vector2(_left_axis_h, _left_axis_v)

# RIGHT STICKS
var _right_stick: Vector2 = Vector2.ZERO:
	set(value):
		if value != _right_stick:
			_right_stick = value
			on_right_stick_changed.emit(get_right_stick(), get_right_stick_length())
			on_action_stick.emit(_right_stick_action_name, get_right_stick()) # TODO: Fazer nos outros
var _right_axis_h: float = 0.0:
	set(value):
		if _right_axis_h != value:
			_right_axis_h = value
			_right_stick = Vector2(_right_axis_h, _right_axis_v)
var _right_axis_v: float = 0.0:
	set(value):
		if _right_axis_v != value:
			_right_axis_v = value
			_right_stick = Vector2(_right_axis_h, _right_axis_v)

# TRIGGERS
var _left_trigger: float = 0.0:
	set(value):
		if _left_trigger != value:
			_left_trigger = value
			on_left_trigger_changed.emit(_left_trigger)
			on_action_trigger.emit(_left_trigger_action_name, value) # TODO: Fazer nos outros
var _right_trigger: float = 0.0:
	set(value):
		if _right_trigger != value:
			_right_trigger = value
			on_right_trigger_changed.emit(_right_trigger)

# LEFT SHOULDER
var _left_shoulder_pressed: bool = false:
	set(value):
		_left_shoulder_pressed = value
		on_left_shoulder_changed.emit(value)
var _left_shoulder_realesed: bool = false
var _left_shoulder_oneshot: bool = false
var _left_shoulder_toggle: bool = false

# RIGHT SHOULDER
var _right_shoulder_pressed: bool = false:
	set(value):
		_right_shoulder_pressed = value
		on_right_shoulder_changed.emit(value)
var _right_shoulder_realesed: bool = false
var _right_shoulder_oneshot: bool = false
var _right_shoulder_toggle: bool = false

# LEFT STICK BUTTON
var _left_stick_button_pressed: bool = false:
	set(value):
		_left_stick_button_pressed = value
		on_left_stick_button_changed.emit(value)
var _left_stick_button_realesed: bool = false
var _left_stick_button_oneshot: bool = false
var _left_stick_button_toggle: bool = false

# RIGHT STICK BUTTON
var _right_stick_button_pressed: bool = false:
	set(value):
		_right_stick_button_pressed = value
		on_right_stick_button_changed.emit(value)
var _right_stick_button_realesed: bool = false
var _right_stick_button_oneshot: bool = false
var _right_stick_button_toggle: bool = false

# BUTTON A
var _button_a_pressed: bool = false:
	set(value):
		_button_a_pressed = value
		on_button_a_changed.emit(value)
		on_action_button.emit(_button_a_action_name, value) # TODO: Fazer nos outros
var _button_a_realesed: bool = false
var _button_a_oneshot: bool = false
var _button_a_toggle: bool = false

# BUTTON B
var _button_b_pressed: bool = false:
	set(value):
		_button_b_pressed = value
		on_button_b_changed.emit(value)
var _button_b_realesed: bool = false
var _button_b_oneshot: bool = false
var _button_b_toggle: bool = false

# BUTTON X
var _button_x_pressed: bool = false:
	set(value):
		_button_x_pressed = value
		on_button_x_changed.emit(value)
var _button_x_realesed: bool = false
var _button_x_oneshot: bool = false
var _button_x_toggle: bool = false

# BUTTON Y
var _button_y_pressed: bool = false:
	set(value):
		_button_y_pressed = value
		on_button_y_changed.emit(value)
var _button_y_realesed: bool = false
var _button_y_oneshot: bool = false
var _button_y_toggle: bool = false

# DPAD UP
var _dpad_up_pressed: bool = false:
	set(value):
		_dpad_up_pressed = value
		on_dpad_up_changed.emit(value)
var _dpad_up_realesed: bool = false
var _dpad_up_oneshot: bool = false
var _dpad_up_toggle: bool = false

# DPAD DOW
var _dpad_down_pressed: bool = false:
	set(value):
		_dpad_down_pressed = value
		on_dpad_down_changed.emit(value)
var _dpad_down_realesed: bool = false
var _dpad_down_oneshot: bool = false
var _dpad_down_toggle: bool = false

# DPAD LEFT
var _dpad_left_pressed: bool = false:
	set(value):
		_dpad_left_pressed = value
		on_dpad_left_changed.emit(value)
var _dpad_left_realesed: bool = false
var _dpad_left_oneshot: bool = false
var _dpad_left_toggle: bool = false

# DPAD RIGHT
var _dpad_right_pressed: bool = false:
	set(value):
		_dpad_right_pressed = value
		on_dpad_right_changed.emit(value)
var _dpad_right_realesed: bool = false
var _dpad_right_oneshot: bool = false
var _dpad_right_toggle: bool = false

# START
var _start_pressed: bool = false:
	set(value):
		_start_pressed = value
		on_start_changed.emit(value)
var _start_realesed: bool = false
var _start_oneshot: bool = false
var _start_toggle: bool = false

# SELECT
var _select_pressed: bool = false:
	set(value):
		_select_pressed = value
		on_select_changed.emit(value)
var _select_realesed: bool = false
var _select_oneshot: bool = false
var _select_toggle: bool = false

# KEYS WASD
var _key_w_pressed: bool = false:
	set(value):
		if _key_w_pressed != value:
			_key_w_pressed = value
			_left_stick.y = -1.0 * (0.5 if not _shift_pressed else 1.0) if value else 0.0
var _key_s_pressed: bool = false:
	set(value):
		if _key_s_pressed != value:
			_key_s_pressed = value
			_left_stick.y = 1.0 * (0.5 if not _shift_pressed else 1.0) if value else 0.0
var _key_a_pressed: bool = false:
	set(value):
		if _key_a_pressed != value:
			_key_a_pressed = value
			_left_stick.x = -1.0 * (0.5 if not _shift_pressed else 1.0) if value else 0.0
var _key_d_pressed: bool = false:
	set(value):
		if _key_d_pressed != value:
			_key_d_pressed = value
			_left_stick.x = 1.0 * (0.5 if not _shift_pressed else 1.0) if value else 0.0

# KEYS IJKL
var _key_i_pressed: bool = false:
	set(value):
		if _key_i_pressed != value:
			_key_i_pressed = value
			_right_stick.y = -1.0 if value else 0.0
var _key_k_pressed: bool = false:
	set(value):
		if _key_k_pressed != value:
			_key_k_pressed = value
			_right_stick.y = 1.0 if value else 0.0
var _key_j_pressed: bool = false:
	set(value):
		if _key_j_pressed != value:
			_key_j_pressed = value
			_right_stick.x = -1.0 if value else 0.0
var _key_l_pressed: bool = false:
	set(value):
		if _key_l_pressed != value:
			_key_l_pressed = value
			_right_stick.x = 1.0 if value else 0.0

# ENGINE METHODS ***************************************************
func _init() -> void:
	if _left_stick_action_name != "":
		_actions_sticks[_left_stick_action_name] = get_left_stick

	if _right_stick_action_name != "":
		_actions_sticks[_right_stick_action_name] = get_right_stick

	if _left_trigger_action_name != "":
		_actions_triggers[_left_trigger_action_name] = get_left_trigger

	if _right_trigger_action_name != "":
		_actions_triggers[_right_trigger_action_name] = get_right_trigger

	if _button_left_shoulder_action_name != "":
		_actions_buttons[_button_left_shoulder_action_name] = \
		get_left_shoulder_pressed if _button_left_shoulder_type == _event_type_enum.PRESSED \
		else get_left_shoulder_realesed if _button_left_shoulder_type == _event_type_enum.RELESED \
		else get_left_shoulder_oneshot if _button_left_shoulder_type == _event_type_enum.ONE_SHOT \
		else get_left_shoulder_toggle

	if _button_right_shoulder_action_name != "":
		_actions_buttons[_button_right_shoulder_action_name] = \
		get_right_shoulder_pressed if _button_right_shoulder_type == _event_type_enum.PRESSED \
		else get_right_shoulder_realesed if _button_right_shoulder_type == _event_type_enum.RELESED \
		else get_right_shoulder_oneshot if _button_right_shoulder_type == _event_type_enum.ONE_SHOT \
		else get_right_shoulder_toggle

	if _button_a_action_name != "":
		_actions_buttons[_button_a_action_name] = \
		get_button_a_pressed if _button_a_type == _event_type_enum.PRESSED \
		else get_button_a_realesed if _button_a_type == _event_type_enum.RELESED \
		else get_button_a_oneshot if _button_a_type == _event_type_enum.ONE_SHOT \
		else get_button_a_toggle

		# TODO: Continuar aqui
func _ready():
	Input.joy_connection_changed.connect(func(device, connected): on_device_changed.emit(device, connected))
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadMotion:
		_check_left_stick(event)
		_check_right_stick(event)
		_check_left_trigger(event)
		_check_right_trigger(event)
	elif event is InputEventJoypadButton:
		_check_left_shoulder(event)
		_check_right_shoulder(event)
		_check_left_stick_button(event)
		_check_right_stick_button(event)
		_check_button_a(event)
		_check_button_b(event)
		_check_button_x(event)
		_check_button_y(event)
		_check_dpad_up(event)
		_check_dpad_down(event)
		_check_dpad_left(event)
		_check_dpad_right(event)
		_check_start(event)
		_check_select(event)
	elif event is InputEventKey:
		_check_keyboard(event)
	elif event is InputEventMouseMotion:
		_check_mouse_motion(event)
	elif event is InputEventMouseButton:
		_check_mouse_button(event)
	pass
# ENGINE METHODS ***************************************************

# PUBLIC METHODS ***************************************************
# ACTIONS NAME
func get_action_button(action_name: String) -> bool:
	if not action_name in _actions_buttons:
		push_warning("%s mapping does not exist."%action_name)
		return false
	var result = _actions_buttons[action_name].call()
	return result

func get_action_stick(action_name: String) -> Vector2:
	if not action_name in _actions_sticks:
		push_warning("%s mapping does not exist."%action_name)
		return Vector2.ZERO
	var result = _actions_sticks[action_name].call()
	return result

func get_action_trigger(action_name: String) -> float:
	if not action_name in _actions_triggers:
		push_warning("%s mapping does not exist."%action_name)
		return 0.0
	var result = _actions_triggers[action_name].call()
	return result

# LEFT STICK GETTER
func get_left_stick() -> Vector2:
	return _left_stick
func get_left_stick_length() -> float:
	return clamp(get_left_stick().length(), 0.0, 1.0)

# LEFT STICK GETTER
func get_right_stick() -> Vector2:
	return _right_stick
func get_right_stick_length() -> float:
	return clamp(get_right_stick().length(), 0.0, 1.0)

# TRIGGERS GETTER
func get_left_trigger() -> float:
	return _left_trigger
func get_right_trigger() -> float:
	return _right_trigger

# LEFT SHOULDER GETTERS
func get_left_shoulder_pressed() -> bool:
	return _left_shoulder_pressed
func get_left_shoulder_realesed() -> bool:
	if _left_shoulder_realesed:
		_left_shoulder_realesed = false
		return true
	return false
func get_left_shoulder_oneshot() -> bool:
	if _left_shoulder_oneshot:
		_left_shoulder_oneshot = false
		return true
	return false
func get_left_shoulder_toggle() -> bool:
	return _left_shoulder_toggle

# RIGHT SHOULDER GETTERS
func get_right_shoulder_pressed() -> bool:
	return _right_shoulder_pressed
func get_right_shoulder_realesed() -> bool:
	if _right_shoulder_realesed:
		_right_shoulder_realesed = false
		return true
	return false
func get_right_shoulder_oneshot() -> bool:
	if _right_shoulder_oneshot:
		_right_shoulder_oneshot = false
		return true
	return false
func get_right_shoulder_toggle() -> bool:
	return _right_shoulder_toggle

# LEFT STICK BUTTON GETTERS
func get_left_stick_button_pressed() -> bool:
	return _left_stick_button_pressed
func get_left_stick_button_realesed() -> bool:
	if _left_stick_button_realesed:
		_left_stick_button_realesed = false
		return true
	return false
func get_left_stick_button_oneshot() -> bool:
	if _left_stick_button_oneshot:
		_left_stick_button_oneshot = false
		return true
	return false
func get_left_stick_button_toggle() -> bool:
	return _left_stick_button_toggle

# RIGHT STICK BUTTON GETTERS
func get_right_stick_button_pressed() -> bool:
	return _right_stick_button_pressed
func get_right_stick_button_realesed() -> bool:
	if _right_stick_button_realesed:
		_right_stick_button_realesed = false
		return true
	return false
func get_right_stick_button_oneshot() -> bool:
	if _right_stick_button_oneshot:
		_right_stick_button_oneshot = false
		return true
	return false
func get_right_stick_button_toggle() -> bool:
	return _right_stick_button_toggle

# BUTTON A GETTERS
func get_button_a_pressed() -> bool:
	return _button_a_pressed
func get_button_a_realesed() -> bool:
	if _button_a_realesed:
		_button_a_realesed = false
		return true
	return false
func get_button_a_oneshot() -> bool:
	if _button_a_oneshot:
		_button_a_oneshot = false
		return true
	return false
func get_button_a_toggle() -> bool:
	return _button_a_toggle

# BUTTON B GETTERS
func get_button_b_pressed() -> bool:
	return _button_b_pressed
func get_button_b_realesed() -> bool:
	if _button_b_realesed:
		_button_b_realesed = false
		return true
	return false
func get_button_b_oneshot() -> bool:
	if _button_b_oneshot:
		_button_b_oneshot = false
		return true
	return false
func get_button_b_toggle() -> bool:
	return _button_b_toggle

# BUTTON X GETTERS
func get_button_x_pressed() -> bool:
	return _button_x_pressed
func get_button_x_realesed() -> bool:
	if _button_x_realesed:
		_button_x_realesed = false
		return true
	return false
func get_button_x_oneshot() -> bool:
	if _button_x_oneshot:
		_button_x_oneshot = false
		return true
	return false
func get_button_x_toggle() -> bool:
	return _button_x_toggle

# BUTTON Y GETTERS
func get_button_y_pressed() -> bool:
	return _button_y_pressed
func get_button_y_realesed() -> bool:
	if _button_y_realesed:
		_button_y_realesed = false
		return true
	return false
func get_button_y_oneshot() -> bool:
	if _button_y_oneshot:
		_button_y_oneshot = false
		return true
	return false
func get_button_y_toggle() -> bool:
	return _button_y_toggle

# DPAD UP
func get_dpad_up_pressed() -> bool:
	return _dpad_up_pressed
func get_dpad_up_realesed() -> bool:
	if _dpad_up_realesed:
		_dpad_up_realesed = false
		return true
	return false
func get_dpad_up_oneshot() -> bool:
	if _dpad_up_oneshot:
		_dpad_up_oneshot = false
		return true
	return false
func get_dpad_up_toggle() -> bool:
	return _dpad_up_toggle

# DPAD DOWN
func get_dpad_down_pressed() -> bool:
	return _dpad_down_pressed
func get_dpad_down_realesed() -> bool:
	if _dpad_down_realesed:
		_dpad_down_realesed = false
		return true
	return false
func get_dpad_down_oneshot() -> bool:
	if _dpad_down_oneshot:
		_dpad_down_oneshot = false
		return true
	return false
func get_dpad_down_toggle() -> bool:
	return _dpad_down_toggle

# DPAD LEFT
func get_dpad_left_pressed() -> bool:
	return _dpad_left_pressed
func get_dpad_left_realesed() -> bool:
	if _dpad_left_realesed:
		_dpad_left_realesed = false
		return true
	return false
func get_dpad_left_oneshot() -> bool:
	if _dpad_left_oneshot:
		_dpad_left_oneshot = false
		return true
	return false
func get_dpad_left_toggle() -> bool:
	return _dpad_left_toggle

# DPAD RIGHT
func get_dpad_right_pressed() -> bool:
	return _dpad_right_pressed
func get_dpad_right_realesed() -> bool:
	if _dpad_right_realesed:
		_dpad_right_realesed = false
		return true
	return false
func get_dpad_right_oneshot() -> bool:
	if _dpad_right_oneshot:
		_dpad_right_oneshot = false
		return true
	return false
func get_dpad_right_toggle() -> bool:
	return _dpad_right_toggle

# START
func get_start_pressed() -> bool:
	return _start_pressed
func get_start_realesed() -> bool:
	if _start_realesed:
		_start_realesed = false
		return true
	return false
func get_start_oneshot() -> bool:
	if _start_oneshot:
		_start_oneshot = false
		return true
	return false
func get_start_toggle() -> bool:
	return _start_toggle

# SELECT
func get_select_pressed() -> bool:
	return _select_pressed
func get_select_realesed() -> bool:
	if _select_realesed:
		_select_realesed = false
		return true
	return false
func get_select_oneshot() -> bool:
	if _select_oneshot:
		_select_oneshot = false
		return true
	return false
func get_select_toggle() -> bool:
	return _select_toggle

# PUBLIC METHODS ***************************************************

# PRIVATE METHODS **************************************************
func _get_toggle(toggle: bool) -> bool:
	if toggle:
		return true
	else:
		return false
		
func _apply_deadzone_axis(value: float, deadzone: float) -> float:
	if abs(value) < deadzone:
		return 0.0
	else:
		return sign(value) * ((abs(value) - deadzone) / (1.0 - deadzone))

func start_vibration(left_strength: float, right_strength: float, duration: float) -> void:
	Input.start_joy_vibration(_device, right_strength, left_strength, duration)
	pass

func stop_vibration() -> void:
	Input.stop_joy_vibration(_device)
	pass

func _check_left_stick(event: InputEventJoypadMotion) -> void:
	if event.device == _device:
		if event.axis == JOY_AXIS_LEFT_X:
			_left_axis_h = _apply_deadzone_axis(event.axis_value, _left_stick_deadzone)
		elif event.axis == JOY_AXIS_LEFT_Y:
			_left_axis_v = _apply_deadzone_axis(event.axis_value, _left_stick_deadzone)
	pass

func _check_right_stick(event: InputEventJoypadMotion) -> void:
	if event.device == _device:
		if event.axis == JOY_AXIS_RIGHT_X:
			_right_axis_h = _apply_deadzone_axis(event.axis_value, _right_stick_deadzone)
		elif event.axis == JOY_AXIS_RIGHT_Y:
			_right_axis_v = _apply_deadzone_axis(event.axis_value, _right_stick_deadzone)
	pass

func _check_left_trigger(event: InputEventJoypadMotion) -> void:
	if event.device == _device:
		if event.axis == JOY_AXIS_TRIGGER_LEFT:
			_left_trigger = _apply_deadzone_axis(event.axis_value, _left_trigger_deadzone)
	pass

func _check_right_trigger(event: InputEventJoypadMotion) -> void:
	if event.device == _device:
		if event.axis == JOY_AXIS_TRIGGER_RIGHT:
			_right_trigger = _apply_deadzone_axis(event.axis_value, _right_trigger_deadzone)
	pass

func _check_button_a(event: InputEventJoypadButton) -> void:
	if _device == event.device:
			if event.button_index == JOY_BUTTON_A:
				if event.pressed:
					_button_a_oneshot = true
					_button_a_realesed = false
					_button_a_pressed = true
					if _get_toggle(_button_a_oneshot): _button_a_toggle = not _button_a_toggle
				else:
					_button_a_oneshot = false
					_button_a_realesed = true
					_button_a_pressed = false
	pass

func _check_button_b(event: InputEventJoypadButton) -> void:
	if _device == event.device:
			if event.button_index == JOY_BUTTON_B:
				if event.pressed:
					_button_b_oneshot = true
					_button_b_realesed = false
					_button_b_pressed = true
					if _get_toggle(_button_b_oneshot): _button_b_toggle = not _button_b_toggle
				else:
					_button_b_oneshot = false
					_button_b_realesed = true
					_button_b_pressed = false
	pass

func _check_button_x(event: InputEventJoypadButton) -> void:
	if _device == event.device:
			if event.button_index == JOY_BUTTON_X:
				if event.pressed:
					_button_x_oneshot = true
					_button_x_realesed = false
					_button_x_pressed = true
					if _get_toggle(_button_x_oneshot): _button_x_toggle = not _button_x_toggle
				else:
					_button_x_oneshot = false
					_button_x_realesed = true
					_button_x_pressed = false
	pass

func _check_button_y(event: InputEventJoypadButton) -> void:
	if _device == event.device:
			if event.button_index == JOY_BUTTON_Y:
				if event.pressed:
					_button_y_oneshot = true
					_button_y_realesed = false
					_button_y_pressed = true
					if _get_toggle(_button_y_oneshot): _button_y_toggle = not _button_y_toggle
				else:
					_button_y_oneshot = false
					_button_y_realesed = true
					_button_y_pressed = false
	pass

func _check_dpad_up(event: InputEventJoypadButton) -> void:
	if _device == event.device:
			if event.button_index == JOY_BUTTON_DPAD_UP:
				if event.pressed:
					_dpad_up_oneshot = true
					_dpad_up_realesed = false
					_dpad_up_pressed = true
					if _get_toggle(_dpad_up_oneshot): _dpad_up_toggle = not _dpad_up_toggle
				else:
					_dpad_up_oneshot = false
					_dpad_up_realesed = true
					_dpad_up_pressed = false
	pass

func _check_dpad_down(event: InputEventJoypadButton) -> void:
	if _device == event.device:
			if event.button_index == JOY_BUTTON_DPAD_DOWN:
				if event.pressed:
					_dpad_down_oneshot = true
					_dpad_down_realesed = false
					_dpad_down_pressed = true
					if _get_toggle(_dpad_down_oneshot): _dpad_down_toggle = not _dpad_down_toggle
				else:
					_dpad_down_oneshot = false
					_dpad_down_realesed = true
					_dpad_down_pressed = false
	pass

func _check_dpad_left(event: InputEventJoypadButton) -> void:
	if _device == event.device:
			if event.button_index == JOY_BUTTON_DPAD_LEFT:
				if event.pressed:
					_dpad_left_oneshot = true
					_dpad_left_realesed = false
					_dpad_left_pressed = true
					if _get_toggle(_dpad_left_oneshot): _dpad_left_toggle = not _dpad_left_toggle
				else:
					_dpad_left_oneshot = false
					_dpad_left_realesed = true
					_dpad_left_pressed = false
	pass

func _check_dpad_right(event: InputEventJoypadButton) -> void:
	if _device == event.device:
			if event.button_index == JOY_BUTTON_DPAD_RIGHT:
				if event.pressed:
					_dpad_right_oneshot = true
					_dpad_right_realesed = false
					_dpad_right_pressed = true
					if _get_toggle(_dpad_right_oneshot): _dpad_right_toggle = not _dpad_right_toggle
				else:
					_dpad_right_oneshot = false
					_dpad_right_realesed = true
					_dpad_right_pressed = false
	pass

func _check_start(event: InputEventJoypadButton) -> void:
	if _device == event.device:
			if event.button_index == JOY_BUTTON_START:
				if event.pressed:
					_start_oneshot = true
					_start_realesed = false
					_start_pressed = true
					if _get_toggle(_start_oneshot): _start_toggle = not _start_toggle
				else:
					_start_oneshot = false
					_start_realesed = true
					_start_pressed = false
	pass

func _check_select(event: InputEventJoypadButton) -> void:
	if _device == event.device:
			if event.button_index == JOY_BUTTON_BACK:
				if event.pressed:
					_select_oneshot = true
					_select_realesed = false
					_select_pressed = true
					if _get_toggle(_select_oneshot): _select_toggle = not _select_toggle
				else:
					_select_oneshot = false
					_select_realesed = true
					_select_pressed = false
	pass

func _check_left_shoulder(event: InputEventJoypadButton) -> void:
	if _device == event.device:
			if event.button_index == JOY_BUTTON_LEFT_SHOULDER:
				if event.pressed:
					_left_shoulder_oneshot = true
					_left_shoulder_realesed = false
					_left_shoulder_pressed = true
					if _get_toggle(_left_shoulder_oneshot): _left_shoulder_toggle = not _left_shoulder_toggle
				else:
					_left_shoulder_oneshot = false
					_left_shoulder_realesed = true
					_left_shoulder_pressed = false
	pass

func _check_right_shoulder(event: InputEventJoypadButton) -> void:
	if _device == event.device:
			if event.button_index == JOY_BUTTON_RIGHT_SHOULDER:
				if event.pressed:
					_right_shoulder_oneshot = true
					_right_shoulder_realesed = false
					_right_shoulder_pressed = true
					if _get_toggle(_right_shoulder_oneshot): _right_shoulder_toggle = not _right_shoulder_toggle
				else:
					_right_shoulder_oneshot = false
					_right_shoulder_realesed = true
					_right_shoulder_pressed = false
	pass

func _check_left_stick_button(event: InputEventJoypadButton) -> void:
	if _device == event.device:
			if event.button_index == JOY_BUTTON_LEFT_STICK:
				if event.pressed:
					_left_stick_button_oneshot = true
					_left_stick_button_realesed = false
					_left_stick_button_pressed = true
					if _get_toggle(_left_stick_button_oneshot): _left_stick_button_toggle = not _left_stick_button_toggle
				else:
					_left_stick_button_oneshot = false
					_left_stick_button_realesed = true
					_left_stick_button_pressed = false
	pass

func _check_right_stick_button(event: InputEventJoypadButton) -> void:
	if _device == event.device:
			if event.button_index == JOY_BUTTON_RIGHT_STICK:
				if event.pressed:
					_right_stick_button_oneshot = true
					_right_stick_button_realesed = false
					_right_stick_button_pressed = true
					if _get_toggle(_right_stick_button_oneshot): _right_stick_button_toggle = not _right_stick_button_toggle
				else:
					_right_stick_button_oneshot = false
					_right_stick_button_realesed = true
					_right_stick_button_pressed = false
	pass

func _check_keyboard(event: InputEventKey) -> void:
	# TODO: Continuar aqui
	match event.keycode:
		_left_stick_key_negative_y:
			_key_w_pressed = event.pressed
		_left_stick_key_positive_y:
			_key_s_pressed = event.pressed
		_left_stick_key_negative_x:
			_key_a_pressed = event.pressed
		_left_stick_key_positive_x:
			_key_d_pressed = event.pressed
		_right_stick_key_negative_y:
			_key_i_pressed = event.pressed
		_right_stick_key_negative_x:
			_key_j_pressed = event.pressed
		_right_stick_key_positive_y:
			_key_k_pressed = event.pressed
		_right_stick_key_positive_x:
			_key_l_pressed = event.pressed
		_left_trigger_key:
			_left_trigger = 1.0 if event.pressed else 0.0
		_right_trigger_key:
			_right_trigger = 1.0 if event.pressed else 0.0
		_button_left_shoulder_key:
			if event.pressed != _left_shoulder_pressed:
				if event.pressed:
					_left_shoulder_oneshot = true
					_left_shoulder_realesed = false
					_left_shoulder_pressed = true
					if _get_toggle(_left_shoulder_oneshot): _left_shoulder_toggle = not _left_shoulder_toggle
				else:
					_left_shoulder_oneshot = false
					_left_shoulder_realesed = true
					_left_shoulder_pressed = false
		_button_right_shoulder_key:
			if event.pressed != _right_shoulder_pressed:
				if event.pressed:
					_right_shoulder_oneshot = true
					_right_shoulder_realesed = false
					_right_shoulder_pressed = true
					if _get_toggle(_right_shoulder_oneshot): _right_shoulder_toggle = not _right_shoulder_toggle
				else:
					_right_shoulder_oneshot = false
					_right_shoulder_realesed = true
					_right_shoulder_pressed = false
		KEY_F:
			if event.pressed != _left_stick_button_pressed:
				if event.pressed:
					_left_stick_button_oneshot = true
					_left_stick_button_realesed = false
					_left_stick_button_pressed = true
					if _get_toggle(_left_stick_button_oneshot): _left_stick_button_toggle = not _left_stick_button_toggle
				else:
					_left_stick_button_oneshot = false
					_left_stick_button_realesed = true
					_left_stick_button_pressed = false
		KEY_G:
			if event.pressed != _right_stick_button_pressed:
				if event.pressed:
					_right_stick_button_oneshot = true
					_right_stick_button_realesed = false
					_right_stick_button_pressed = true
					if _get_toggle(_right_stick_button_oneshot): _right_stick_button_toggle = not _right_stick_button_toggle
				else:
					_right_stick_button_oneshot = false
					_right_stick_button_realesed = true
					_right_stick_button_pressed = false
		_button_a_key: # TODO:
			if event.pressed != _button_a_pressed:
				if event.pressed:
					_button_a_oneshot = true
					_button_a_realesed = false
					_button_a_pressed = true
					if _get_toggle(_button_a_oneshot): _button_a_toggle = not _button_a_toggle
				else:
					_button_a_oneshot = false
					_button_a_realesed = true
					_button_a_pressed = false
		KEY_Z:
			if event.pressed != _button_b_pressed:
				if event.pressed:
					_button_b_oneshot = true
					_button_b_realesed = false
					_button_b_pressed = true
					if _get_toggle(_button_b_oneshot): _button_b_toggle = not _button_b_toggle
				else:
					_button_b_oneshot = false
					_button_b_realesed = true
					_button_b_pressed = false
		KEY_X:
			if event.pressed != _button_x_pressed:
				if event.pressed:
					_button_x_oneshot = true
					_button_x_realesed = false
					_button_x_pressed = true
					if _get_toggle(_button_x_oneshot): _button_x_toggle = not _button_x_toggle
				else:
					_button_x_oneshot = false
					_button_x_realesed = true
					_button_x_pressed = false
		KEY_C:
			if event.pressed != _button_y_pressed:
				if event.pressed:
					_button_y_oneshot = true
					_button_y_realesed = false
					_button_y_pressed = true
					if _get_toggle(_button_y_oneshot): _button_y_toggle = not _button_y_toggle
				else:
					_button_y_oneshot = false
					_button_y_realesed = true
					_button_y_pressed = false
		KEY_UP:
			if event.pressed != _dpad_up_pressed:
				if event.pressed:
					_dpad_up_oneshot = true
					_dpad_up_realesed = false
					_dpad_up_pressed = true
					if _get_toggle(_dpad_up_oneshot): _dpad_up_toggle = not _dpad_up_toggle
				else:
					_dpad_up_oneshot = false
					_dpad_up_realesed = true
					_dpad_up_pressed = false
		KEY_DOWN:
			if event.pressed != _dpad_down_pressed:
				if event.pressed:
					_dpad_down_oneshot = true
					_dpad_down_realesed = false
					_dpad_down_pressed = true
					if _get_toggle(_dpad_down_oneshot): _dpad_down_toggle = not _dpad_down_toggle
				else:
					_dpad_down_oneshot = false
					_dpad_down_realesed = true
					_dpad_down_pressed = false
		KEY_LEFT:
			if event.pressed != _dpad_left_pressed:
				if event.pressed:
					_dpad_left_oneshot = true
					_dpad_left_realesed = false
					_dpad_left_pressed = true
					if _get_toggle(_dpad_left_oneshot): _dpad_left_toggle = not _dpad_left_toggle
				else:
					_dpad_left_oneshot = false
					_dpad_left_realesed = true
					_dpad_left_pressed = false
		KEY_RIGHT:
			if event.pressed != _dpad_right_pressed:
				if event.pressed:
					_dpad_right_oneshot = true
					_dpad_right_realesed = false
					_dpad_right_pressed = true
					if _get_toggle(_dpad_right_oneshot): _dpad_right_toggle = not _dpad_right_toggle
				else:
					_dpad_right_oneshot = false
					_dpad_right_realesed = true
					_dpad_right_pressed = false
		KEY_ENTER:
			if event.pressed != _start_pressed:
				if event.pressed:
					_start_oneshot = true
					_start_realesed = false
					_start_pressed = true
					if _get_toggle(_start_oneshot): _start_toggle = not _start_toggle
				else:
					_start_oneshot = false
					_start_realesed = true
					_start_pressed = false
		KEY_BACKSPACE:
			if event.pressed != _select_pressed:
				if event.pressed:
					_select_oneshot = true
					_select_realesed = false
					_select_pressed = true
					if _get_toggle(_select_oneshot): _select_toggle = not _select_toggle
				else:
					_select_oneshot = false
					_select_realesed = true
					_select_pressed = false
		KEY_TAB:
			if event.pressed:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		KEY_ESCAPE:
			if event.pressed:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		KEY_SHIFT:
			if _shift_pressed != event.pressed:
				_shift_pressed = event.pressed
	pass

func _check_mouse_motion(event: InputEventMouseMotion) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		on_mouse_motion_changed.emit(event.relative)
	pass

func _check_mouse_button(event: InputEventMouseButton) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event.button_index == MOUSE_BUTTON_LEFT:
			on_left_trigger_changed.emit(1.0 if event.pressed else 0.0)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			on_right_trigger_changed.emit(1.0 if event.pressed else 0.0)
	pass
# PRIVATE METHODS **************************************************
