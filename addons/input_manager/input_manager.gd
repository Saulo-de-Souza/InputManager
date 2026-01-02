@tool
@icon("res://addons/input_manager/icon.svg")


class_name InputManager extends Node


#region EXPORTS **********************************************************
@export var canvas_layer: CanvasLayer:
	set(value):
		canvas_layer = value

		if is_node_ready():
			_init_all_touch_buttons()

		update_configuration_warnings()

@export var input_manager_data: InputManagerData:
	set(value):
		input_manager_data = value

		if input_manager_data:
			input_manager_data.init(self)
		else:
			_actions_buttons = {}
			_actions_sticks = {}
			_actions_triggers = {}

		if is_node_ready():
			_init_all_touch_buttons()
			
		update_configuration_warnings()
#endregion EXPORTS *******************************************************


#region SIGNALS **********************************************************
## Emitted when a gamepad is connected or disconnected via USB, Wi-Fi, or Bluetooth.
signal on_device_changed(device: int, connected: bool)

## Emitted when you move the mouse on the screen.
signal on_mouse_motion_changed(value: Vector2)

## Emitted when the left stick gamepad (L) is moved.
signal on_left_stick_changed(value: Vector2, length: float)

## Emitted when the right stick gamepad (R) is moved.
signal on_right_stick_changed(value: Vector2, length: float)

## Emitted when the left trigger button on the gamepad (L2) is pressed.
signal on_left_trigger_changed(length: float)

## Emitted when the left trigger button on the gamepad (R2) is pressed.
signal on_right_trigger_changed(length: float)

## Emitted when the left shoulder button on the gamepad (L1) is pressed.
signal on_left_shoulder_changed(pressed: bool)

## Emitted when the right shoulder button on the gamepad (R1) is pressed.
signal on_right_shoulder_changed(pressed: bool)

## Emitted when the left stick button gamepad (L3) is pressed.
signal on_left_stick_button_changed(pressed: bool)

## Emitted when the right stick button gamepad (R3) is pressed.
signal on_right_stick_button_changed(pressed: bool)

## Emitted when the A button (Xbox) or X button (PS) on the controller is pressed.
signal on_button_a_changed(pressed: bool)

## Emitted when the B button (Xbox) or Circle button (PS) on the controller is pressed.
signal on_button_b_changed(pressed: bool)

## Emitted when the X button (Xbox) or Square button (PS) on the controller is pressed.
signal on_button_x_changed(pressed: bool)

## Emitted when the Y button (Xbox) or Triangle button (PS) on the controller is pressed.
signal on_button_y_changed(pressed: bool)

## Emitted when the diagonal up button on the gamepad is pressed.
signal on_dpad_up_changed(pressed: bool)

## Emitted when the diagonal down button on the gamepad is pressed.
signal on_dpad_down_changed(pressed: bool)

## Emitted when the diagonal left button on the gamepad is pressed.
signal on_dpad_left_changed(pressed: bool)

## Emitted when the diagonal right button on the gamepad is pressed.
signal on_dpad_right_changed(pressed: bool)

## Emitted when the Menu (Xbox) or Options (PS) button on the controller is pressed.
signal on_start_changed(pressed: bool)

## Issued when the View (Xbox) or Share (PS) button on the gamepad is pressed.
signal on_select_changed(pressed: bool)

## Emitted when any action button on the gamepad is pressed. (buttons that return true or false).
signal on_action_button(action_name: String, pressed: bool)

## Emitted when any gamepad trigger button is pressed (buttons that return float like L2 and R2).
signal on_action_trigger(action_name: String, value: float)

## Emitted when the sticks of the gamepad is moved.
signal on_action_stick(action_name: String, value: Vector2)

## Emitted when any stick, button, or trigger on the gamepad is moved or pressed.
signal on_action_changed(action_name: String, valur: Variant)
#endregion SIGNALS *******************************************************


#region PRIVATE PROPERTIES ***********************************************
var _actions_buttons: Dictionary[String, Callable] = {}
var _actions_sticks: Dictionary[String, Callable] = {}
var _actions_triggers: Dictionary[String, Callable] = {}

var _shift_pressed: bool = false:
	set(value):
		_shift_pressed = value
		_left_stick.x = (sign(_left_stick.x) * (0.5 if not _shift_pressed else 1.0))
		_left_stick.y = (sign(_left_stick.y) * (0.5 if not _shift_pressed else 1.0))

# LEFT STICKS
var _left_stick: Vector2 = Vector2.ZERO:
	set(value):
		if value != _left_stick:
			_left_stick = value
			on_left_stick_changed.emit(get_left_stick(), get_left_stick_length())
			if input_manager_data:
				on_action_stick.emit(input_manager_data._left_stick_action_name, get_left_stick())
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
var _left_stick_ui: VirtualJoystick = VirtualJoystick.new()

# RIGHT STICKS
var _right_stick: Vector2 = Vector2.ZERO:
	set(value):
		if value != _right_stick:
			_right_stick = value
			on_right_stick_changed.emit(get_right_stick(), get_right_stick_length())
			if input_manager_data:
				on_action_stick.emit(input_manager_data._right_stick_action_name, get_right_stick())
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
var _right_stick_ui: VirtualJoystick = VirtualJoystick.new()

# TRIGGERS
var _left_trigger: float = 0.0:
	set(value):
		if _left_trigger != value:
			_left_trigger = value
			on_left_trigger_changed.emit(_left_trigger)
			if input_manager_data:
				on_action_trigger.emit(input_manager_data._left_trigger_action_name, value)
var _right_trigger: float = 0.0:
	set(value):
		if _right_trigger != value:
			_right_trigger = value
			on_right_trigger_changed.emit(_right_trigger)
			if input_manager_data:
				on_action_trigger.emit(input_manager_data._right_trigger_action_name, value)
var _button_left_shoulder_touch: TouchScreenButton = TouchScreenButton.new()

# LEFT SHOULDER
var _left_shoulder_pressed: bool = false:
	set(value):
		_left_shoulder_pressed = value
		on_left_shoulder_changed.emit(value)
		if input_manager_data:
			on_action_button.emit(input_manager_data._left_shoulder_action_name, value)
var _left_shoulder_realesed: bool = false
var _left_shoulder_oneshot: bool = false
var _left_shoulder_toggle: bool = false
var _button_left_trigger_touch: TouchScreenButton = TouchScreenButton.new()
var _button_right_trigger_touch: TouchScreenButton = TouchScreenButton.new()

# RIGHT SHOULDER
var _right_shoulder_pressed: bool = false:
	set(value):
		_right_shoulder_pressed = value
		on_right_shoulder_changed.emit(value)
		if input_manager_data:
			on_action_button.emit(input_manager_data._right_shoulder_action_name, value)
var _right_shoulder_realesed: bool = false
var _right_shoulder_oneshot: bool = false
var _right_shoulder_toggle: bool = false
var _button_right_shoulder_touch: TouchScreenButton = TouchScreenButton.new()

# LEFT STICK BUTTON
var _left_stick_button_pressed: bool = false:
	set(value):
		_left_stick_button_pressed = value
		on_left_stick_button_changed.emit(value)
		if input_manager_data:
			on_action_button.emit(input_manager_data._left_stick_button_action_name, value)
var _left_stick_button_realesed: bool = false
var _left_stick_button_oneshot: bool = false
var _left_stick_button_toggle: bool = false
var _button_button_left_stick_touch: TouchScreenButton = TouchScreenButton.new()

# RIGHT STICK BUTTON
var _right_stick_button_pressed: bool = false:
	set(value):
		_right_stick_button_pressed = value
		on_right_stick_button_changed.emit(value)
		if input_manager_data:
			on_action_button.emit(input_manager_data._right_stick_button_action_name, value)
