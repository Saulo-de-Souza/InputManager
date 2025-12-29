@icon("res://addons/input_manager/icon.svg")
class_name InputManagerData extends Resource

var owner: InputManager

@export_subgroup("Joystick")
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

@export_subgroup("Left Stick")
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

@export_subgroup("Right Stick")
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

@export_subgroup("Left Trigger")
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

@export_subgroup("Right Trigger")
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

@export_subgroup("Left Shoulder")
## Button Left Shoulder of joystick action name. LB to xbox and L1 to ps.
@export_placeholder("Left Shoulder action name") var _button_left_shoulder_action_name = "LB":
	set(value):
		if owner == null:
			_button_left_shoulder_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_button_left_shoulder_action_name)
		_button_left_shoulder_action_name = value
		if value != "":
			owner._actions_buttons[_button_left_shoulder_action_name] = \
			owner.get_left_shoulder_pressed if _button_left_shoulder_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_left_shoulder_realesed if _button_left_shoulder_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_left_shoulder_oneshot if _button_left_shoulder_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_left_shoulder_toggle
## Button Left Shoulder event action.
@export var _button_left_shoulder_type: InputManagerConst._event_type_enum = InputManagerConst._event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_left_shoulder_type = value
			return
		owner._actions_buttons.erase(_button_left_shoulder_action_name)
		_button_left_shoulder_type = value
		if _button_left_shoulder_action_name != "":
			owner._actions_buttons[_button_left_shoulder_action_name] = \
			owner.get_left_shoulder_pressed if _button_left_shoulder_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_left_shoulder_realesed if _button_left_shoulder_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_left_shoulder_oneshot if _button_left_shoulder_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_left_shoulder_toggle
## Corresponding key.
@export var _button_left_shoulder_key: Key = Key.KEY_U

@export_subgroup("Right Shoulder")
## Button Right Shoulder of joystick action name. RB to xbox and R1 to ps.
@export_placeholder("Right Shoulder action name") var _button_right_shoulder_action_name = "RB":
	set(value):
		if owner == null:
			_button_right_shoulder_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_button_right_shoulder_action_name)
		_button_right_shoulder_action_name = value
		if value != "":
			owner._actions_buttons[_button_right_shoulder_action_name] = \
			owner.get_right_shoulder_pressed if _button_right_shoulder_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_right_shoulder_realesed if _button_right_shoulder_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_right_shoulder_oneshot if _button_right_shoulder_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_right_shoulder_toggle
## Button Right Shoulder event action.
@export var _button_right_shoulder_type: InputManagerConst._event_type_enum = InputManagerConst._event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_right_shoulder_type = value
			return
		owner._actions_buttons.erase(_button_right_shoulder_action_name)
		_button_right_shoulder_type = value
		if _button_right_shoulder_action_name != "":
			owner._actions_buttons[_button_right_shoulder_action_name] = \
			owner.get_right_shoulder_pressed if _button_right_shoulder_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_right_shoulder_realesed if _button_right_shoulder_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_right_shoulder_oneshot if _button_right_shoulder_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_right_shoulder_toggle
## Corresponding key.
@export var _button_right_shoulder_key: Key = Key.KEY_O

@export_subgroup("Action Button Left Stick")
## Button joystick action name. LSB to xbox and L3 to ps.
@export_placeholder("Button L3 action name") var _button_left_stick_action_name = "LSB":
	set(value):
		if owner == null:
			_button_left_stick_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_button_left_stick_action_name)
		_button_left_stick_action_name = value
		if value != "":
			owner._actions_buttons[_button_left_stick_action_name] = \
			owner.get_left_stick_button_pressed if _button_left_stick_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_left_stick_button_realesed if _button_left_stick_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_left_stick_button_oneshot if _button_left_stick_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_left_stick_button_toggle
