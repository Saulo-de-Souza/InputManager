@tool
@icon("res://addons/input_manager/icon.svg")


class_name InputManagerData extends Resource


var owner: InputManager


var _DEFAULT_JOYSTICK_TEXTURE = preload("res://addons/input_manager/virtual_joystick/textures/joystick_texture_1.png")
var _JOYSTICK_TEXTURE_2 = preload("res://addons/input_manager/virtual_joystick/textures/joystick_texture_2.png")
var _JOYSTICK_TEXTURE_3 = preload("res://addons/input_manager/virtual_joystick/textures/joystick_texture_3.png")
var _JOYSTICK_TEXTURE_4 = preload("res://addons/input_manager/virtual_joystick/textures/joystick_texture_4.png")
var _JOYSTICK_TEXTURE_5 = preload("res://addons/input_manager/virtual_joystick/textures/joystick_texture_5.png")
var _JOYSTICK_TEXTURE_6 = preload("res://addons/input_manager/virtual_joystick/textures/joystick_texture_6.png")

var _DEFAULT_STICK_TEXTURE = preload("res://addons/input_manager/virtual_joystick/textures/stick_texture_1.png")
var _STICK_TEXTURE_2 = preload("res://addons/input_manager/virtual_joystick/textures/stick_texture_2.png")
var _STICK_TEXTURE_3 = preload("res://addons/input_manager/virtual_joystick/textures/stick_texture_3.png")
var _STICK_TEXTURE_4 = preload("res://addons/input_manager/virtual_joystick/textures/stick_texture_4.png")
var _STICK_TEXTURE_5 = preload("res://addons/input_manager/virtual_joystick/textures/stick_texture_5.png")
var _STICK_TEXTURE_6 = preload("res://addons/input_manager/virtual_joystick/textures/stick_texture_6.png")


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


@export_group("Joystick")
## Device id.
@export_range(0, 10, 1, "or_greater") var _device: int = 0
## Left Stick deadzone.
@export_range(0.0, 1.0, 0.01) var _left_stick_deadzone: float = 0.2
## Right Stick deadzone.
@export_range(0.0, 1.0, 0.01) var _right_stick_deadzone: float = 0.2
## Left Trigger deadzone.
@export_range(0.0, 1.0, 0.01) var _left_trigger_deadzone: float = 0.0
## Right Trigger deadzone.
@export_range(0.0, 1.0, 0.01) var _right_trigger_deadzone: float = 0.0
## Key to run.
@export var _run_key: Key = Key.KEY_SHIFT

@export_group("Left Stick", "_left_stick")
## Left Stick action name. LS to xbox and L to ps.
@export_placeholder("Left Stick action name") var _left_stick_action_name = "LS":
	set(value):
		if owner == null:
			_left_stick_action_name = value
			return
		_verify_duplicate(owner._actions_sticks, value)
		owner._actions_sticks.erase(_left_stick_action_name)
		_left_stick_action_name = value
		if value != "":
			owner._actions_sticks[_left_stick_action_name] = owner.get_left_stick
## Corresponding key of negative axis x stick.
@export var _left_stick_key_negative_x: Key = Key.KEY_A
## Corresponding key of positive axis x stick.
@export var _left_stick_key_positive_x: Key = Key.KEY_D
## Corresponding key of negative axis y stick.
@export var _left_stick_key_negative_y: Key = Key.KEY_W
## Corresponding key of positive axis y stick.
@export var _left_stick_key_positive_y: Key = Key.KEY_S
					
@export_group("Right Stick", "_right_stick")
## Right Stick action name. RS to xbox and R to ps.
@export_placeholder("Right Stick action name") var _right_stick_action_name = "RS":
	set(value):
		if owner == null:
			_right_stick_action_name = value
			return
		_verify_duplicate(owner._actions_sticks, value)
		owner._actions_sticks.erase(_right_stick_action_name)
		_right_stick_action_name = value
		if value != "":
			owner._actions_sticks[_right_stick_action_name] = owner.get_right_stick
## Corresponding key of negative axis x stick.
@export var _right_stick_key_negative_x: Key = Key.KEY_J
## Corresponding key of positive axis x stick.
@export var _right_stick_key_positive_x: Key = Key.KEY_L
## Corresponding key of negative axis y stick.
@export var _right_stick_key_negative_y: Key = Key.KEY_I
## Corresponding key of positive axis y stick.
@export var _right_stick_key_positive_y: Key = Key.KEY_K

@export_group("Left Trigger", "_left_trigger")
## Left Trigger action name. LT to xbox and L2 to ps.
@export_placeholder("Left Trigger action name") var _left_trigger_action_name = "LT":
	set(value):
		if owner == null:
			_left_trigger_action_name = value
			return
		_verify_duplicate(owner._actions_triggers, value)
		owner._actions_triggers.erase(_left_trigger_action_name)
		_left_trigger_action_name = value
		if value != "":
			owner._actions_triggers[_left_trigger_action_name] = owner.get_left_trigger