var _right_stick_button_realesed: bool = false
var _right_stick_button_oneshot: bool = false
var _right_stick_button_toggle: bool = false
var _button_button_right_stick_touch: TouchScreenButton = TouchScreenButton.new()

# BUTTON A
var _button_a_pressed: bool = false:
	set(value):
		_button_a_pressed = value
		on_button_a_changed.emit(value)
		if input_manager_data:
			on_action_button.emit(input_manager_data._button_a_action_name, value)
var _button_a_realesed: bool = false
var _button_a_oneshot: bool = false
var _button_a_toggle: bool = false
var _button_a_touch: TouchScreenButton = TouchScreenButton.new()

# BUTTON B
var _button_b_pressed: bool = false:
	set(value):
		_button_b_pressed = value
		on_button_b_changed.emit(value)
		if input_manager_data:
			on_action_button.emit(input_manager_data._button_b_action_name, value)
var _button_b_realesed: bool = false
var _button_b_oneshot: bool = false
var _button_b_toggle: bool = false
var _button_b_touch: TouchScreenButton = TouchScreenButton.new()

# BUTTON X
var _button_x_pressed: bool = false:
	set(value):
		_button_x_pressed = value
		on_button_x_changed.emit(value)
		if input_manager_data:
			on_action_button.emit(input_manager_data._button_x_action_name, value)
var _button_x_realesed: bool = false
var _button_x_oneshot: bool = false
var _button_x_toggle: bool = false
var _button_x_touch: TouchScreenButton = TouchScreenButton.new()

# BUTTON Y
var _button_y_pressed: bool = false:
	set(value):
		_button_y_pressed = value
		on_button_y_changed.emit(value)
		if input_manager_data:
			on_action_button.emit(input_manager_data._button_y_action_name, value)
var _button_y_realesed: bool = false
var _button_y_oneshot: bool = false
var _button_y_toggle: bool = false
var _button_y_touch: TouchScreenButton = TouchScreenButton.new()

# D-PAD UP
var _dpad_up_pressed: bool = false:
	set(value):
		_dpad_up_pressed = value
		on_dpad_up_changed.emit(value)
		if input_manager_data:
			on_action_button.emit(input_manager_data._button_dpad_up_action_name, value)
var _dpad_up_realesed: bool = false
var _dpad_up_oneshot: bool = false
var _dpad_up_toggle: bool = false
var _button_dpad_up_touch: TouchScreenButton = TouchScreenButton.new()

# D-PAD DOW
var _dpad_down_pressed: bool = false:
	set(value):
		_dpad_down_pressed = value
		on_dpad_down_changed.emit(value)
		if input_manager_data:
			on_action_button.emit(input_manager_data._button_dpad_down_action_name, value)
var _dpad_down_realesed: bool = false
var _dpad_down_oneshot: bool = false
var _dpad_down_toggle: bool = false
var _button_dpad_down_touch: TouchScreenButton = TouchScreenButton.new()

# D-PAD LEFT
var _dpad_left_pressed: bool = false:
	set(value):
		_dpad_left_pressed = value
		on_dpad_left_changed.emit(value)
		if input_manager_data:
			on_action_button.emit(input_manager_data._button_dpad_left_action_name, value)
var _dpad_left_realesed: bool = false
var _dpad_left_oneshot: bool = false
var _dpad_left_toggle: bool = false
var _button_dpad_left_touch: TouchScreenButton = TouchScreenButton.new()

# D-PAD RIGHT
var _dpad_right_pressed: bool = false:
	set(value):
		_dpad_right_pressed = value
		on_dpad_right_changed.emit(value)
		if input_manager_data:
			on_action_button.emit(input_manager_data._button_dpad_right_action_name, value)
var _dpad_right_realesed: bool = false
var _dpad_right_oneshot: bool = false
var _dpad_right_toggle: bool = false
var _button_dpad_right_touch: TouchScreenButton = TouchScreenButton.new()

# START
var _start_pressed: bool = false:
	set(value):
		_start_pressed = value
		on_start_changed.emit(value)
		if input_manager_data:
			on_action_button.emit(input_manager_data._button_start_action_name, value)
var _start_realesed: bool = false
var _start_oneshot: bool = false
var _start_toggle: bool = false
var _button_start_touch: TouchScreenButton = TouchScreenButton.new()

# SELECT
var _select_pressed: bool = false:
	set(value):
		_select_pressed = value
		on_select_changed.emit(value)
		if input_manager_data:
			on_action_button.emit(input_manager_data._button_select_action_name, value)
var _select_realesed: bool = false
var _select_oneshot: bool = false
var _select_toggle: bool = false
var _button_select_touch: TouchScreenButton = TouchScreenButton.new()

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
#endregion PRIVATE PROPERTIES *************************************


#region ENGINE METHODS ***************************************************
func _enter_tree() -> void:
	print("enter")
	if input_manager_data:
		input_manager_data.init(self)

		for s in Input.get_signal_connection_list("joy_connection_changed"):
			Input.joy_connection_changed.disconnect(s.callable)
		Input.joy_connection_changed.connect(func(device, connected): on_device_changed.emit(device, connected))
		
		if on_action_button.is_connected(_on_action_changed_intern):
			on_action_button.disconnect(_on_action_changed_intern)
		on_action_button.connect(_on_action_changed_intern)

		if on_action_stick.is_connected(_on_action_changed_intern):
			on_action_stick.disconnect(_on_action_changed_intern)
		on_action_stick.connect(_on_action_changed_intern)

		if on_action_trigger.is_connected(_on_action_changed_intern):
			on_action_trigger.disconnect(_on_action_changed_intern)
		on_action_trigger.connect(_on_action_changed_intern)

		_init_all_touch_buttons()
		
	
func _ready():
	print("ready")
	pass
	

func _exit_tree() -> void:
	print("exit")
	_actions_buttons.clear()
	_actions_sticks.clear()
	_actions_triggers.clear()


func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint(): return

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


func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if not input_manager_data:
		warnings.append("Please configure the Input Manager Data property in the inspector.")
	return warnings
#endregion ENGINE METHODS ************************************************


#region PUBLIC METHODS ***************************************************
# ACTIONS NAME
## Get an action name of type button. Returns a boolean value, and if it doesn't exist, returns false.
func get_action_button(action_name: String) -> bool:
	if not _actions_buttons.has(action_name):
		push_warning("%s mapping does not exist."%action_name)
		return false
	var result = _actions_buttons[action_name].call()
	return result

## Get an action name of type stick. Returns a Vector2, and if it doesn't exist, it will return a Vector.ZERO.
func get_action_stick(action_name: String) -> Vector2:
	if not _actions_sticks.has(action_name):
		push_warning("%s mapping does not exist."%action_name)
		return Vector2.ZERO
	var result = _actions_sticks[action_name].call()
	return result

## Get an action name of type trigger. Returns a float, and if it doesn't exist, it will return 0.0.
func get_action_trigger(action_name: String) -> float:
	if not _actions_triggers.has(action_name):
		push_warning("%s mapping does not exist."%action_name)
		return 0.0
	var result = _actions_triggers[action_name].call()
	return result

## Get any action name (button, trigger, or stick). Returns a boolean if it's an action button, a floating-point number if it's a trigger, or a Vector2 if it's a stick. Returns null if it doesn't exist.
func get_action(action_name) -> Variant:
	var result_buttons = _actions_buttons.has(action_name)
	var result_sticks = _actions_sticks.has(action_name)
	var result_triggers = _actions_triggers.has(action_name)
	return get_action_button(action_name) if result_buttons else get_action_stick(action_name) if result_sticks else get_action_trigger(action_name) if result_triggers else null
		
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

# D-PAD UP
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

# D-PAD DOWN
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

# D-PAD LEFT
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