## Button L3 event action.
@export var _button_left_stick_type: InputManagerConst._event_type_enum = InputManagerConst._event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_left_stick_type = value
			return
		owner._actions_buttons.erase(_button_left_stick_action_name)
		_button_left_stick_type = value
		if _button_left_stick_action_name != "":
			owner._actions_buttons[_button_left_stick_action_name] = \
			owner.get_left_stick_button_pressed if _button_left_stick_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_left_stick_button_realesed if _button_left_stick_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_left_stick_button_oneshot if _button_left_stick_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_left_stick_button_toggle
## Corresponding key.
@export var _button_left_stick_key: Key = Key.KEY_F

@export_subgroup("Action Button Right Stick")
## Button joystick action name. RSB to xbox and R3 to ps.
@export_placeholder("Button R3 action name") var _button_right_stick_action_name = "RSB":
	set(value):
		if owner == null:
			_button_right_stick_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_button_right_stick_action_name)
		_button_right_stick_action_name = value
		if value != "":
			owner._actions_buttons[_button_right_stick_action_name] = \
			owner.get_right_stick_button_pressed if _button_right_stick_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_right_stick_button_realesed if _button_right_stick_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_right_stick_button_oneshot if _button_right_stick_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_right_stick_button_toggle
## Button R3 event action.
@export var _button_right_stick_type: InputManagerConst._event_type_enum = InputManagerConst._event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_right_stick_type = value
			return
		owner._actions_buttons.erase(_button_right_stick_action_name)
		_button_right_stick_type = value
		if _button_right_stick_action_name != "":
			owner._actions_buttons[_button_right_stick_action_name] = \
			owner.get_right_stick_button_pressed if _button_right_stick_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_right_stick_button_realesed if _button_right_stick_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_right_stick_button_oneshot if _button_right_stick_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_right_stick_button_toggle
## Corresponding key.
@export var _button_right_stick_key: Key = Key.KEY_G

@export_subgroup("Action Button A")
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
			owner.get_button_a_pressed if _button_a_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_button_a_realesed if _button_a_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_button_a_oneshot if _button_a_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_button_a_toggle
## Button A event action.
@export var _button_a_type: InputManagerConst._event_type_enum = InputManagerConst._event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_a_type = value
			return
		owner._actions_buttons.erase(_button_a_action_name)
		_button_a_type = value
		if _button_a_action_name != "":
			owner._actions_buttons[_button_a_action_name] = \
			owner.get_button_a_pressed if _button_a_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_button_a_realesed if _button_a_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_button_a_oneshot if _button_a_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_button_a_toggle
## Corresponding key.
@export var _button_a_key: Key = Key.KEY_SPACE

@export_subgroup("Action Button B")
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
			owner.get_button_b_pressed if _button_b_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_button_b_realesed if _button_b_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_button_b_oneshot if _button_b_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_button_b_toggle
## Button B event action.
@export var _button_b_type: InputManagerConst._event_type_enum = InputManagerConst._event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_b_type = value
			return
		owner._actions_buttons.erase(_button_b_action_name)
		_button_b_type = value
		if _button_b_action_name != "":
			owner._actions_buttons[_button_b_action_name] = \
			owner.get_button_b_pressed if _button_b_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_button_b_realesed if _button_b_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_button_b_oneshot if _button_b_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_button_b_toggle
## Corresponding key.
@export var _button_b_key: Key = Key.KEY_Z

@export_subgroup("Action Button X")
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
			owner.get_button_x_pressed if _button_x_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_button_x_realesed if _button_x_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_button_x_oneshot if _button_x_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_button_x_toggle
## Button X event action.
@export var _button_x_type: InputManagerConst._event_type_enum = InputManagerConst._event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_x_type = value
			return
		owner._actions_buttons.erase(_button_x_action_name)
		_button_x_type = value
		if _button_x_action_name != "":
			owner._actions_buttons[_button_x_action_name] = \
			owner.get_button_x_pressed if _button_x_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_button_x_realesed if _button_x_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_button_x_oneshot if _button_x_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_button_x_toggle