## Corresponding key.
@export var _left_trigger_key: Key = Key.KEY_Q
## Corresponding mouse button.
@export var _left_trigger_mouse_button: MouseButton = MouseButton.MOUSE_BUTTON_LEFT

@export_group("Right Trigger", "_right_trigger")
## Right Trigger action name. RT to xbox and R2 to ps.
@export_placeholder("Right Trigger action name") var _right_trigger_action_name = "RT":
	set(value):
		if owner == null:
			_right_trigger_action_name = value
			return
		_verify_duplicate(owner._actions_triggers, value)
		owner._actions_triggers.erase(_right_trigger_action_name)
		_right_trigger_action_name = value
		if value != "":
			owner._actions_triggers[_right_trigger_action_name] = owner.get_right_trigger
## Corresponding key.
@export var _right_trigger_key: Key = Key.KEY_E
## Corresponding mouse button.
@export var _right_trigger_mouse_button: MouseButton = MouseButton.MOUSE_BUTTON_RIGHT

@export_group("Left Shoulder", "_left_shoulder")
## Button Left Shoulder of joystick action name. LB to xbox and L1 to ps.
@export_placeholder("Left Shoulder action name") var _left_shoulder_action_name = "LB":
	set(value):
		if owner == null:
			_left_shoulder_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_left_shoulder_action_name)
		_left_shoulder_action_name = value
		if value != "":
			owner._actions_buttons[_left_shoulder_action_name] = \
			owner.get_left_shoulder_pressed if _left_shoulder_type == _event_type_enum.PRESSED \
			else owner.get_left_shoulder_realesed if _left_shoulder_type == _event_type_enum.RELESED \
			else owner.get_left_shoulder_oneshot if _left_shoulder_type == _event_type_enum.ONE_SHOT \
			else owner.get_left_shoulder_toggle
## Button Left Shoulder event action.
@export var _left_shoulder_type: _event_type_enum = _event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_left_shoulder_type = value
			return
		owner._actions_buttons.erase(_left_shoulder_action_name)
		_left_shoulder_type = value
		if _left_shoulder_action_name != "":
			owner._actions_buttons[_left_shoulder_action_name] = \
			owner.get_left_shoulder_pressed if _left_shoulder_type == _event_type_enum.PRESSED \
			else owner.get_left_shoulder_realesed if _left_shoulder_type == _event_type_enum.RELESED \
			else owner.get_left_shoulder_oneshot if _left_shoulder_type == _event_type_enum.ONE_SHOT \
			else owner.get_left_shoulder_toggle
## Corresponding key.
@export var _left_shoulder_key: Key = Key.KEY_U

@export_group("Right Shoulder", "_right_shoulder")
## Button Right Shoulder of joystick action name. RB to xbox and R1 to ps.
@export_placeholder("Right Shoulder action name") var _right_shoulder_action_name = "RB":
	set(value):
		if owner == null:
			_right_shoulder_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_right_shoulder_action_name)
		_right_shoulder_action_name = value
		if value != "":
			owner._actions_buttons[_right_shoulder_action_name] = \
			owner.get_right_shoulder_pressed if _right_shoulder_type == _event_type_enum.PRESSED \
			else owner.get_right_shoulder_realesed if _right_shoulder_type == _event_type_enum.RELESED \
			else owner.get_right_shoulder_oneshot if _right_shoulder_type == _event_type_enum.ONE_SHOT \
			else owner.get_right_shoulder_toggle
## Button Right Shoulder event action.
@export var _right_shoulder_type: _event_type_enum = _event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_right_shoulder_type = value
			return
		owner._actions_buttons.erase(_right_shoulder_action_name)
		_right_shoulder_type = value
		if _right_shoulder_action_name != "":
			owner._actions_buttons[_right_shoulder_action_name] = \
			owner.get_right_shoulder_pressed if _right_shoulder_type == _event_type_enum.PRESSED \
			else owner.get_right_shoulder_realesed if _right_shoulder_type == _event_type_enum.RELESED \
			else owner.get_right_shoulder_oneshot if _right_shoulder_type == _event_type_enum.ONE_SHOT \
			else owner.get_right_shoulder_toggle
## Corresponding key.
@export var _right_shoulder_key: Key = Key.KEY_O

@export_group("Left Stick Button", "_left_stick_button")
## Button joystick action name. LSB to xbox and L3 to ps.
@export_placeholder("Button L3 action name") var _left_stick_button_action_name = "LSB":
	set(value):
		if owner == null:
			_left_stick_button_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_left_stick_button_action_name)
		_left_stick_button_action_name = value
		if value != "":
			owner._actions_buttons[_left_stick_button_action_name] = \
			owner.get_left_stick_button_pressed if _left_stick_button_type == _event_type_enum.PRESSED \
			else owner.get_left_stick_button_realesed if _left_stick_button_type == _event_type_enum.RELESED \
			else owner.get_left_stick_button_oneshot if _left_stick_button_type == _event_type_enum.ONE_SHOT \
			else owner.get_left_stick_button_toggle