# D-PAD RIGHT
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

#endregion PUBLIC METHODS ************************************************


#region PRIVATE METHODS **************************************************
func _on_action_changed_intern(action_name: String, value: Variant) -> void:
	on_action_changed.emit(action_name, value)
	
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

## Starts gamepad vibration. You can choose the intensity for each side of the gamepad (left and right) and the duration.
func start_vibration(left_strength: float, right_strength: float, duration: float) -> void:
	if input_manager_data:
		Input.start_joy_vibration(input_manager_data._device, right_strength, left_strength, duration)
	pass

## Stop gamepad vibration.
func stop_vibration() -> void:
	if input_manager_data:
		Input.stop_joy_vibration(input_manager_data._device)
	pass

func _check_left_stick(event: InputEventJoypadMotion) -> void:
	if input_manager_data:
		if event.device == input_manager_data._device:
			if event.axis == JOY_AXIS_LEFT_X:
				_left_axis_h = _apply_deadzone_axis(event.axis_value, input_manager_data._left_stick_deadzone)
			elif event.axis == JOY_AXIS_LEFT_Y:
				_left_axis_v = _apply_deadzone_axis(event.axis_value, input_manager_data._left_stick_deadzone)
	pass

func _check_right_stick(event: InputEventJoypadMotion) -> void:
	if input_manager_data:
		if event.device == input_manager_data._device:
			if event.axis == JOY_AXIS_RIGHT_X:
				_right_axis_h = _apply_deadzone_axis(event.axis_value, input_manager_data._right_stick_deadzone)
			elif event.axis == JOY_AXIS_RIGHT_Y:
				_right_axis_v = _apply_deadzone_axis(event.axis_value, input_manager_data._right_stick_deadzone)
	pass

func _check_left_trigger(event: InputEventJoypadMotion) -> void:
	if input_manager_data:
		if event.device == input_manager_data._device:
			if event.axis == JOY_AXIS_TRIGGER_LEFT:
				_left_trigger = _apply_deadzone_axis(event.axis_value, input_manager_data._left_trigger_deadzone)
	pass

func _check_right_trigger(event: InputEventJoypadMotion) -> void:
	if input_manager_data:
		if event.device == input_manager_data._device:
			if event.axis == JOY_AXIS_TRIGGER_RIGHT:
				_right_trigger = _apply_deadzone_axis(event.axis_value, input_manager_data._right_trigger_deadzone)
	pass

func _check_button_a(event: InputEventJoypadButton) -> void:
	if input_manager_data:
		if input_manager_data._device == event.device:
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
	if input_manager_data:
		if input_manager_data._device == event.device:
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
	if input_manager_data._device == event.device:
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
	if input_manager_data:
		if input_manager_data._device == event.device:
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
	if input_manager_data:
		if input_manager_data._device == event.device:
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
	if input_manager_data:
		if input_manager_data._device == event.device:
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
	if input_manager_data:
		if input_manager_data._device == event.device:
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
	if input_manager_data:
		if input_manager_data._device == event.device:
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
	if input_manager_data:
		if input_manager_data._device == event.device:
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
	if input_manager_data:
		if input_manager_data._device == event.device:
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
	if input_manager_data:
		if input_manager_data._device == event.device:
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
	if input_manager_data:
		if input_manager_data._device == event.device:
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
	if input_manager_data:
		if input_manager_data._device == event.device:
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
	if input_manager_data:
		if input_manager_data._device == event.device:
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
	if not input_manager_data: return

	match event.keycode:
		input_manager_data._left_stick_key_negative_y:
			_key_w_pressed = event.pressed
		input_manager_data._left_stick_key_positive_y:
			_key_s_pressed = event.pressed
		input_manager_data._left_stick_key_negative_x:
			_key_a_pressed = event.pressed
		input_manager_data._left_stick_key_positive_x:
			_key_d_pressed = event.pressed
		input_manager_data._right_stick_key_negative_y:
			_key_i_pressed = event.pressed
		input_manager_data._right_stick_key_negative_x:
			_key_j_pressed = event.pressed
		input_manager_data._right_stick_key_positive_y:
			_key_k_pressed = event.pressed
		input_manager_data._right_stick_key_positive_x:
			_key_l_pressed = event.pressed
		input_manager_data._left_trigger_key:
			_left_trigger = 1.0 if event.pressed else 0.0
		input_manager_data._right_trigger_key:
			_right_trigger = 1.0 if event.pressed else 0.0
		input_manager_data._left_shoulder_key:
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
		input_manager_data._right_shoulder_key:
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
		input_manager_data._left_stick_button_key:
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
		input_manager_data._right_stick_button_key:
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
		input_manager_data._button_a_key:
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
		input_manager_data._button_b_key:
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
		input_manager_data._button_x_key:
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
		input_manager_data._button_y_key:
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
		input_manager_data._button_dpad_up_key:
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
		input_manager_data._button_dpad_down_key:
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
		input_manager_data._button_dpad_left_key:
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
		input_manager_data._button_dpad_right_key:
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
		input_manager_data._button_start_key:
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
		input_manager_data._button_select_key:
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
		input_manager_data._mouse_capture_key:
			if event.pressed:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		input_manager_data._mouse_visble_key:
			if event.pressed:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		input_manager_data._run_key:
			if _shift_pressed != event.pressed:
				_shift_pressed = event.pressed
	pass

func _check_mouse_motion(event: InputEventMouseMotion) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		on_mouse_motion_changed.emit(event.relative)
	pass

func _check_mouse_button(event: InputEventMouseButton) -> void:
	if input_manager_data:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			if event.button_index == input_manager_data._left_trigger_mouse_button:
				on_left_trigger_changed.emit(1.0 if event.pressed else 0.0)
				on_action_trigger.emit(input_manager_data._left_trigger_action_name, 1.0 if event.pressed else 0.0)
			elif event.button_index == input_manager_data._right_trigger_mouse_button:
				on_right_trigger_changed.emit(1.0 if event.pressed else 0.0)
				on_action_trigger.emit(input_manager_data._right_trigger_action_name, 1.0 if event.pressed else 0.0)
	pass

func _init_button_a_touch() -> void:
	if input_manager_data:
		_button_a_touch.texture_normal = input_manager_data._button_a_texture_normal
		_button_a_touch.texture_pressed = input_manager_data._button_a_texture_pressed
		_button_a_touch.global_position = input_manager_data._button_a_position
		_button_a_touch.name = input_manager_data._button_a_action_name
		_button_a_touch.visible = input_manager_data._button_a_touch_visible

	if _button_a_touch.is_inside_tree():
		_button_a_touch.get_parent().remove_child.call_deferred(_button_a_touch)
		await _button_a_touch.tree_exited
		await get_tree().process_frame
		
	for s in _button_a_touch.get_signal_connection_list("pressed"):
		_button_a_touch.pressed.disconnect(s.callable)

	for s in _button_a_touch.get_signal_connection_list("released"):
		_button_a_touch.released.disconnect(s.callable)

	if not input_manager_data:
		return

	_button_a_touch.pressed.connect(func():
		_button_a_oneshot = true
		_button_a_realesed = false
		_button_a_pressed = true
		if _get_toggle(_button_a_oneshot): _button_a_toggle = not _button_a_toggle
		)

	_button_a_touch.released.connect(func():
		_button_a_oneshot = false
		_button_a_realesed = true
		_button_a_pressed = false
		)

	if not _button_a_touch.is_inside_tree():
		if is_instance_valid(canvas_layer):
			canvas_layer.add_child.call_deferred(_button_a_touch)
		else:
			add_child.call_deferred(_button_a_touch)
		await _button_a_touch.tree_entered
		await get_tree().process_frame
	_button_a_touch.position = _position_button_a_touch()