## Corresponding key.
@export var _button_x_key: Key = Key.KEY_X

@export_subgroup("Action Button Y")
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
			owner.get_button_y_pressed if _button_y_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_button_y_realesed if _button_y_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_button_y_oneshot if _button_y_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_button_y_toggle
## Button Y event action.
@export var _button_y_type: InputManagerConst._event_type_enum = InputManagerConst._event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_y_type = value
			return
		owner._actions_buttons.erase(_button_y_action_name)
		_button_y_type = value
		if _button_y_action_name != "":
			owner._actions_buttons[_button_y_action_name] = \
			owner.get_button_y_pressed if _button_y_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_button_y_realesed if _button_y_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_button_y_oneshot if _button_y_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_button_y_toggle
## Corresponding key.
@export var _button_y_key: Key = Key.KEY_C

@export_subgroup("Action Button D-PAD UP")
## Button D-PAD UP of joystick action name.
@export_placeholder("Button D-PAD UP action name") var _button_dpad_up_action_name = "D_PAD_UP":
	set(value):
		if owner == null:
			_button_dpad_up_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_button_dpad_up_action_name)
		_button_dpad_up_action_name = value
		if value != "":
			owner._actions_buttons[_button_dpad_up_action_name] = \
			owner.get_dpad_up_pressed if _button_dpad_up_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_dpad_up_realesed if _button_dpad_up_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_dpad_up_oneshot if _button_dpad_up_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_dpad_up_toggle
## Button D-PAD UP event action.
@export var _button_dpad_up_type: InputManagerConst._event_type_enum = InputManagerConst._event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_dpad_up_type = value
			return
		owner._actions_buttons.erase(_button_dpad_up_action_name)
		_button_dpad_up_type = value
		if _button_dpad_up_action_name != "":
			owner._actions_buttons[_button_dpad_up_action_name] = \
			owner.get_dpad_up_pressed if _button_dpad_up_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_dpad_up_realesed if _button_dpad_up_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_dpad_up_oneshot if _button_dpad_up_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_dpad_up_toggle
## Corresponding key.
@export var _button_dpad_up_key: Key = Key.KEY_UP

@export_subgroup("Action Button D-PAD DOWN")
## Button D-PAD DOWN of joystick action name.
@export_placeholder("Button D-PAD DOWN action name") var _button_dpad_down_action_name = "D_PAD_DOWN":
	set(value):
		if owner == null:
			_button_dpad_down_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_button_dpad_down_action_name)
		_button_dpad_down_action_name = value
		if value != "":
			owner._actions_buttons[_button_dpad_down_action_name] = \
			owner.get_dpad_down_pressed if _button_dpad_down_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_dpad_down_realesed if _button_dpad_down_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_dpad_down_oneshot if _button_dpad_down_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_dpad_down_toggle
## Button D-PAD DOWN event action.
@export var _button_dpad_down_type: InputManagerConst._event_type_enum = InputManagerConst._event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_dpad_down_type = value
			return
		owner._actions_buttons.erase(_button_dpad_down_action_name)
		_button_dpad_down_type = value
		if _button_dpad_down_action_name != "":
			owner._actions_buttons[_button_dpad_down_action_name] = \
			owner.get_dpad_down_pressed if _button_dpad_down_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_dpad_down_realesed if _button_dpad_down_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_dpad_down_oneshot if _button_dpad_down_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_dpad_down_toggle
## Corresponding key.
@export var _button_dpad_down_key: Key = Key.KEY_DOWN

@export_subgroup("Action Button D-PAD LEFT")
## Button D-PAD LEFT of joystick action name.
@export_placeholder("Button D-PAD LEFT action name") var _button_dpad_left_action_name = "D_PAD_LEFT":
	set(value):
		if owner == null:
			_button_dpad_left_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_button_dpad_left_action_name)
		_button_dpad_left_action_name = value
		if value != "":
			owner._actions_buttons[_button_dpad_left_action_name] = \
			owner.get_dpad_left_pressed if _button_dpad_left_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_dpad_left_realesed if _button_dpad_left_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_dpad_left_oneshot if _button_dpad_left_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_dpad_left_toggle