## Button L3 event action.
@export var _left_stick_button_type: _event_type_enum = _event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_left_stick_button_type = value
			return
		owner._actions_buttons.erase(_left_stick_button_action_name)
		_left_stick_button_type = value
		if _left_stick_button_action_name != "":
			owner._actions_buttons[_left_stick_button_action_name] = \
			owner.get_left_stick_button_pressed if _left_stick_button_type == _event_type_enum.PRESSED \
			else owner.get_left_stick_button_realesed if _left_stick_button_type == _event_type_enum.RELESED \
			else owner.get_left_stick_button_oneshot if _left_stick_button_type == _event_type_enum.ONE_SHOT \
			else owner.get_left_stick_button_toggle
## Corresponding key.
@export var _left_stick_button_key: Key = Key.KEY_F

@export_group("Right Stick Button", "_right_stick_button")
## Button joystick action name. RSB to xbox and R3 to ps.
@export_placeholder("Button R3 action name") var _right_stick_button_action_name = "RSB":
	set(value):
		if owner == null:
			_right_stick_button_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_right_stick_button_action_name)
		_right_stick_button_action_name = value
		if value != "":
			owner._actions_buttons[_right_stick_button_action_name] = \
			owner.get_right_stick_button_pressed if _right_stick_button_type == _event_type_enum.PRESSED \
			else owner.get_right_stick_button_realesed if _right_stick_button_type == _event_type_enum.RELESED \
			else owner.get_right_stick_button_oneshot if _right_stick_button_type == _event_type_enum.ONE_SHOT \
			else owner.get_right_stick_button_toggle
## Button R3 event action.
@export var _right_stick_button_type: _event_type_enum = _event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_right_stick_button_type = value
			return
		owner._actions_buttons.erase(_right_stick_button_action_name)
		_right_stick_button_type = value
		if _right_stick_button_action_name != "":
			owner._actions_buttons[_right_stick_button_action_name] = \
			owner.get_right_stick_button_pressed if _right_stick_button_type == _event_type_enum.PRESSED \
			else owner.get_right_stick_button_realesed if _right_stick_button_type == _event_type_enum.RELESED \
			else owner.get_right_stick_button_oneshot if _right_stick_button_type == _event_type_enum.ONE_SHOT \
			else owner.get_right_stick_button_toggle
## Corresponding key.
@export var _right_stick_button_key: Key = Key.KEY_G

@export_group("Action Button A", "_button_a")
## Button A (Xbox) or X (PS) of joystick action name.
@export_placeholder("Button A action name") var _button_a_action_name = "A":
	set(value):
		if owner == null:
			_button_a_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_button_a_action_name)
		_button_a_action_name = value
		if value != "":
			owner._actions_buttons[_button_a_action_name] = \
			owner.get_button_a_pressed if _button_a_type == _event_type_enum.PRESSED \
			else owner.get_button_a_realesed if _button_a_type == _event_type_enum.RELESED \
			else owner.get_button_a_oneshot if _button_a_type == _event_type_enum.ONE_SHOT \
			else owner.get_button_a_toggle
## Button A event action.
@export var _button_a_type: _event_type_enum = _event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_a_type = value
			return
		owner._actions_buttons.erase(_button_a_action_name)
		_button_a_type = value
		if _button_a_action_name != "":
			owner._actions_buttons[_button_a_action_name] = \
			owner.get_button_a_pressed if _button_a_type == _event_type_enum.PRESSED \
			else owner.get_button_a_realesed if _button_a_type == _event_type_enum.RELESED \
			else owner.get_button_a_oneshot if _button_a_type == _event_type_enum.ONE_SHOT \
			else owner.get_button_a_toggle
## Corresponding key.
@export var _button_a_key: Key = Key.KEY_SPACE

@export_group("Action Button B", "_button_b")
## Button B (Xbox) or Circle (PS) of joystick action name.
@export_placeholder("Button B action name") var _button_b_action_name = "B":
	set(value):
		if owner == null:
			_button_b_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_button_b_action_name)
		_button_b_action_name = value
		if value != "":
			owner._actions_buttons[_button_b_action_name] = \
			owner.get_button_b_pressed if _button_b_type == _event_type_enum.PRESSED \
			else owner.get_button_b_realesed if _button_b_type == _event_type_enum.RELESED \
			else owner.get_button_b_oneshot if _button_b_type == _event_type_enum.ONE_SHOT \
			else owner.get_button_b_toggle
## Button B event action.
@export var _button_b_type: _event_type_enum = _event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_b_type = value
			return
		owner._actions_buttons.erase(_button_b_action_name)
		_button_b_type = value
		if _button_b_action_name != "":
			owner._actions_buttons[_button_b_action_name] = \
			owner.get_button_b_pressed if _button_b_type == _event_type_enum.PRESSED \
			else owner.get_button_b_realesed if _button_b_type == _event_type_enum.RELESED \
			else owner.get_button_b_oneshot if _button_b_type == _event_type_enum.ONE_SHOT \
			else owner.get_button_b_toggle