func _init_button_b_touch() -> void:
	if input_manager_data:
		_button_b_touch.texture_normal = input_manager_data._button_b_texture_normal
		_button_b_touch.texture_pressed = input_manager_data._button_b_texture_pressed
		_button_b_touch.global_position = input_manager_data._button_b_position
		_button_b_touch.name = input_manager_data._button_b_action_name
		_button_b_touch.visible = input_manager_data._button_b_touch_visible

	if _button_b_touch.is_inside_tree():
		_button_b_touch.get_parent().remove_child.call_deferred(_button_b_touch)
		await _button_b_touch.tree_exited
		await get_tree().process_frame

	for s in _button_b_touch.get_signal_connection_list("pressed"):
		_button_b_touch.pressed.disconnect(s.callable)

	for s in _button_b_touch.get_signal_connection_list("released"):
		_button_b_touch.released.disconnect(s.callable)

	if not input_manager_data:
		return

	_button_b_touch.pressed.connect(func():
		_button_b_oneshot = true
		_button_b_realesed = false
		_button_b_pressed = true
		if _get_toggle(_button_b_oneshot): _button_b_toggle = not _button_b_toggle
		)

	_button_b_touch.released.connect(func():
		_button_b_oneshot = false
		_button_b_realesed = true
		_button_b_pressed = false
		)
		
	if not _button_b_touch.is_inside_tree():
		if is_instance_valid(canvas_layer):
			canvas_layer.add_child.call_deferred(_button_b_touch)
		else:
			add_child.call_deferred(_button_b_touch)
			await _button_b_touch.tree_entered
			await get_tree().process_frame
	_button_b_touch.position = _position_button_b_touch()

func _init_button_x_touch() -> void:
	if input_manager_data:
		_button_x_touch.texture_normal = input_manager_data._button_x_texture_normal
		_button_x_touch.texture_pressed = input_manager_data._button_x_texture_pressed
		_button_x_touch.global_position = input_manager_data._button_x_position
		_button_x_touch.name = input_manager_data._button_x_action_name
		_button_x_touch.visible = input_manager_data._button_x_touch_visible

	if _button_x_touch.is_inside_tree():
		_button_x_touch.get_parent().remove_child.call_deferred(_button_x_touch)
		await _button_x_touch.tree_exited
		await get_tree().process_frame

	for s in _button_x_touch.get_signal_connection_list("pressed"):
		_button_x_touch.pressed.disconnect(s.callable)

	for s in _button_x_touch.get_signal_connection_list("released"):
		_button_x_touch.released.disconnect(s.callable)

	if not input_manager_data:
		return

	_button_x_touch.pressed.connect(func():
		_button_x_oneshot = true
		_button_x_realesed = false
		_button_x_pressed = true
		if _get_toggle(_button_x_oneshot): _button_x_toggle = not _button_x_toggle
		)

	_button_x_touch.released.connect(func():
		_button_x_oneshot = false
		_button_x_realesed = true
		_button_x_pressed = false
		)
		
	if not _button_x_touch.is_inside_tree():
		if is_instance_valid(canvas_layer):
			canvas_layer.add_child.call_deferred(_button_x_touch)
		else:
			add_child.call_deferred(_button_x_touch)
			await _button_x_touch.tree_entered
			await get_tree().process_frame
	_button_x_touch.position = _position_button_x_touch()

func _init_button_y_touch() -> void:
	if input_manager_data:
		_button_y_touch.texture_normal = input_manager_data._button_y_texture_normal
		_button_y_touch.texture_pressed = input_manager_data._button_y_texture_pressed
		_button_y_touch.global_position = input_manager_data._button_y_position
		_button_y_touch.name = input_manager_data._button_y_action_name
		_button_y_touch.visible = input_manager_data._button_y_touch_visible

	if _button_y_touch.is_inside_tree():
		_button_y_touch.get_parent().remove_child.call_deferred(_button_y_touch)
		await _button_y_touch.tree_exited
		await get_tree().process_frame

	for s in _button_y_touch.get_signal_connection_list("pressed"):
		_button_y_touch.pressed.disconnect(s.callable)

	for s in _button_y_touch.get_signal_connection_list("released"):
		_button_y_touch.released.disconnect(s.callable)

	if not input_manager_data:
		return
		
	_button_y_touch.pressed.connect(func():
		_button_y_oneshot = true
		_button_y_realesed = false
		_button_y_pressed = true
		if _get_toggle(_button_y_oneshot): _button_y_toggle = not _button_y_toggle
		)

	_button_y_touch.released.connect(func():
		_button_y_oneshot = false
		_button_y_realesed = true
		_button_y_pressed = false
		)
		
	if not _button_y_touch.is_inside_tree():
		if is_instance_valid(canvas_layer):
			canvas_layer.add_child.call_deferred(_button_y_touch)
		else:
			add_child.call_deferred(_button_y_touch)
			await _button_y_touch.tree_entered
			await get_tree().process_frame
	_button_y_touch.position = _position_button_y_touch()

func _init_button_dpad_up_touch() -> void:
	if input_manager_data:
		_button_dpad_up_touch.texture_normal = input_manager_data._button_dpad_up_texture_normal
		_button_dpad_up_touch.texture_pressed = input_manager_data._button_dpad_up_texture_pressed
		_button_dpad_up_touch.global_position = input_manager_data._button_dpad_up_position
		_button_dpad_up_touch.name = input_manager_data._button_dpad_up_action_name
		_button_dpad_up_touch.visible = input_manager_data._button_dpad_up_touch_visible

	if _button_dpad_up_touch.is_inside_tree():
		_button_dpad_up_touch.get_parent().remove_child.call_deferred(_button_dpad_up_touch)
		await _button_dpad_up_touch.tree_exited
		await get_tree().process_frame

	for s in _button_dpad_up_touch.get_signal_connection_list("pressed"):
		_button_dpad_up_touch.pressed.disconnect(s.callable)

	for s in _button_dpad_up_touch.get_signal_connection_list("released"):
		_button_dpad_up_touch.released.disconnect(s.callable)

	if not input_manager_data:
		return

	_button_dpad_up_touch.pressed.connect(func():
		_dpad_up_oneshot = true
		_dpad_up_realesed = false
		_dpad_up_pressed = true
		if _get_toggle(_dpad_up_oneshot): _dpad_up_toggle = not _dpad_up_toggle
		)

	_button_dpad_up_touch.released.connect(func():
		_dpad_up_oneshot = false
		_dpad_up_realesed = true
		_dpad_up_pressed = false
		)

	if not _button_dpad_up_touch.is_inside_tree():
		if is_instance_valid(canvas_layer):
			canvas_layer.add_child.call_deferred(_button_dpad_up_touch)
		else:
			add_child.call_deferred(_button_dpad_up_touch)
			await _button_dpad_up_touch.tree_entered
			await get_tree().process_frame
	_button_dpad_up_touch.position = _position_button_dpad_up_touch()