## Button D-PAD LEFT event action.
@export var _button_dpad_left_type: InputManagerConst._event_type_enum = InputManagerConst._event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_dpad_left_type = value
			return
		owner._actions_buttons.erase(_button_dpad_left_action_name)
		_button_dpad_left_type = value
		if _button_dpad_left_action_name != "":
			owner._actions_buttons[_button_dpad_left_action_name] = \
			owner.get_dpad_left_pressed if _button_dpad_left_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_dpad_left_realesed if _button_dpad_left_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_dpad_left_oneshot if _button_dpad_left_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_dpad_left_toggle
## Corresponding key.
@export var _button_dpad_left_key: Key = Key.KEY_LEFT

@export_subgroup("Action Button D-PAD RIGHT")
## Button D-PAD RIGHT of joystick action name.
@export_placeholder("Button D-PAD RIGHT action name") var _button_dpad_right_action_name = "D_PAD_RIGHT":
	set(value):
		if owner == null:
			_button_dpad_right_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_button_dpad_right_action_name)
		_button_dpad_right_action_name = value
		if value != "":
			owner._actions_buttons[_button_dpad_right_action_name] = \
			owner.get_dpad_right_pressed if _button_dpad_right_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_dpad_right_realesed if _button_dpad_right_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_dpad_right_oneshot if _button_dpad_right_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_dpad_right_toggle
## Button D-PAD RIGHT event action.
@export var _button_dpad_right_type: InputManagerConst._event_type_enum = InputManagerConst._event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_dpad_right_type = value
			return
		owner._actions_buttons.erase(_button_dpad_right_action_name)
		_button_dpad_right_type = value
		if _button_dpad_right_action_name != "":
			owner._actions_buttons[_button_dpad_right_action_name] = \
			owner.get_dpad_right_pressed if _button_dpad_right_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_dpad_right_realesed if _button_dpad_right_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_dpad_right_oneshot if _button_dpad_right_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_dpad_right_toggle
## Corresponding key.
@export var _button_dpad_right_key: Key = Key.KEY_RIGHT

@export_subgroup("Action Button Start")
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
			owner.get_start_pressed if _button_start_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_start_realesed if _button_start_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_start_oneshot if _button_start_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_start_toggle
## Button Start event action
@export var _button_start_type: InputManagerConst._event_type_enum = InputManagerConst._event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_start_type = value
			return
		owner._actions_buttons.erase(_button_start_action_name)
		_button_start_type = value
		if _button_start_action_name != "":
			owner._actions_buttons[_button_start_action_name] = \
			owner.get_start_pressed if _button_start_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_start_realesed if _button_start_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_start_oneshot if _button_start_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_start_toggle
## Corresponding key.
@export var _button_start_key: Key = Key.KEY_ENTER

@export_subgroup("Action Button Select")
## Button Select of joystick action name. Back to xbox and Share to ps.
@export_placeholder("Button Select action name") var _button_select_action_name = "BACK":
	set(value):
		if owner == null:
			_button_select_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_button_select_action_name)
		_button_select_action_name = value
		if value != "":
			owner._actions_buttons[_button_select_action_name] = \
			owner.get_select_pressed if _button_select_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_select_realesed if _button_select_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_select_oneshot if _button_select_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_select_toggle
## Button Select event action.
@export var _button_select_type: InputManagerConst._event_type_enum = InputManagerConst._event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_select_type = value
			return
		owner._actions_buttons.erase(_button_select_action_name)
		_button_select_type = value
		if _button_select_action_name != "":
			owner._actions_buttons[_button_select_action_name] = \
			owner.get_select_pressed if _button_select_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_select_realesed if _button_select_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_select_oneshot if _button_select_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_select_toggle