## Corresponding key.
@export var _button_b_key: Key = Key.KEY_Z

@export_group("Action Button X", "_button_x")
## Button X (Xbox) or Square (PS) of joystick action name.
@export_placeholder("Button X action name") var _button_x_action_name = "X":
	set(value):
		if owner == null:
			_button_x_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_button_x_action_name)
		_button_x_action_name = value
		if value != "":
			owner._actions_buttons[_button_x_action_name] = \
			owner.get_button_x_pressed if _button_x_type == _event_type_enum.PRESSED \
			else owner.get_button_x_realesed if _button_x_type == _event_type_enum.RELESED \
			else owner.get_button_x_oneshot if _button_x_type == _event_type_enum.ONE_SHOT \
			else owner.get_button_x_toggle
## Button X event action.
@export var _button_x_type: _event_type_enum = _event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_x_type = value
			return
		owner._actions_buttons.erase(_button_x_action_name)
		_button_x_type = value
		if _button_x_action_name != "":
			owner._actions_buttons[_button_x_action_name] = \
			owner.get_button_x_pressed if _button_x_type == _event_type_enum.PRESSED \
			else owner.get_button_x_realesed if _button_x_type == _event_type_enum.RELESED \
			else owner.get_button_x_oneshot if _button_x_type == _event_type_enum.ONE_SHOT \
			else owner.get_button_x_toggle
## Corresponding key.
@export var _button_x_key: Key = Key.KEY_X

@export_group("Action Button Y", "_button_y")
## Button Y (Xbox) or Triangle (PS) of joystick action name.
@export_placeholder("Button Y action name") var _button_y_action_name = "Y":
	set(value):
		if owner == null:
			_button_y_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_button_y_action_name)
		_button_y_action_name = value
		if value != "":
			owner._actions_buttons[_button_y_action_name] = \
			owner.get_button_y_pressed if _button_y_type == _event_type_enum.PRESSED \
			else owner.get_button_y_realesed if _button_y_type == _event_type_enum.RELESED \
			else owner.get_button_y_oneshot if _button_y_type == _event_type_enum.ONE_SHOT \
			else owner.get_button_y_toggle
## Button Y event action.
@export var _button_y_type: _event_type_enum = _event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_y_type = value
			return
		owner._actions_buttons.erase(_button_y_action_name)
		_button_y_type = value
		if _button_y_action_name != "":
			owner._actions_buttons[_button_y_action_name] = \
			owner.get_button_y_pressed if _button_y_type == _event_type_enum.PRESSED \
			else owner.get_button_y_realesed if _button_y_type == _event_type_enum.RELESED \
			else owner.get_button_y_oneshot if _button_y_type == _event_type_enum.ONE_SHOT \
			else owner.get_button_y_toggle
## Corresponding key.
@export var _button_y_key: Key = Key.KEY_C

@export_group("D-PAD UP", "_dpad_up")
## Button D-PAD UP of joystick action name.
@export_placeholder("Button D-PAD UP action name") var _dpad_up_action_name = "D_PAD_UP":
	set(value):
		if owner == null:
			_dpad_up_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_dpad_up_action_name)
		_dpad_up_action_name = value
		if value != "":
			owner._actions_buttons[_dpad_up_action_name] = \
			owner.get_dpad_up_pressed if _dpad_up_type == _event_type_enum.PRESSED \
			else owner.get_dpad_up_realesed if _dpad_up_type == _event_type_enum.RELESED \
			else owner.get_dpad_up_oneshot if _dpad_up_type == _event_type_enum.ONE_SHOT \
			else owner.get_dpad_up_toggle
## Button D-PAD UP event action.
@export var _dpad_up_type: _event_type_enum = _event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_dpad_up_type = value
			return
		owner._actions_buttons.erase(_dpad_up_action_name)
		_dpad_up_type = value
		if _dpad_up_action_name != "":
			owner._actions_buttons[_dpad_up_action_name] = \
			owner.get_dpad_up_pressed if _dpad_up_type == _event_type_enum.PRESSED \
			else owner.get_dpad_up_realesed if _dpad_up_type == _event_type_enum.RELESED \
			else owner.get_dpad_up_oneshot if _dpad_up_type == _event_type_enum.ONE_SHOT \
			else owner.get_dpad_up_toggle
## Corresponding key.
@export var _dpad_up_key: Key = Key.KEY_UP

@export_group("D-PAD DOWN", "_dpad_down")
## Button D-PAD DOWN of joystick action name.
@export_placeholder("Button D-PAD DOWN action name") var _dpad_down_action_name = "D_PAD_DOWN":
	set(value):
		if owner == null:
			_dpad_down_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_dpad_down_action_name)
		_dpad_down_action_name = value
		if value != "":
			owner._actions_buttons[_dpad_down_action_name] = \
			owner.get_dpad_down_pressed if _dpad_down_type == _event_type_enum.PRESSED \
			else owner.get_dpad_down_realesed if _dpad_down_type == _event_type_enum.RELESED \
			else owner.get_dpad_down_oneshot if _dpad_down_type == _event_type_enum.ONE_SHOT \
			else owner.get_dpad_down_toggle