func _init_button_dpad_down_touch() -> void:
	if input_manager_data:
		_button_dpad_down_touch.texture_normal = input_manager_data._button_dpad_down_texture_normal
		_button_dpad_down_touch.texture_pressed = input_manager_data._button_dpad_down_texture_pressed
		_button_dpad_down_touch.global_position = input_manager_data._button_dpad_down_position
		_button_dpad_down_touch.name = input_manager_data._button_dpad_down_action_name
		_button_dpad_down_touch.visible = input_manager_data._button_dpad_down_touch_visible

	if _button_dpad_down_touch.is_inside_tree():
		_button_dpad_down_touch.get_parent().remove_child.call_deferred(_button_dpad_down_touch)
		await _button_dpad_down_touch.tree_exited
		await get_tree().process_frame

	for s in _button_dpad_down_touch.get_signal_connection_list("pressed"):
		_button_dpad_down_touch.pressed.disconnect(s.callable)

	for s in _button_dpad_down_touch.get_signal_connection_list("released"):
		_button_dpad_down_touch.released.disconnect(s.callable)

	if not input_manager_data:
		return
		
	_button_dpad_down_touch.pressed.connect(func():
		_dpad_down_oneshot = true
		_dpad_down_realesed = false
		_dpad_down_pressed = true
		if _get_toggle(_dpad_down_oneshot): _dpad_down_toggle = not _dpad_down_toggle
		)

	_button_dpad_down_touch.released.connect(func():
		_dpad_down_oneshot = false
		_dpad_down_realesed = true
		_dpad_down_pressed = false
		)

	if not _button_dpad_down_touch.is_inside_tree():
		if is_instance_valid(canvas_layer):
			canvas_layer.add_child.call_deferred(_button_dpad_down_touch)
		else:
			add_child.call_deferred(_button_dpad_down_touch)
			await _button_dpad_down_touch.tree_entered
			await get_tree().process_frame
	_button_dpad_down_touch.position = _position_button_dpad_down_touch()

func _init_button_dpad_left_touch() -> void:
	if input_manager_data:
		_button_dpad_left_touch.texture_normal = input_manager_data._button_dpad_left_texture_normal
		_button_dpad_left_touch.texture_pressed = input_manager_data._button_dpad_left_texture_pressed
		_button_dpad_left_touch.global_position = input_manager_data._button_dpad_left_position
		_button_dpad_left_touch.name = input_manager_data._button_dpad_left_action_name
		_button_dpad_left_touch.visible = input_manager_data._button_dpad_left_touch_visible

	if _button_dpad_left_touch.is_inside_tree():
		_button_dpad_left_touch.get_parent().remove_child.call_deferred(_button_dpad_left_touch)
		await _button_dpad_left_touch.tree_exited
		await get_tree().process_frame

	for s in _button_dpad_left_touch.get_signal_connection_list("pressed"):
		_button_dpad_left_touch.pressed.disconnect(s.callable)

	for s in _button_dpad_left_touch.get_signal_connection_list("released"):
		_button_dpad_left_touch.released.disconnect(s.callable)

	if not input_manager_data:
		return

	_button_dpad_left_touch.pressed.connect(func():
		_dpad_left_oneshot = true
		_dpad_left_realesed = false
		_dpad_left_pressed = true
		if _get_toggle(_dpad_left_oneshot): _dpad_left_toggle = not _dpad_left_toggle
		)

	_button_dpad_left_touch.released.connect(func():
		_dpad_left_oneshot = false
		_dpad_left_realesed = true
		_dpad_left_pressed = false
		)

	if not _button_dpad_left_touch.is_inside_tree():
		if is_instance_valid(canvas_layer):
			canvas_layer.add_child.call_deferred(_button_dpad_left_touch)
		else:
			add_child.call_deferred(_button_dpad_left_touch)
			await _button_dpad_left_touch.tree_entered
			await get_tree().process_frame
	_button_dpad_left_touch.position = _position_button_dpad_left_touch()

func _init_button_dpad_right_touch() -> void:
	if input_manager_data:
		_button_dpad_right_touch.texture_normal = input_manager_data._button_dpad_right_texture_normal
		_button_dpad_right_touch.texture_pressed = input_manager_data._button_dpad_right_texture_pressed
		_button_dpad_right_touch.global_position = input_manager_data._button_dpad_right_position
		_button_dpad_right_touch.name = input_manager_data._button_dpad_right_action_name
		_button_dpad_right_touch.visible = input_manager_data._button_dpad_right_touch_visible

	if _button_dpad_right_touch.is_inside_tree():
		_button_dpad_right_touch.get_parent().remove_child.call_deferred(_button_dpad_right_touch)
		await _button_dpad_right_touch.tree_exited
		await get_tree().process_frame

	for s in _button_dpad_right_touch.get_signal_connection_list("pressed"):
		_button_dpad_right_touch.pressed.disconnect(s.callable)

	for s in _button_dpad_right_touch.get_signal_connection_list("released"):
		_button_dpad_right_touch.released.disconnect(s.callable)

	if not input_manager_data:
		return

	_button_dpad_right_touch.pressed.connect(func():
		_dpad_right_oneshot = true
		_dpad_right_realesed = false
		_dpad_right_pressed = true
		if _get_toggle(_dpad_right_oneshot): _dpad_right_toggle = not _dpad_right_toggle
		)

	_button_dpad_right_touch.released.connect(func():
		_dpad_right_oneshot = false
		_dpad_right_realesed = true
		_dpad_right_pressed = false
		)

	if not _button_dpad_right_touch.is_inside_tree():
		if is_instance_valid(canvas_layer):
			canvas_layer.add_child.call_deferred(_button_dpad_right_touch)
		else:
			add_child.call_deferred(_button_dpad_right_touch)
			await _button_dpad_right_touch.tree_entered
			await get_tree().process_frame
	_button_dpad_right_touch.position = _position_button_dpad_right_touch()

func _init_button_start_touch() -> void:
	if input_manager_data:
		_button_start_touch.texture_normal = input_manager_data._button_start_texture_normal
		_button_start_touch.texture_pressed = input_manager_data._button_start_texture_pressed
		_button_start_touch.global_position = input_manager_data._button_start_position
		_button_start_touch.name = input_manager_data._button_start_action_name
		_button_start_touch.visible = input_manager_data._button_start_touch_visible

	if _button_start_touch.is_inside_tree():
		_button_start_touch.get_parent().remove_child.call_deferred(_button_start_touch)
		await _button_start_touch.tree_exited
		await get_tree().process_frame

	for s in _button_start_touch.get_signal_connection_list("pressed"):
		_button_start_touch.pressed.disconnect(s.callable)

	for s in _button_start_touch.get_signal_connection_list("released"):
		_button_start_touch.released.disconnect(s.callable)

	if not input_manager_data:
		return

	_button_start_touch.pressed.connect(func():
		_start_oneshot = true
		_start_realesed = false
		_start_pressed = true
		if _get_toggle(_start_oneshot): _start_toggle = not _start_toggle
		)

	_button_start_touch.released.connect(func():
		_start_oneshot = false
		_start_realesed = true
		_start_pressed = false
		)

	if not _button_start_touch.is_inside_tree():
		if is_instance_valid(canvas_layer):
			canvas_layer.add_child.call_deferred(_button_start_touch)
		else:
			add_child.call_deferred(_button_start_touch)
			await _button_start_touch.tree_entered
			await get_tree().process_frame
	_button_start_touch.position = _position_button_start_touch()

func _init_button_select_touch() -> void:
	if input_manager_data:
		_button_select_touch.texture_normal = input_manager_data._button_select_texture_normal
		_button_select_touch.texture_pressed = input_manager_data._button_select_texture_pressed
		_button_select_touch.global_position = input_manager_data._button_select_position
		_button_select_touch.name = input_manager_data._button_select_action_name
		_button_select_touch.visible = input_manager_data._button_select_touch_visible

	if _button_select_touch.is_inside_tree():
		_button_select_touch.get_parent().remove_child.call_deferred(_button_select_touch)
		await _button_select_touch.tree_exited
		await get_tree().process_frame

	for s in _button_select_touch.get_signal_connection_list("pressed"):
		_button_select_touch.pressed.disconnect(s.callable)

	for s in _button_select_touch.get_signal_connection_list("released"):
		_button_select_touch.released.disconnect(s.callable)

	if not input_manager_data:
		return

	_button_select_touch.pressed.connect(func():
		_select_oneshot = true
		_select_realesed = false
		_select_pressed = true
		if _get_toggle(_select_oneshot): _select_toggle = not _select_toggle
		)

	_button_select_touch.released.connect(func():
		_select_oneshot = false
		_select_realesed = true
		_select_pressed = false
		)

	if not _button_select_touch.is_inside_tree():
		if is_instance_valid(canvas_layer):
			canvas_layer.add_child.call_deferred(_button_select_touch)
		else:
			add_child.call_deferred(_button_select_touch)
			await _button_select_touch.tree_entered
			await get_tree().process_frame
	_button_select_touch.position = _position_button_select_touch()