## Corresponding key.
@export var _button_select_key: Key = Key.KEY_BACKSPACE

@export_subgroup("Mouse")
## Button capture mouse.
@export var _mouse_capture_key: Key = Key.KEY_TAB
## Button mouse visible.
@export var _mouse_visble_key: Key = Key.KEY_ESCAPE


func init(_owner: InputManager) -> void:
	owner = _owner

	if owner == null:
		return

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

	if _button_left_shoulder_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_left_shoulder_action_name)
		owner._actions_buttons[_button_left_shoulder_action_name] = \
		owner.get_left_shoulder_pressed if _button_left_shoulder_type == InputManagerConst._event_type_enum.PRESSED \
		else owner.get_left_shoulder_realesed if _button_left_shoulder_type == InputManagerConst._event_type_enum.RELESED \
		else owner.get_left_shoulder_oneshot if _button_left_shoulder_type == InputManagerConst._event_type_enum.ONE_SHOT \
		else owner.get_left_shoulder_toggle

	if _button_right_shoulder_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_right_shoulder_action_name)
		owner._actions_buttons[_button_right_shoulder_action_name] = \
		owner.get_right_shoulder_pressed if _button_right_shoulder_type == InputManagerConst._event_type_enum.PRESSED \
		else owner.get_right_shoulder_realesed if _button_right_shoulder_type == InputManagerConst._event_type_enum.RELESED \
		else owner.get_right_shoulder_oneshot if _button_right_shoulder_type == InputManagerConst._event_type_enum.ONE_SHOT \
		else owner.get_right_shoulder_toggle

	if _button_left_stick_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_left_stick_action_name)
		owner._actions_buttons[_button_left_stick_action_name] = \
		owner.get_left_stick_button_pressed if _button_left_stick_type == InputManagerConst._event_type_enum.PRESSED \
		else owner.get_left_stick_button_realesed if _button_left_stick_type == InputManagerConst._event_type_enum.RELESED \
		else owner.get_left_stick_button_oneshot if _button_left_stick_type == InputManagerConst._event_type_enum.ONE_SHOT \
		else owner.get_left_stick_button_toggle

	if _button_right_stick_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_right_stick_action_name)
		owner._actions_buttons[_button_right_stick_action_name] = \
		owner.get_right_stick_button_pressed if _button_right_stick_type == InputManagerConst._event_type_enum.PRESSED \
		else owner.get_right_stick_button_realesed if _button_right_stick_type == InputManagerConst._event_type_enum.RELESED \
		else owner.get_right_stick_button_oneshot if _button_right_stick_type == InputManagerConst._event_type_enum.ONE_SHOT \
		else owner.get_right_stick_button_toggle

	if _button_a_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_a_action_name)
		owner._actions_buttons[_button_a_action_name] = \
		owner.get_button_a_pressed if _button_a_type == InputManagerConst._event_type_enum.PRESSED \
		else owner.get_button_a_realesed if _button_a_type == InputManagerConst._event_type_enum.RELESED \
		else owner.get_button_a_oneshot if _button_a_type == InputManagerConst._event_type_enum.ONE_SHOT \
		else owner.get_button_a_toggle

	if _button_b_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_b_action_name)
		owner._actions_buttons[_button_b_action_name] = \
		owner.get_button_b_pressed if _button_b_type == InputManagerConst._event_type_enum.PRESSED \
		else owner.get_button_b_realesed if _button_b_type == InputManagerConst._event_type_enum.RELESED \
		else owner.get_button_b_oneshot if _button_b_type == InputManagerConst._event_type_enum.ONE_SHOT \
		else owner.get_button_b_toggle

	if _button_x_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_x_action_name)
		owner._actions_buttons[_button_x_action_name] = \
		owner.get_button_x_pressed if _button_x_type == InputManagerConst._event_type_enum.PRESSED \
		else owner.get_button_x_realesed if _button_x_type == InputManagerConst._event_type_enum.RELESED \
		else owner.get_button_x_oneshot if _button_x_type == InputManagerConst._event_type_enum.ONE_SHOT \
		else owner.get_button_x_toggle

	if _button_y_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_y_action_name)
		owner._actions_buttons[_button_y_action_name] = \
		owner.get_button_y_pressed if _button_y_type == InputManagerConst._event_type_enum.PRESSED \
		else owner.get_button_y_realesed if _button_y_type == InputManagerConst._event_type_enum.RELESED \
		else owner.get_button_y_oneshot if _button_y_type == InputManagerConst._event_type_enum.ONE_SHOT \
		else owner.get_button_y_toggle

	if _button_dpad_up_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_dpad_up_action_name)
		owner._actions_buttons[_button_dpad_up_action_name] = \
		owner.get_dpad_up_pressed if _button_dpad_up_type == InputManagerConst._event_type_enum.PRESSED \
		else owner.get_dpad_up_realesed if _button_dpad_up_type == InputManagerConst._event_type_enum.RELESED \
		else owner.get_dpad_up_oneshot if _button_dpad_up_type == InputManagerConst._event_type_enum.ONE_SHOT \
		else owner.get_dpad_up_toggle

	if _button_dpad_down_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_dpad_down_action_name)
		owner._actions_buttons[_button_dpad_down_action_name] = \
		owner.get_dpad_down_pressed if _button_dpad_down_type == InputManagerConst._event_type_enum.PRESSED \
		else owner.get_dpad_down_realesed if _button_dpad_down_type == InputManagerConst._event_type_enum.RELESED \
		else owner.get_dpad_down_oneshot if _button_dpad_down_type == InputManagerConst._event_type_enum.ONE_SHOT \
		else owner.get_dpad_down_toggle

	if _button_dpad_left_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_dpad_left_action_name)
		owner._actions_buttons[_button_dpad_left_action_name] = \
		owner.get_dpad_left_pressed if _button_dpad_left_type == InputManagerConst._event_type_enum.PRESSED \
		else owner.get_dpad_left_realesed if _button_dpad_left_type == InputManagerConst._event_type_enum.RELESED \
		else owner.get_dpad_left_oneshot if _button_dpad_left_type == InputManagerConst._event_type_enum.ONE_SHOT \
		else owner.get_dpad_left_toggle

	if _button_dpad_right_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_dpad_right_action_name)
		owner._actions_buttons[_button_dpad_right_action_name] = \
		owner.get_dpad_right_pressed if _button_dpad_right_type == InputManagerConst._event_type_enum.PRESSED \
		else owner.get_dpad_right_realesed if _button_dpad_right_type == InputManagerConst._event_type_enum.RELESED \
		else owner.get_dpad_right_oneshot if _button_dpad_right_type == InputManagerConst._event_type_enum.ONE_SHOT \
		else owner.get_dpad_right_toggle

	if _button_start_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_start_action_name)
		owner._actions_buttons[_button_start_action_name] = \
		owner.get_start_pressed if _button_start_type == InputManagerConst._event_type_enum.PRESSED \
		else owner.get_start_realesed if _button_start_type == InputManagerConst._event_type_enum.RELESED \
		else owner.get_start_oneshot if _button_start_type == InputManagerConst._event_type_enum.ONE_SHOT \
		else owner.get_start_toggle

	if _button_select_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_select_action_name)
		owner._actions_buttons[_button_select_action_name] = \
		owner.get_select_pressed if _button_select_type == InputManagerConst._event_type_enum.PRESSED \
		else owner.get_select_realesed if _button_select_type == InputManagerConst._event_type_enum.RELESED \
		else owner.get_select_oneshot if _button_select_type == InputManagerConst._event_type_enum.ONE_SHOT \
		else owner.get_select_toggle


func _verify_duplicate(_actions_source: Dictionary, value: String) -> void:
	if _actions_source.has(value):
		push_error("Action name %s duplicate."%value)