## Button D-PAD DOWN event action.
@export var _dpad_down_type: _event_type_enum = _event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_dpad_down_type = value
			return
		owner._actions_buttons.erase(_dpad_down_action_name)
		_dpad_down_type = value
		if _dpad_down_action_name != "":
			owner._actions_buttons[_dpad_down_action_name] = \
			owner.get_dpad_down_pressed if _dpad_down_type == _event_type_enum.PRESSED \
			else owner.get_dpad_down_realesed if _dpad_down_type == _event_type_enum.RELESED \
			else owner.get_dpad_down_oneshot if _dpad_down_type == _event_type_enum.ONE_SHOT \
			else owner.get_dpad_down_toggle
## Corresponding key.
@export var _dpad_down_key: Key = Key.KEY_DOWN

@export_group("D-PAD LEFT", "_dpad_left")
## Button D-PAD LEFT of joystick action name.
@export_placeholder("Button D-PAD LEFT action name") var _dpad_left_action_name = "D_PAD_LEFT":
	set(value):
		if owner == null:
			_dpad_left_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_dpad_left_action_name)
		_dpad_left_action_name = value
		if value != "":
			owner._actions_buttons[_dpad_left_action_name] = \
			owner.get_dpad_left_pressed if _dpad_left_type == _event_type_enum.PRESSED \
			else owner.get_dpad_left_realesed if _dpad_left_type == _event_type_enum.RELESED \
			else owner.get_dpad_left_oneshot if _dpad_left_type == _event_type_enum.ONE_SHOT \
			else owner.get_dpad_left_toggle
## Button D-PAD LEFT event action.
@export var _dpad_left_type: _event_type_enum = _event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_dpad_left_type = value
			return
		owner._actions_buttons.erase(_dpad_left_action_name)
		_dpad_left_type = value
		if _dpad_left_action_name != "":
			owner._actions_buttons[_dpad_left_action_name] = \
			owner.get_dpad_left_pressed if _dpad_left_type == _event_type_enum.PRESSED \
			else owner.get_dpad_left_realesed if _dpad_left_type == _event_type_enum.RELESED \
			else owner.get_dpad_left_oneshot if _dpad_left_type == _event_type_enum.ONE_SHOT \
			else owner.get_dpad_left_toggle
## Corresponding key.
@export var _dpad_left_key: Key = Key.KEY_LEFT

@export_group("D-PAD RIGHT", "_dpad_right")
## Button D-PAD RIGHT of joystick action name.
@export_placeholder("Button D-PAD RIGHT action name") var _dpad_right_action_name = "D_PAD_RIGHT":
	set(value):
		if owner == null:
			_dpad_right_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_dpad_right_action_name)
		_dpad_right_action_name = value
		if value != "":
			owner._actions_buttons[_dpad_right_action_name] = \
			owner.get_dpad_right_pressed if _dpad_right_type == _event_type_enum.PRESSED \
			else owner.get_dpad_right_realesed if _dpad_right_type == _event_type_enum.RELESED \
			else owner.get_dpad_right_oneshot if _dpad_right_type == _event_type_enum.ONE_SHOT \
			else owner.get_dpad_right_toggle
## Button D-PAD RIGHT event action.
@export var _dpad_right_type: _event_type_enum = _event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_dpad_right_type = value
			return
		owner._actions_buttons.erase(_dpad_right_action_name)
		_dpad_right_type = value
		if _dpad_right_action_name != "":
			owner._actions_buttons[_dpad_right_action_name] = \
			owner.get_dpad_right_pressed if _dpad_right_type == _event_type_enum.PRESSED \
			else owner.get_dpad_right_realesed if _dpad_right_type == _event_type_enum.RELESED \
			else owner.get_dpad_right_oneshot if _dpad_right_type == _event_type_enum.ONE_SHOT \
			else owner.get_dpad_right_toggle
## Corresponding key.
@export var _dpad_right_key: Key = Key.KEY_RIGHT

@export_group("Start Button", "_button_start")
## Button Start of joystick action name. Start to xbox and Options to ps.
@export_placeholder("Button Start action name") var _button_start_action_name = "START":
	set(value):
		if owner == null:
			_button_start_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_button_start_action_name)
		_button_start_action_name = value
		if value != "":
			owner._actions_buttons[_button_start_action_name] = \
			owner.get_start_pressed if _button_start_type == _event_type_enum.PRESSED \
			else owner.get_start_realesed if _button_start_type == _event_type_enum.RELESED \
			else owner.get_start_oneshot if _button_start_type == _event_type_enum.ONE_SHOT \
			else owner.get_start_toggle