func _init_button_left_shoulder_touch() -> void:
	if input_manager_data:
		_button_left_shoulder_touch.texture_normal = input_manager_data._left_shoulder_texture_normal
		_button_left_shoulder_touch.texture_pressed = input_manager_data._left_shoulder_texture_pressed
		_button_left_shoulder_touch.global_position = input_manager_data._left_shoulder_position
		_button_left_shoulder_touch.name = input_manager_data._left_shoulder_action_name
		_button_left_shoulder_touch.visible = input_manager_data._left_shoulder_touch_visible

	if _button_left_shoulder_touch.is_inside_tree():
		_button_left_shoulder_touch.get_parent().remove_child.call_deferred(_button_left_shoulder_touch)
		await _button_left_shoulder_touch.tree_exited
		await get_tree().process_frame

	for s in _button_left_shoulder_touch.get_signal_connection_list("pressed"):
		_button_left_shoulder_touch.pressed.disconnect(s.callable)

	for s in _button_left_shoulder_touch.get_signal_connection_list("released"):
		_button_left_shoulder_touch.released.disconnect(s.callable)

	if not input_manager_data:
		return

	_button_left_shoulder_touch.pressed.connect(func():
		_left_shoulder_oneshot = true
		_left_shoulder_realesed = false
		_left_shoulder_pressed = true
		if _get_toggle(_left_shoulder_oneshot): _left_shoulder_toggle = not _left_shoulder_toggle
		)

	_button_left_shoulder_touch.released.connect(func():
		_left_shoulder_oneshot = false
		_left_shoulder_realesed = true
		_left_shoulder_pressed = false
		)

	if not _button_left_shoulder_touch.is_inside_tree():
		if is_instance_valid(canvas_layer):
			canvas_layer.add_child.call_deferred(_button_left_shoulder_touch)
		else:
			add_child.call_deferred(_button_left_shoulder_touch)
			await _button_left_shoulder_touch.tree_entered
			await get_tree().process_frame
	_button_left_shoulder_touch.position = _position_button_left_shoulder_touch()

func _init_button_right_shoulder_touch() -> void:
	if input_manager_data:
		_button_right_shoulder_touch.texture_normal = input_manager_data._right_shoulder_texture_normal
		_button_right_shoulder_touch.texture_pressed = input_manager_data._right_shoulder_texture_pressed
		_button_right_shoulder_touch.global_position = input_manager_data._right_shoulder_position
		_button_right_shoulder_touch.name = input_manager_data._right_shoulder_action_name
		_button_right_shoulder_touch.visible = input_manager_data._right_shoulder_touch_visible

	if _button_right_shoulder_touch.is_inside_tree():
		_button_right_shoulder_touch.get_parent().remove_child.call_deferred(_button_right_shoulder_touch)
		await _button_right_shoulder_touch.tree_exited
		await get_tree().process_frame

	for s in _button_right_shoulder_touch.get_signal_connection_list("pressed"):
		_button_right_shoulder_touch.pressed.disconnect(s.callable)

	for s in _button_right_shoulder_touch.get_signal_connection_list("released"):
		_button_right_shoulder_touch.released.disconnect(s.callable)

	if not input_manager_data:
		return

	_button_right_shoulder_touch.pressed.connect(func():
		_right_shoulder_oneshot = true
		_right_shoulder_realesed = false
		_right_shoulder_pressed = true
		if _get_toggle(_right_shoulder_oneshot): _right_shoulder_toggle = not _right_shoulder_toggle
		)

	_button_right_shoulder_touch.released.connect(func():
		_right_shoulder_oneshot = false
		_right_shoulder_realesed = true
		_right_shoulder_pressed = false
		)

	if not _button_right_shoulder_touch.is_inside_tree():
		if is_instance_valid(canvas_layer):
			canvas_layer.add_child.call_deferred(_button_right_shoulder_touch)
		else:
			add_child.call_deferred(_button_right_shoulder_touch)
			await _button_right_shoulder_touch.tree_entered
			await get_tree().process_frame
	_button_right_shoulder_touch.position = _position_button_right_shoulder_touch()

func _init_button_button_left_stick_touch() -> void:
	if input_manager_data:
		_button_button_left_stick_touch.texture_normal = input_manager_data._left_stick_button_texture_normal
		_button_button_left_stick_touch.texture_pressed = input_manager_data._left_stick_button_texture_pressed
		_button_button_left_stick_touch.global_position = input_manager_data._left_stick_button_position
		_button_button_left_stick_touch.name = input_manager_data._left_stick_button_action_name
		_button_button_left_stick_touch.visible = input_manager_data._left_stick_button_touch_visible

	if _button_button_left_stick_touch.is_inside_tree():
		_button_button_left_stick_touch.get_parent().remove_child.call_deferred(_button_button_left_stick_touch)
		await _button_button_left_stick_touch.tree_exited
		await get_tree().process_frame

	for s in _button_button_left_stick_touch.get_signal_connection_list("pressed"):
		_button_button_left_stick_touch.pressed.disconnect(s.callable)

	for s in _button_button_left_stick_touch.get_signal_connection_list("released"):
		_button_button_left_stick_touch.released.disconnect(s.callable)

	if not input_manager_data:
		return

	_button_button_left_stick_touch.pressed.connect(func():
		_left_stick_button_oneshot = true
		_left_stick_button_realesed = false
		_left_stick_button_pressed = true
		if _get_toggle(_left_stick_button_oneshot): _left_stick_button_toggle = not _left_stick_button_toggle
		)

	_button_button_left_stick_touch.released.connect(func():
		_left_stick_button_oneshot = false
		_left_stick_button_realesed = true
		_left_stick_button_pressed = false
		)

	if not _button_button_left_stick_touch.is_inside_tree():
		if is_instance_valid(canvas_layer):
			canvas_layer.add_child.call_deferred(_button_button_left_stick_touch)
		else:
			add_child.call_deferred(_button_button_left_stick_touch)
			await _button_button_left_stick_touch.tree_entered
			await get_tree().process_frame
	_button_button_left_stick_touch.position = _position_button_left_stick_touch()

func _init_button_button_right_stick_touch() -> void:
	if input_manager_data:
		_button_button_right_stick_touch.texture_normal = input_manager_data._right_stick_button_texture_normal
		_button_button_right_stick_touch.texture_pressed = input_manager_data._right_stick_button_texture_pressed
		_button_button_right_stick_touch.global_position = input_manager_data._right_stick_button_position
		_button_button_right_stick_touch.name = input_manager_data._right_stick_button_action_name
		_button_button_right_stick_touch.visible = input_manager_data._right_stick_button_touch_visible

	if _button_button_right_stick_touch.is_inside_tree():
		_button_button_right_stick_touch.get_parent().remove_child.call_deferred(_button_button_right_stick_touch)
		await _button_button_right_stick_touch.tree_exited
		await get_tree().process_frame

	for s in _button_button_right_stick_touch.get_signal_connection_list("pressed"):
		_button_button_right_stick_touch.pressed.disconnect(s.callable)

	for s in _button_button_right_stick_touch.get_signal_connection_list("released"):
		_button_button_right_stick_touch.released.disconnect(s.callable)

	if not input_manager_data:
		return

	_button_button_right_stick_touch.pressed.connect(func():
		_right_stick_button_oneshot = true
		_right_stick_button_realesed = false
		_right_stick_button_pressed = true
		if _get_toggle(_right_stick_button_oneshot): _right_stick_button_toggle = not _right_stick_button_toggle
		)

	_button_button_right_stick_touch.released.connect(func():
		_right_stick_button_oneshot = false
		_right_stick_button_realesed = true
		_right_stick_button_pressed = false
		)

	if not _button_button_right_stick_touch.is_inside_tree():
		if is_instance_valid(canvas_layer):
			canvas_layer.add_child.call_deferred(_button_button_right_stick_touch)
		else:
			add_child.call_deferred(_button_button_right_stick_touch)
			await _button_button_right_stick_touch.tree_entered
			await get_tree().process_frame
	_button_button_right_stick_touch.position = _position_button_right_stick_touch()

func _init_button_left_trigger_touch() -> void:
	if input_manager_data:
		_button_left_trigger_touch.texture_normal = input_manager_data._left_trigger_texture_normal
		_button_left_trigger_touch.texture_pressed = input_manager_data._left_trigger_texture_pressed
		_button_left_trigger_touch.global_position = input_manager_data._left_trigger_position
		_button_left_trigger_touch.name = input_manager_data._left_trigger_action_name
		_button_left_trigger_touch.visible = input_manager_data._left_trigger_touch_visible

	if _button_left_trigger_touch.is_inside_tree():
		_button_left_trigger_touch.get_parent().remove_child.call_deferred(_button_left_trigger_touch)
		await _button_left_trigger_touch.tree_exited
		await get_tree().process_frame

	for s in _button_left_trigger_touch.get_signal_connection_list("pressed"):
		_button_left_trigger_touch.pressed.disconnect(s.callable)

	for s in _button_left_trigger_touch.get_signal_connection_list("released"):
		_button_left_trigger_touch.released.disconnect(s.callable)

	_button_left_trigger_touch.pressed.connect(func():
		_left_trigger = 1
		)

	_button_left_trigger_touch.released.connect(func():
		_left_trigger = 0
		)

	if not input_manager_data:
		return

	if not _button_left_trigger_touch.is_inside_tree():
		if is_instance_valid(canvas_layer):
			canvas_layer.add_child.call_deferred(_button_left_trigger_touch)
		else:
			add_child.call_deferred(_button_left_trigger_touch)
			await _button_left_trigger_touch.tree_entered
			await get_tree().process_frame
	_button_left_trigger_touch.position = _position_button_left_trigger_touch()

func _init_button_right_trigger_touch() -> void:
	if input_manager_data:
		_button_right_trigger_touch.texture_normal = input_manager_data._right_trigger_texture_normal
		_button_right_trigger_touch.texture_pressed = input_manager_data._right_trigger_texture_pressed
		_button_right_trigger_touch.global_position = input_manager_data._right_trigger_position
		_button_right_trigger_touch.name = input_manager_data._right_trigger_action_name
		_button_right_trigger_touch.visible = input_manager_data._right_trigger_touch_visible

	if _button_right_trigger_touch.is_inside_tree():
		_button_right_trigger_touch.get_parent().remove_child.call_deferred(_button_right_trigger_touch)
		await _button_right_trigger_touch.tree_exited
		await get_tree().process_frame

	for s in _button_right_trigger_touch.get_signal_connection_list("pressed"):
		_button_right_trigger_touch.pressed.disconnect(s.callable)

	for s in _button_right_trigger_touch.get_signal_connection_list("released"):
		_button_right_trigger_touch.released.disconnect(s.callable)

	_button_right_trigger_touch.pressed.connect(func():
		_right_trigger = 1
		)

	_button_right_trigger_touch.released.connect(func():
		_right_trigger = 0
		)

	if not input_manager_data:
		return

	if not _button_right_trigger_touch.is_inside_tree():
		if is_instance_valid(canvas_layer):
			canvas_layer.add_child.call_deferred(_button_right_trigger_touch)
		else:
			add_child.call_deferred(_button_right_trigger_touch)
			await _button_right_trigger_touch.tree_entered
			await get_tree().process_frame
	_button_right_trigger_touch.position = _position_button_right_trigger_touch()

func _init_left_stick_ui() -> void:
	if input_manager_data:
		_left_stick_ui.active = input_manager_data._left_stick_ui_active
		_left_stick_ui.deadzone = input_manager_data._left_stick_ui_deadzone
		_left_stick_ui.scale_factor = input_manager_data._left_stick_ui_scale_factor
		_left_stick_ui.only_mobile = input_manager_data._left_stick_ui_only_mobile
		_left_stick_ui.joystick_use_textures = input_manager_data._left_stick_ui_joystick_use_textures
		_left_stick_ui.joystick_preset_texture = input_manager_data._left_stick_ui_joystick_preset_texture
		_left_stick_ui.joystick_texture = input_manager_data._left_stick_ui_joystick_texture
		_left_stick_ui.joystick_color = input_manager_data._left_stick_ui_joystick_color
		_left_stick_ui.joystick_opacity = input_manager_data._left_stick_ui_joystick_opacity
		_left_stick_ui.joystick_border = input_manager_data._left_stick_ui_joystick_border
		_left_stick_ui.stick_use_textures = input_manager_data._left_stick_ui_stick_use_textures
		_left_stick_ui.stick_preset_texture = input_manager_data._left_stick_ui_stick_preset_texture
		_left_stick_ui.stick_texture = input_manager_data._left_stick_ui_stick_texture
		_left_stick_ui.stick_color = input_manager_data._left_stick_ui_stick_color
		_left_stick_ui.stick_opacity = input_manager_data._left_stick_ui_stick_opacity

	if _left_stick_ui.is_inside_tree():
		_left_stick_ui.get_parent().remove_child.call_deferred(_left_stick_ui)
		await _left_stick_ui.tree_exited
		await get_tree().process_frame

	if not input_manager_data:
		return

	for s in _left_stick_ui.get_signal_connection_list("analogic_changed"):
		_left_stick_ui.analogic_changed.disconnect(s.callable)

	_left_stick_ui.analogic_changed.connect(func(value: Vector2, distance: float, angle: float, angle_clockwise: float, angle_not_clockwise: float):
		_left_stick = value
		)


	if not _left_stick_ui.is_inside_tree():
		if is_instance_valid(canvas_layer):
			canvas_layer.add_child.call_deferred(_left_stick_ui)
		else:
			add_child.call_deferred(_left_stick_ui)
			await _left_stick_ui.tree_entered
			await get_tree().process_frame
	_left_stick_ui.position = _position_left_stick_ui()
	