## Button Start event action
@export var _button_start_type: _event_type_enum = _event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_start_type = value
			return
		owner._actions_buttons.erase(_button_start_action_name)
		_button_start_type = value
		if _button_start_action_name != "":
			owner._actions_buttons[_button_start_action_name] = \
			owner.get_start_pressed if _button_start_type == _event_type_enum.PRESSED \
			else owner.get_start_realesed if _button_start_type == _event_type_enum.RELESED \
			else owner.get_start_oneshot if _button_start_type == _event_type_enum.ONE_SHOT \
			else owner.get_start_toggle
## Corresponding key.
@export var _button_start_key: Key = Key.KEY_ENTER

@export_group("Select Button", "_button_select")
## Button Select of joystick action name. Back to xbox and Share to ps.
@export_placeholder("Button Select action name") var _button_select_action_name = "SELECT":
	set(value):
		if owner == null:
			_button_select_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_button_select_action_name)
		_button_select_action_name = value
		if value != "":
			owner._actions_buttons[_button_select_action_name] = \
			owner.get_select_pressed if _button_select_type == _event_type_enum.PRESSED \
			else owner.get_select_realesed if _button_select_type == _event_type_enum.RELESED \
			else owner.get_select_oneshot if _button_select_type == _event_type_enum.ONE_SHOT \
			else owner.get_select_toggle
## Button Select event action.
@export var _button_select_type: _event_type_enum = _event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_select_type = value
			return
		owner._actions_buttons.erase(_button_select_action_name)
		_button_select_type = value
		if _button_select_action_name != "":
			owner._actions_buttons[_button_select_action_name] = \
			owner.get_select_pressed if _button_select_type == _event_type_enum.PRESSED \
			else owner.get_select_realesed if _button_select_type == _event_type_enum.RELESED \
			else owner.get_select_oneshot if _button_select_type == _event_type_enum.ONE_SHOT \
			else owner.get_select_toggle
## Corresponding key.
@export var _button_select_key: Key = Key.KEY_BACKSPACE

@export_group("Mouse", "_mouse")
## If true, mouse events will be emitted, and if false, mouse-related events will only be triggered if the mouse is [b]captured[/b].
@export var _mouse_enable_event_without_captured: bool = false
## Button capture mouse.
@export var _mouse_capture_key: Key = Key.KEY_TAB
## Button mouse visible.
@export var _mouse_visble_key: Key = Key.KEY_ESCAPE

@export_group("")
@export_tool_button("RESET DEFAULT") var _reset_button = _on_reset_button


func init(_owner: InputManager) -> void:
	owner = _owner

	if owner == null:
		return

	owner._actions_buttons.clear()
	owner._actions_sticks.clear()
	owner._actions_triggers.clear()

	if _left_stick_action_name != "":
		_verify_duplicate(owner._actions_sticks, _left_stick_action_name)
		owner._actions_sticks[_left_stick_action_name] = owner.get_left_stick

	if _right_stick_action_name != "":
		_verify_duplicate(owner._actions_sticks, _right_stick_action_name)
		owner._actions_sticks[_right_stick_action_name] = owner.get_right_stick

	if _left_trigger_action_name != "":
		_verify_duplicate(owner._actions_triggers, _left_trigger_action_name)
		owner._actions_triggers[_left_trigger_action_name] = owner.get_left_trigger

	if _right_trigger_action_name != "":
		_verify_duplicate(owner._actions_triggers, _right_trigger_action_name)
		owner._actions_triggers[_right_trigger_action_name] = owner.get_right_trigger

	if _left_shoulder_action_name != "":
		_verify_duplicate(owner._actions_buttons, _left_shoulder_action_name)
		owner._actions_buttons[_left_shoulder_action_name] = \
		owner.get_left_shoulder_pressed if _left_shoulder_type == _event_type_enum.PRESSED \
		else owner.get_left_shoulder_realesed if _left_shoulder_type == _event_type_enum.RELESED \
		else owner.get_left_shoulder_oneshot if _left_shoulder_type == _event_type_enum.ONE_SHOT \
		else owner.get_left_shoulder_toggle

	if _right_shoulder_action_name != "":
		_verify_duplicate(owner._actions_buttons, _right_shoulder_action_name)
		owner._actions_buttons[_right_shoulder_action_name] = \
		owner.get_right_shoulder_pressed if _right_shoulder_type == _event_type_enum.PRESSED \
		else owner.get_right_shoulder_realesed if _right_shoulder_type == _event_type_enum.RELESED \
		else owner.get_right_shoulder_oneshot if _right_shoulder_type == _event_type_enum.ONE_SHOT \
		else owner.get_right_shoulder_toggle

	if _left_stick_button_action_name != "":
		_verify_duplicate(owner._actions_buttons, _left_stick_button_action_name)
		owner._actions_buttons[_left_stick_button_action_name] = \
		owner.get_left_stick_button_pressed if _left_stick_button_type == _event_type_enum.PRESSED \
		else owner.get_left_stick_button_realesed if _left_stick_button_type == _event_type_enum.RELESED \
		else owner.get_left_stick_button_oneshot if _left_stick_button_type == _event_type_enum.ONE_SHOT \
		else owner.get_left_stick_button_toggle

	if _right_stick_button_action_name != "":
		_verify_duplicate(owner._actions_buttons, _right_stick_button_action_name)
		owner._actions_buttons[_right_stick_button_action_name] = \
		owner.get_right_stick_button_pressed if _right_stick_button_type == _event_type_enum.PRESSED \
		else owner.get_right_stick_button_realesed if _right_stick_button_type == _event_type_enum.RELESED \
		else owner.get_right_stick_button_oneshot if _right_stick_button_type == _event_type_enum.ONE_SHOT \
		else owner.get_right_stick_button_toggle

	if _button_a_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_a_action_name)
		owner._actions_buttons[_button_a_action_name] = \
		owner.get_button_a_pressed if _button_a_type == _event_type_enum.PRESSED \
		else owner.get_button_a_realesed if _button_a_type == _event_type_enum.RELESED \
		else owner.get_button_a_oneshot if _button_a_type == _event_type_enum.ONE_SHOT \
		else owner.get_button_a_toggle

	if _button_b_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_b_action_name)
		owner._actions_buttons[_button_b_action_name] = \
		owner.get_button_b_pressed if _button_b_type == _event_type_enum.PRESSED \
		else owner.get_button_b_realesed if _button_b_type == _event_type_enum.RELESED \
		else owner.get_button_b_oneshot if _button_b_type == _event_type_enum.ONE_SHOT \
		else owner.get_button_b_toggle

	if _button_x_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_x_action_name)
		owner._actions_buttons[_button_x_action_name] = \
		owner.get_button_x_pressed if _button_x_type == _event_type_enum.PRESSED \
		else owner.get_button_x_realesed if _button_x_type == _event_type_enum.RELESED \
		else owner.get_button_x_oneshot if _button_x_type == _event_type_enum.ONE_SHOT \
		else owner.get_button_x_toggle

	if _button_y_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_y_action_name)
		owner._actions_buttons[_button_y_action_name] = \
		owner.get_button_y_pressed if _button_y_type == _event_type_enum.PRESSED \
		else owner.get_button_y_realesed if _button_y_type == _event_type_enum.RELESED \
		else owner.get_button_y_oneshot if _button_y_type == _event_type_enum.ONE_SHOT \
		else owner.get_button_y_toggle

	if _dpad_up_action_name != "":
		_verify_duplicate(owner._actions_buttons, _dpad_up_action_name)
		owner._actions_buttons[_dpad_up_action_name] = \
		owner.get_dpad_up_pressed if _dpad_up_type == _event_type_enum.PRESSED \
		else owner.get_dpad_up_realesed if _dpad_up_type == _event_type_enum.RELESED \
		else owner.get_dpad_up_oneshot if _dpad_up_type == _event_type_enum.ONE_SHOT \
		else owner.get_dpad_up_toggle

	if _dpad_down_action_name != "":
		_verify_duplicate(owner._actions_buttons, _dpad_down_action_name)
		owner._actions_buttons[_dpad_down_action_name] = \
		owner.get_dpad_down_pressed if _dpad_down_type == _event_type_enum.PRESSED \
		else owner.get_dpad_down_realesed if _dpad_down_type == _event_type_enum.RELESED \
		else owner.get_dpad_down_oneshot if _dpad_down_type == _event_type_enum.ONE_SHOT \
		else owner.get_dpad_down_toggle

	if _dpad_left_action_name != "":
		_verify_duplicate(owner._actions_buttons, _dpad_left_action_name)
		owner._actions_buttons[_dpad_left_action_name] = \
		owner.get_dpad_left_pressed if _dpad_left_type == _event_type_enum.PRESSED \
		else owner.get_dpad_left_realesed if _dpad_left_type == _event_type_enum.RELESED \
		else owner.get_dpad_left_oneshot if _dpad_left_type == _event_type_enum.ONE_SHOT \
		else owner.get_dpad_left_toggle

	if _dpad_right_action_name != "":
		_verify_duplicate(owner._actions_buttons, _dpad_right_action_name)
		owner._actions_buttons[_dpad_right_action_name] = \
		owner.get_dpad_right_pressed if _dpad_right_type == _event_type_enum.PRESSED \
		else owner.get_dpad_right_realesed if _dpad_right_type == _event_type_enum.RELESED \
		else owner.get_dpad_right_oneshot if _dpad_right_type == _event_type_enum.ONE_SHOT \
		else owner.get_dpad_right_toggle

	if _button_start_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_start_action_name)
		owner._actions_buttons[_button_start_action_name] = \
		owner.get_start_pressed if _button_start_type == _event_type_enum.PRESSED \
		else owner.get_start_realesed if _button_start_type == _event_type_enum.RELESED \
		else owner.get_start_oneshot if _button_start_type == _event_type_enum.ONE_SHOT \
		else owner.get_start_toggle

	if _button_select_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_select_action_name)
		owner._actions_buttons[_button_select_action_name] = \
		owner.get_select_pressed if _button_select_type == _event_type_enum.PRESSED \
		else owner.get_select_realesed if _button_select_type == _event_type_enum.RELESED \
		else owner.get_select_oneshot if _button_select_type == _event_type_enum.ONE_SHOT \
		else owner.get_select_toggle