func _init_right_stick_ui() -> void:
	if input_manager_data:
		_right_stick_ui.active = input_manager_data._right_stick_ui_active
		_right_stick_ui.deadzone = input_manager_data._right_stick_ui_deadzone
		_right_stick_ui.scale_factor = input_manager_data._right_stick_ui_scale_factor
		_right_stick_ui.only_mobile = input_manager_data._right_stick_ui_only_mobile
		_right_stick_ui.joystick_use_textures = input_manager_data._right_stick_ui_joystick_use_textures
		_right_stick_ui.joystick_preset_texture = input_manager_data._right_stick_ui_joystick_preset_texture
		_right_stick_ui.joystick_texture = input_manager_data._right_stick_ui_joystick_texture
		_right_stick_ui.joystick_color = input_manager_data._right_stick_ui_joystick_color
		_right_stick_ui.joystick_opacity = input_manager_data._right_stick_ui_joystick_opacity
		_right_stick_ui.joystick_border = input_manager_data._right_stick_ui_joystick_border
		_right_stick_ui.stick_use_textures = input_manager_data._right_stick_ui_stick_use_textures
		_right_stick_ui.stick_preset_texture = input_manager_data._right_stick_ui_stick_preset_texture
		_right_stick_ui.stick_texture = input_manager_data._right_stick_ui_stick_texture
		_right_stick_ui.stick_color = input_manager_data._right_stick_ui_stick_color
		_right_stick_ui.stick_opacity = input_manager_data._right_stick_ui_stick_opacity

	if _right_stick_ui.is_inside_tree():
		_right_stick_ui.get_parent().remove_child.call_deferred(_right_stick_ui)
		await _right_stick_ui.tree_exited
		await get_tree().process_frame

	if not input_manager_data:
		return

	for s in _right_stick_ui.get_signal_connection_list("analogic_changed"):
		_right_stick_ui.analogic_changed.disconnect(s.callable)

	_right_stick_ui.analogic_changed.connect(func(value: Vector2, distance: float, angle: float, angle_clockwise: float, angle_not_clockwise: float):
		_right_stick = value
		)


	if not _right_stick_ui.is_inside_tree():
		if is_instance_valid(canvas_layer):
			canvas_layer.add_child.call_deferred(_right_stick_ui)
		else:
			add_child.call_deferred(_right_stick_ui)
			await _right_stick_ui.tree_entered
			await get_tree().process_frame
	_right_stick_ui.position = _position_right_stick_ui()

func _init_all_touch_buttons() -> void:
	await get_tree().process_frame
	_init_button_a_touch()
	_init_button_b_touch()
	_init_button_x_touch()
	_init_button_y_touch()
	_init_button_dpad_up_touch()
	_init_button_dpad_down_touch()
	_init_button_dpad_left_touch()
	_init_button_dpad_right_touch()
	_init_button_start_touch()
	_init_button_select_touch()
	_init_button_left_shoulder_touch()
	_init_button_right_shoulder_touch()
	_init_button_button_left_stick_touch()
	_init_button_button_right_stick_touch()
	_init_button_left_trigger_touch()
	_init_button_right_trigger_touch()
	_init_left_stick_ui()
	_init_right_stick_ui()

func _position_button_a_touch() -> Vector2:
	var screen_size: Vector2 = owner.get_viewport().get_visible_rect().size
	return screen_size - Vector2(100, 0) + input_manager_data._button_a_position + input_manager_data.POSITION_BUTTON_ABXY_OFFSET

func _position_button_b_touch() -> Vector2:
	var screen_size: Vector2 = owner.get_viewport().get_visible_rect().size
	return screen_size - Vector2(150, 100) + input_manager_data._button_b_position + input_manager_data.POSITION_BUTTON_ABXY_OFFSET

func _position_button_x_touch() -> Vector2:
	var screen_size: Vector2 = owner.get_viewport().get_visible_rect().size
	return screen_size - Vector2(50, 100) + input_manager_data._button_x_position + input_manager_data.POSITION_BUTTON_ABXY_OFFSET

func _position_button_y_touch() -> Vector2:
	var screen_size: Vector2 = owner.get_viewport().get_visible_rect().size
	return screen_size - Vector2(0, 0) + input_manager_data._button_y_position + input_manager_data.POSITION_BUTTON_ABXY_OFFSET

func _position_button_dpad_up_touch() -> Vector2:
	var screen_size: Vector2 = owner.get_viewport().get_visible_rect().size
	return Vector2(75, screen_size.y - 150) + input_manager_data._button_dpad_up_position + input_manager_data.POSITION_BUTTON_DPADS_OFFSET

func _position_button_dpad_down_touch() -> Vector2:
	var screen_size: Vector2 = owner.get_viewport().get_visible_rect().size
	return Vector2(75, screen_size.y - 0) + input_manager_data._button_dpad_down_position + input_manager_data.POSITION_BUTTON_DPADS_OFFSET

func _position_button_dpad_left_touch() -> Vector2:
	var screen_size: Vector2 = owner.get_viewport().get_visible_rect().size
	return Vector2(0, screen_size.y - 75) + input_manager_data._button_dpad_left_position + input_manager_data.POSITION_BUTTON_DPADS_OFFSET

func _position_button_dpad_right_touch() -> Vector2:
	var screen_size: Vector2 = owner.get_viewport().get_visible_rect().size
	return Vector2(150, screen_size.y - 75) + input_manager_data._button_dpad_right_position + input_manager_data.POSITION_BUTTON_DPADS_OFFSET

func _position_button_left_shoulder_touch() -> Vector2:
	var screen_size: Vector2 = owner.get_viewport().get_visible_rect().size
	return Vector2(150, screen_size.y - 675) + input_manager_data._left_shoulder_position + input_manager_data.POSITION_BUTTON_TRIGGERS_SHOULDERS_OFFSET

func _position_button_right_shoulder_touch() -> Vector2:
	var screen_size: Vector2 = owner.get_viewport().get_visible_rect().size
	return Vector2(screen_size.x - 150, screen_size.y - 675) + input_manager_data._right_shoulder_position + input_manager_data.POSITION_BUTTON_TRIGGERS_SHOULDERS_OFFSET

func _position_button_left_trigger_touch() -> Vector2:
	var screen_size: Vector2 = owner.get_viewport().get_visible_rect().size
	return Vector2(150, screen_size.y - 575) + input_manager_data._left_trigger_position + input_manager_data.POSITION_BUTTON_TRIGGERS_SHOULDERS_OFFSET

func _position_button_right_trigger_touch() -> Vector2:
	var screen_size: Vector2 = owner.get_viewport().get_visible_rect().size
	return Vector2(screen_size.x - 150, screen_size.y - 575) + input_manager_data._right_trigger_position + input_manager_data.POSITION_BUTTON_TRIGGERS_SHOULDERS_OFFSET

func _position_button_start_touch() -> Vector2:
	var screen_size: Vector2 = owner.get_viewport().get_visible_rect().size
	return Vector2(screen_size.x / 2 - 200, screen_size.y - 200) + input_manager_data._button_start_position + input_manager_data.POSITION_BUTTON_START_SELECT_OFFSET

func _position_button_select_touch() -> Vector2:
	var screen_size: Vector2 = owner.get_viewport().get_visible_rect().size
	return Vector2(screen_size.x / 2 + 200, screen_size.y - 200) + input_manager_data._button_select_position + input_manager_data.POSITION_BUTTON_START_SELECT_OFFSET

func _position_button_left_stick_touch() -> Vector2:
	var screen_size: Vector2 = owner.get_viewport().get_visible_rect().size
	return Vector2(350, screen_size.y - 675) + input_manager_data._left_stick_button_position + input_manager_data.POSITION_BUTTON_TRIGGERS_SHOULDERS_OFFSET

func _position_button_right_stick_touch() -> Vector2:
	var screen_size: Vector2 = owner.get_viewport().get_visible_rect().size
	return Vector2(screen_size.x - 350, screen_size.y - 675) + input_manager_data._right_stick_button_position + input_manager_data.POSITION_BUTTON_TRIGGERS_SHOULDERS_OFFSET

func _position_left_stick_ui() -> Vector2:
	var screen_size: Vector2 = owner.get_viewport().get_visible_rect().size
	return Vector2(150, screen_size.y - _left_stick_ui._joystick_radius * 2 - _left_stick_ui.joystick_border * 2 - 150) + input_manager_data._left_stick_ui_position

func _position_right_stick_ui() -> Vector2:
	var screen_size: Vector2 = owner.get_viewport().get_visible_rect().size
	return Vector2(screen_size.x - _right_stick_ui._joystick_radius * 2 - _right_stick_ui.joystick_border * 2 - 150, screen_size.y - _right_stick_ui._joystick_radius * 2 - _right_stick_ui.joystick_border * 2 - 150) + input_manager_data._right_stick_ui_position
#endregion PRIVATE METHODS ***********************************************