func _verify_duplicate(_actions_source: Dictionary, value: String) -> void:
	if _actions_source.has(value):
		push_error("Action name %s duplicate."%value)


func _on_reset_button() -> void:
	_device = 0
	_left_stick_deadzone = 0.2
	_right_stick_deadzone = 0.2
	_left_trigger_deadzone = 0.0
	_right_trigger_deadzone = 0.0
	
	if _left_stick_action_name != "LS":
		_left_stick_action_name = "LS"
	_left_stick_key_negative_x = KEY_A
	_left_stick_key_positive_x = KEY_D
	_left_stick_key_negative_y = KEY_W
	_left_stick_key_positive_y = KEY_S
	
	if _right_stick_action_name != "RS":
		_right_stick_action_name = "RS"
	_right_stick_key_negative_x = KEY_J
	_right_stick_key_positive_x = KEY_L
	_right_stick_key_negative_y = KEY_I
	_right_stick_key_positive_y = KEY_K
	
	if _left_trigger_action_name != "LT":
		_left_trigger_action_name = "LT"
	_left_trigger_key = Key.KEY_Q
	_left_trigger_mouse_button = MouseButton.MOUSE_BUTTON_LEFT
		
	if _right_trigger_action_name != "RT":
		_right_trigger_action_name = "RT"
	_right_trigger_key = Key.KEY_E
	_right_trigger_mouse_button = MouseButton.MOUSE_BUTTON_RIGHT
	
	if _left_shoulder_action_name != "LB":
		_left_shoulder_action_name = "LB"
	_left_shoulder_type = _event_type_enum.PRESSED
	_left_shoulder_key = KEY_U
		
	if _right_shoulder_action_name != "RB":
		_right_shoulder_action_name = "RB"
	_right_shoulder_type = _event_type_enum.PRESSED
	_right_shoulder_key = KEY_O
	
	if _left_stick_button_action_name != "LSB":
		_left_stick_button_action_name = "LSB"
	_left_stick_button_type = _event_type_enum.PRESSED
	_left_stick_button_key = KEY_F
	
	if _right_stick_button_action_name != "RSB":
		_right_stick_button_action_name = "RSB"
	_right_stick_button_type = _event_type_enum.PRESSED
	_right_stick_button_key = KEY_G
	
	if _button_a_action_name != "A":
		_button_a_action_name = "A"
	_button_a_type = _event_type_enum.PRESSED
	_button_a_key = KEY_SPACE
	
	if _button_b_action_name != "B":
		_button_b_action_name = "B"
	_button_b_type = _event_type_enum.PRESSED
	_button_b_key = KEY_Z

	if _button_x_action_name != "X":
		_button_x_action_name = "X"
	_button_x_type = _event_type_enum.PRESSED
	_button_x_key = KEY_X

	if _button_y_action_name != "Y":
		_button_y_action_name = "Y"
	_button_y_type = _event_type_enum.PRESSED
	_button_y_key = KEY_C

	if _dpad_up_action_name != "D_PAD_UP":
		_dpad_up_action_name = "D_PAD_UP"
	_dpad_up_type = _event_type_enum.PRESSED
	_dpad_up_key = KEY_UP

	if _dpad_down_action_name != "D_PAD_DOWN":
		_dpad_down_action_name = "D_PAD_DOWN"
	_dpad_down_type = _event_type_enum.PRESSED
	_dpad_down_key = KEY_DOWN

	if _dpad_left_action_name != "D_PAD_LEFT":
		_dpad_left_action_name = "D_PAD_LEFT"
	_dpad_left_type = _event_type_enum.PRESSED
	_dpad_left_key = KEY_LEFT

	if _dpad_right_action_name != "D_PAD_RIGHT":
		_dpad_right_action_name = "D_PAD_RIGHT"
	_dpad_right_type = _event_type_enum.PRESSED
	_dpad_right_key = KEY_RIGHT

	if _button_start_action_name != "START":
		_button_start_action_name = "START"
	_button_start_type = _event_type_enum.PRESSED
	_button_start_key = KEY_ENTER

	if _button_select_action_name != "SELECT":
		_button_select_action_name = "SELECT"
	_button_select_type = _event_type_enum.PRESSED
	_button_select_key = KEY_BACKSPACE
	
	_mouse_enable_event_without_captured = false
	_mouse_capture_key = KEY_TAB
	_mouse_visble_key = KEY_ESCAPE
